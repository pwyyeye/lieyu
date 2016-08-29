//
//  LYAddFriendByAddressBookViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAddFriendByAddressBookViewController.h"
#import "LYAddFriendTableViewCell.h"
#import "AddressBookModel.h"
#import "LYUserHttpTool.h"
#import <MessageUI/MessageUI.h>
#import "ZSBirthdayManagerViewController.h"

@interface LYAddFriendByAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>
//筛选
@property (nonatomic, strong) NSMutableArray *filterList;
@property (nonatomic, assign) BOOL isFiltered;

@end

@implementation LYAddFriendByAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    self.title = @"手机通讯录";
    [_tableView registerNib:[UINib nibWithNibName:@"LYAddFriendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LYAddFriendTableViewCell"];
    if (!_isBirthday) {
        //如果不是从生日导出列表进来，则需要自己导入通讯录
    }
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isFiltered){
        return _filterList.count;
    }else{
        return _dataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYAddFriendTableViewCell *addFriendTableViewCell = [_tableView dequeueReusableCellWithIdentifier:@"LYAddFriendTableViewCell" forIndexPath:indexPath];
    AddressBookModel *bookModel;
    if (_isFiltered) {
        bookModel = [_filterList objectAtIndex:indexPath.row];
    }else{
        bookModel = [_dataList objectAtIndex:indexPath.row];
    }
    addFriendTableViewCell.addressBook = bookModel;
    addFriendTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [addFriendTableViewCell.statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    addFriendTableViewCell.statusButton.tag = indexPath.row;
    return addFriendTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        [_searchBar resignFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - searchBar的代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _isFiltered = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isFiltered = YES;
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        [searchBar resignFirstResponder];
        _isFiltered = NO;
        [self.tableView reloadData];
    }else{
        _isFiltered = YES;
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - 筛选
- (void)filterContentForSearchText:(NSString *)searchText{
    _filterList = [[NSMutableArray alloc]init];
    for (AddressBookModel *addressBook in _dataList) {
        if (addressBook.name.length >= searchText.length && searchText != nil) {
            NSComparisonResult result = [addressBook.name compare:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame) {
                [_filterList addObject:addressBook];
            }
        }
    }
    [_tableView reloadData];
}

#pragma mark - 按钮事件
- (void)statusButtonClick:(UIButton *)button{
    AddressBookModel *bookModel ;
    if (_filterList) {
        bookModel = [_filterList objectAtIndex:button.tag];
    }else{
        bookModel = [_dataList objectAtIndex:button.tag];
    }
    UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
    if (bookModel.appUserType == 1){
        bookModel.appUserType = 2;
        NSDictionary *dict = @{@"friendUserid":bookModel.userid,
                               @"type":@"5",
                               @"message":[NSString stringWithFormat:@"我是%@",userModel.usernick]};
        __weak __typeof(self) weakSelf = self;
        //关注？？现在用的是打招呼接口
        [[LYUserHttpTool shareInstance] addFriends:dict complete:^(BOOL result) {
            if(result){
                [MyUtil showMessage:@"发送请求成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else if (bookModel.appUserType == 0){
        LYAddFriendTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
        cell.addressBook = bookModel;
        //发信息
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *sendMessageVC = [[MFMessageComposeViewController alloc]init];
            sendMessageVC.recipients = @[bookModel.mobile];
            sendMessageVC.body = @"我在【猎娱】玩嗨了！在这里您可以找到各式各样的酒吧，有最专业的顾问为您服务，这里有最劲爆的夜店直播，在这里您将被万众瞩目！一群帅哥、美女正在等着您，有了它不再担心今夜去哪玩！小伙伴们今晚我们就在猎娱相聚吧！\n下载地址:http://dwz.cn/416cX8";
            sendMessageVC.messageComposeDelegate = self;
            [self presentViewController:sendMessageVC animated:YES completion:nil];
        }
    }
}

#pragma mark - MFMessageComposeViewController的代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultSent:
            [MyUtil showPlaceMessage:@"邀请成功！"];
            break;
        case MessageComposeResultFailed:
            [MyUtil showPlaceMessage:@"邀请失败，请稍后重试！"];
            break;
        case MessageComposeResultCancelled:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)BaseGoBack{
    __weak __typeof(self) weakSelf = self;
    NSLog(@"count:%ld",self.navigationController.viewControllers.count)
    ;    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZSBirthdayManagerViewController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
        if (*stop == NO && idx + 1 == weakSelf.navigationController.viewControllers.count) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } ];
}

@end
