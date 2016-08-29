//
//  MineGroupViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineGroupViewController.h"
#import "MineGroupCodeViewController.h"
#import "MineGroupIntroViewController.h"
#import "UMSocial.h"
#import "LYUserHttpTool.h"
#import "CustomerModel.h"
#import "CustomerCell.h"
#import "LYMyFriendDetailViewController.h"

@interface MineGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *filterList;
@property (nonatomic, assign) BOOL isFiltered;

@end

@implementation MineGroupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initRightItemsButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的娱客帮";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self getdata];
}

- (void)initRightItemsButton{
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setImage:[UIImage imageNamed:@"add5"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    UIButton *codeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [codeButton setImage:[UIImage imageNamed:@"userSuHeMa"] forState:UIControlStateNormal];
    [codeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [codeButton addTarget:self action:@selector(codeGroup:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *codeItem = [[UIBarButtonItem alloc]initWithCustomView:codeButton];
    
    self.navigationItem.rightBarButtonItems = @[addItem,codeItem];
    
    self.introButton.layer.cornerRadius = 5;
    [self.introButton addTarget:self action:@selector(introButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 获取数据
- (void)getdata{
    _dataList = [[NSMutableArray alloc]init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dict = @{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid]};
    [[LYUserHttpTool shareInstance]getFriendsList:dict block:^(NSMutableArray *result) {
        NSMutableArray *addressBookTemp = [[NSMutableArray alloc]init];
        [addressBookTemp addObjectsFromArray:result];
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (CustomerModel *addressBook in addressBookTemp) {
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(friendName)];
            addressBook.sectionNumber = sect;
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i = 0 ; i <= highSection; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        for (CustomerModel *addressBook in addressBookTemp) {
            [((NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber]) addObject:addressBook];
        }
        for (NSMutableArray *sectionArray in sectionArrays) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(friendName)];
            [_dataList addObject:sortedSection];
        }
        if (_dataList.count <= 0) {
            weakSelf.tableView.hidden = YES;
        }else{
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - tableview的代理事件
//右侧的导航栏
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    if (_isFiltered) {
//        return nil;
//    }else{
//        return [[NSArray arrayWithObject:UITableViewIndexSearch]arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation]sectionIndexTitles]];
//    }
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return nil;
    }else{
        return [[_dataList objectAtIndex:section]count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return 0;
    }else{
        return [[_dataList objectAtIndex:section] count] ? _tableView.sectionHeaderHeight : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isFiltered) {
        return 1;
    }else{
        return [_dataList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFiltered) {
        return [_filterList count];
    }else{
        return  [[_dataList objectAtIndex:section]count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomerCell";
    
    CustomerCell *cell = (CustomerCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CustomerCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CustomerModel *addressBook = nil;
    if (_isFiltered) {
        addressBook = (CustomerModel *)[_filterList objectAtIndex:indexPath.row];
    }else{
        addressBook = (CustomerModel *)[[_dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.memberModel = addressBook;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerModel *addressBook = nil;
    if (_isFiltered) {
        addressBook = (CustomerModel*)[_filterList objectAtIndex:indexPath.row];
    }else{
        addressBook = (CustomerModel*)[[_dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    LYMyFriendDetailViewController *friendDetailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailVC.title = @"详细信息";
    friendDetailVC.type = @"0";
    friendDetailVC.customerModel = addressBook;
    friendDetailVC.userID = [NSString stringWithFormat:@"%d",addressBook.friend];
    [self.navigationController pushViewController:friendDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        [_searchBar resignFirstResponder];
    }
}


#pragma mark - searchBar代理事件
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
    for (NSArray *section in _dataList) {
        for (CustomerModel *addressBook in section) {
            if (addressBook.friendName.length >= searchText.length && searchText != nil) {
                NSComparisonResult result = [addressBook.friendName compare:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame) {
                    [_filterList addObject:addressBook];
                }
            }
        }
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (void)addGroup:(UIButton *)sender{
    /*
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"选择发布平台" message:nil cancelButtonTitle:@"发布到娱" otherButtonTitles:@"其它平台" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"我的娱客帮",@"titleName":@"分享",@"value":@"分享到娱"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            
        }else if (buttonIndex == 1){
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"我的娱客帮",@"titleName":@"分享",@"value":@"分享到其他平台"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            
            NSString *string= [NSString stringWithFormat:@"猎娱 | 中高端玩咖美女帅哥社交圈，轻奢夜生活娱乐！"];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            @try {
                [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageNamed:@"CommonIcon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
            }
            @catch (NSException *exception) {
                [MyUtil showCleanMessage:@"无法分享！"];
            }
            @finally {
                
            }
        }
    }];
    [alert show];*/
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"我的娱客帮",@"titleName":@"分享",@"value":@"分享到其他平台"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    NSString *string= [NSString stringWithFormat:@"猎娱 | 中高端玩咖美女帅哥社交圈，轻奢夜生活娱乐！"];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
    @try {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageNamed:@"CommonIcon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
    }
    @catch (NSException *exception) {
        [MyUtil showCleanMessage:@"无法分享！"];
    }
    @finally {
        
    }
}

- (void)codeGroup:(UIButton *)sender{
    MineGroupCodeViewController *mineGroupCodeVC = [[MineGroupCodeViewController alloc]initWithNibName:@"MineGroupCodeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:mineGroupCodeVC animated:YES];
}

- (void)introButtonClick:(UIButton *)sender{
    MineGroupIntroViewController *mineGroupIntroVC = [[MineGroupIntroViewController alloc]initWithNibName:@"MineGroupIntroViewController" bundle:nil];
    [self.navigationController pushViewController:mineGroupIntroVC animated:YES];
}

@end
