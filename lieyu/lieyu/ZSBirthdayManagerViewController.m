//
//  ZSBirthdayManagerViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSBirthdayManagerViewController.h"
#import "ZSAddBirthdayViewController.h"
#import "ZSBirthdayTableViewCell.h"
#import "ZSAddressBookAddViewController.h"
#import "ZSManageHttpTool.h"
#import "ZSBirthdayWishView.h"
#import <MessageUI/MessageUI.h>

#define PAGE_SIZE 20

@interface ZSBirthdayManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>
{
    int _page;
    
    NSMutableArray *_filteredListContent;
    NSMutableString *_name;
}

@property (nonatomic, strong) NSMutableArray *dataList;//数据数组
@property (nonatomic, strong) NSMutableArray *typeList;//sectionTitle数组
@property (nonatomic, strong) UITableView *smallTableview;


@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *wishviewArray;

@end

@implementation ZSBirthdayManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRightItemsButton];
    [self initRefresh];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    [_searchBar setBackgroundImage:[UIImage new]];
    _name = [[NSMutableString alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"ZSBirthdayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZSBirthdayTableViewCell"];
    _typeList = [[NSMutableArray alloc]initWithArray:@[@"7天内",@"30天内",@"其他"]];
    _filteredListContent = [NSMutableArray new];
    [self getTodayBirthday];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"生日管家";
    _page = 1 ;
    [self getData];
}

#pragma mark - 获取数据
- (void)getTodayBirthday{
    __weak __typeof(self) weakSelf = self;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    [USER_DEFAULT setObject:@"" forKey:@"todayBirthdaySendWish"];
    if (![USER_DEFAULT objectForKey:@"todayBirthdaySendWish"] || ![[USER_DEFAULT objectForKey:@"todayBirthdaySendWish"] isEqualToString:dateString]) {
        //没有出现过送祝福的界面
        [[ZSManageHttpTool shareInstance]zsGetTodayFriendBirthdayWithParams:nil complete:^(NSArray *result) {
            [USER_DEFAULT setObject:dateString forKey:@"todayBirthdaySendWish"];
            if (result.count > 0) {
                _wishviewArray = [[NSMutableArray alloc]init];
                _todayBirthdayWishList = [[NSMutableArray alloc]initWithArray:result];
                _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [_backgroundView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
                [weakSelf.view addSubview:_backgroundView];
                
                int i = 0 ;
                for (AddressBookModel *model in result) {
                    ZSBirthdayWishView *birthdayWishView = [[[NSBundle mainBundle]loadNibNamed:@"ZSBirthdayWishView" owner:nil options:nil] firstObject];
                    [birthdayWishView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 127, SCREEN_HEIGHT / 2 - 150, 254, 251)];
                    birthdayWishView.bookModel = model;
                    [_wishviewArray addObject:birthdayWishView];
                    birthdayWishView.sendWishButton.tag = i ;
                    birthdayWishView.dontCareButton.tag = i ;
                    birthdayWishView.phoneButton.tag = i ;
                    [birthdayWishView.sendWishButton addTarget:self action:@selector(sendWishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [birthdayWishView.dontCareButton addTarget:self action:@selector(dontCareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [birthdayWishView.phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_backgroundView addSubview:birthdayWishView];
                    i ++;
                }
                
                UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 107, SCREEN_HEIGHT / 2 - 170, 40, 40)];
                cancelButton.layer.cornerRadius = 20;
                [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
                [cancelButton setTitle:@"✕" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
                [_backgroundView addSubview:cancelButton];
                [cancelButton addTarget:self action:@selector(removeBackgroundView) forControlEvents:UIControlEventTouchUpInside];
            }
        }];
    }
}

- (void)getData{
    NSDictionary *dict = @{@"per":[NSString stringWithFormat:@"%d",PAGE_SIZE],
                           @"p":[NSString stringWithFormat:@"%d",_page],
                           @"name":_name};
    [[ZSManageHttpTool shareInstance]zsGetFriendBirthdayWithParams:dict complete:^(NSArray *dataList) {
        if (_page == 1) {
            _dataList = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < 3 ; i ++) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [_dataList addObject:array];
            }
        }
        [[_dataList objectAtIndex:0] addObjectsFromArray:[dataList objectAtIndex:0]];
        [[_dataList objectAtIndex:1] addObjectsFromArray:[dataList objectAtIndex:1]];
        [[_dataList objectAtIndex:2] addObjectsFromArray:[dataList objectAtIndex:2]];
        [_tableView.mj_header endRefreshing];
        if (((NSMutableArray *)[dataList objectAtIndex:0]).count == 0 && ((NSMutableArray *)[dataList objectAtIndex:1]).count == 0 && ((NSMutableArray *)[dataList objectAtIndex:2]).count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        if (_page == 1 && ((NSMutableArray *)[_dataList objectAtIndex:0]).count == 0 && ((NSMutableArray *)[_dataList objectAtIndex:1]).count == 0 && ((NSMutableArray *)[_dataList objectAtIndex:2]).count == 0) {
            self.tableView.hidden = YES;
        }else{
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 初始化tableview的刷新空间
- (void)initRefresh{
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1 ;
        [weakSelf getData];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)_tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page ++;
        [weakSelf getData];
    }];
}

#pragma mark - 初始化顶部右侧按钮
- (void)initRightItemsButton{
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setImage:[UIImage imageNamed:@"add5"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBirthday:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
}

#pragma mark - 按钮点击事件
- (void)addBirthday:(UIButton *)button{
    [self searchBarHide];
    if (!_smallTableview) {
        _smallTableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 0, 0) style:UITableViewStylePlain];
        _smallTableview.dataSource = self;
        _smallTableview.delegate = self;
        _smallTableview.scrollEnabled = NO;
        [self.view addSubview:_smallTableview];
        [self smallViewShow];
    }else{
        if (_smallTableview.size.width == 0) {
            [self smallViewShow];
        }else{
            [self smallViewHide];
        }
    }
}

- (void)searchBarHide{
//    if (_searchBar.text.length <= 0) {
        [_searchBar resignFirstResponder];
//    }
}

- (void)smallViewShow{
    _smallTableview.frame = CGRectMake(SCREEN_WIDTH - 120, 0, 120, 100);
//    [UIView animateWithDuration:0.5 animations:^{
//        
//    }];
}

- (void)smallViewHide{
    _smallTableview.frame = CGRectMake(SCREEN_WIDTH, 0, 0, 0);
//    [UIView animateWithDuration:0.5 animations:^{
//    }];
}

- (void)sendWishButtonClick:(UIButton *)button{
    ZSBirthdayWishView *birthdayWishView = [_wishviewArray objectAtIndex:button.tag];
    AddressBookModel *bookModel = [_todayBirthdayWishList objectAtIndex:button.tag];
    UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
    //发信息
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *sendMessageVC = [[MFMessageComposeViewController alloc]init];
        sendMessageVC.recipients = @[bookModel.mobile];
        NSString *message = [NSString stringWithFormat:@"%@（猎娱顾问%@送上祝福）",birthdayWishView.wishTextView.text,userModel.usernick];
        sendMessageVC.body = message;
        sendMessageVC.messageComposeDelegate = self;
        [self presentViewController:sendMessageVC animated:YES completion:nil];
    }
}

- (void)dontCareButtonClick:(UIButton *)button{
    if (button.tag == 0) {
        [_backgroundView removeFromSuperview];
    }
    ZSBirthdayWishView *birthdayWishView = [_wishviewArray objectAtIndex:button.tag];
    [birthdayWishView removeFromSuperview];
}

- (void)phoneButtonClick:(UIButton *)button{
    AddressBookModel *bookModel = [_todayBirthdayWishList objectAtIndex:button.tag];
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",bookModel.mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}

- (void)removeBackgroundView{
    [_backgroundView removeFromSuperview];
}

#pragma mark - tableview代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _smallTableview) {
        return 1;
    }else{
        return _typeList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _smallTableview) {
        return 2;
    }else{
        return ((NSMutableArray *)[_dataList objectAtIndex:section]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _smallTableview) {
        UITableViewCell *cell = [_smallTableview dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = RGBA(225, 225, 225, 1);
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"手动添加"];
        }else if (indexPath.row == 1){
            [cell.textLabel setText:@"通讯录导入"];
        }
        return cell;
    }else{
        ZSBirthdayTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ZSBirthdayTableViewCell" forIndexPath:indexPath];
        AddressBookModel *addressBook = [((NSMutableArray *)[_dataList objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        cell.userModel = addressBook;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _smallTableview) {
        return 50;
    }else{
        return 55;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _smallTableview) {
        if (indexPath.row == 0) {
            [self addByInputInfomation];
        }else if (indexPath.row == 1){
            ZSAddressBookAddViewController *addressBookAddVC = [[ZSAddressBookAddViewController alloc]initWithNibName:@"ZSAddressBookAddViewController" bundle:nil];
            [self.navigationController pushViewController:addressBookAddVC animated:YES];
        }
        [self smallViewHide];
    }else{
        [self searchBarHide];
        [self smallViewHide];
    }
    //大的tableview没有选中事件
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return ((NSMutableArray *)[_dataList objectAtIndex:section]).count ? 32 : 0 ;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [view setBackgroundColor:COMMON_GRAY];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 32)];
        [label setTextColor:[UIColor darkTextColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setText:((NSMutableArray *)[_dataList objectAtIndex:section]).count ? [_typeList objectAtIndex:section] : nil];
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}

#pragma mark - 自定义cell左滑事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //小的tableview没有左滑事件
    if (tableView == _tableView) {
        editingStyle = UITableViewCellEditingStyleDelete;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    if (tableView == _tableView) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [weakSelf smallViewHide];
            [weakSelf searchBarHide];
            AddressBookModel *editModel = [[_dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSDictionary *dict = @{@"ids":editModel.id};
            [[ZSManageHttpTool shareInstance]zsDeleteFriendBirthdayWithParams:dict complete:^(BOOL result) {
                if (result) {
                    _page = 1;
                    [weakSelf getData];
                }else{
                    [MyUtil showPlaceMessage:@"删除失败，请稍后重试！"];
                }
            }];
        }];
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            ZSAddBirthdayViewController *addBirthdayVC = [[ZSAddBirthdayViewController alloc]initWithNibName:@"ZSAddBirthdayViewController" bundle:nil];
            addBirthdayVC.editModel = [[_dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            addBirthdayVC.headImage = ((ZSBirthdayTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath]).avatarImage.image;
            [weakSelf.navigationController pushViewController:addBirthdayVC animated:YES];
            [weakSelf smallViewHide];
        }];
        editAction.backgroundColor = RGBA(0, 124, 223, 1);
        return @[deleteAction,editAction];
    }else{
        return nil;
    }
}

- (void)addByInputInfomation{
    ZSAddBirthdayViewController *addBirthdayVC = [[ZSAddBirthdayViewController alloc]initWithNibName:@"ZSAddBirthdayViewController" bundle:nil];
//    addBirthdayVC.delegate = self;
    [self.navigationController pushViewController:addBirthdayVC animated:YES];
}


#pragma mark - scrollView代理事件

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self searchBarHide];
    [self smallViewHide];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self smallViewHide];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self searchBarHide];
        _name = [NSMutableString stringWithString:@""];
        _page = 1;
        [self getData];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _page = 1;
    _name = [NSMutableString stringWithString:_searchBar.text];
    [self getData];
}

#pragma mark - ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredListContent removeAllObjects];
    for (NSArray *section in _dataList) {
        for (AddressBookModel *addressBook in section)
        {
            NSComparisonResult result = [addressBook.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:addressBook];
            }
        }
    }
}


#pragma mark - MFMessageComposeViewController的代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultSent:
            [MyUtil showPlaceMessage:@"谢谢您的祝福！"];
            break;
        case MessageComposeResultFailed:
            [MyUtil showPlaceMessage:@"祝福未送出，请稍后重试！"];
            break;
        case MessageComposeResultCancelled:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
