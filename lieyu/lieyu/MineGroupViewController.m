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
#import "YuKeGroupModel.h"
#import "HuoDongLinkViewController.h"

@interface MineGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) YuKeGroupModel *groupModel;

@property (nonatomic, strong) NSMutableArray *filterList;
@property (nonatomic, assign) BOOL isFiltered;

@property (nonatomic, strong) NSString *shareString;

@end

@implementation MineGroupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"我的娱客帮";
    [self initRightItemsButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self.searchBar setBackgroundImage:[UIImage new]];
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
    NSDictionary *dict = @{@"SEM_LOGIN_TOKEN":self.userModel.token};
    [LYUserHttpTool lyGetYukebangDataWithParams:dict complete:^(NSDictionary *result) {
        NSArray *userArray = [result objectForKey:@"groupList"];
        _groupModel = [result objectForKey:@"yukegroup"];
//        NSString *linkUrl = @"http://www.lie98.com/lieyu/zhuanti/live/recruit";
        NSString *linkUrl = [result objectForKey:@"luckdrawUrl"];
        if (![MyUtil isEmptyString:linkUrl]) {
            HuoDongLinkViewController *huodong2=[[HuoDongLinkViewController alloc] init];
            huodong2.linkUrl = linkUrl;
            huodong2.subTitle = @"抽奖";
            [weakSelf.navigationController pushViewController:huodong2 animated:YES];
        }
        if (_groupModel) {
            [_groupNumberLabel setText:[NSString stringWithFormat:@"娱客帮成员：%ld",userArray.count]];
            [_groupBriefLabel setText:[NSString stringWithFormat:@"总收益：%@",_groupModel.amount]];
        }else{
            [_groupNumberLabel setText:[NSString stringWithFormat:@"娱客帮成员：0"]];
            [_groupBriefLabel setText:[NSString stringWithFormat:@"总收益：0"]];
        }
        if (userArray.count <= 0) {
            weakSelf.tableView.hidden = YES;
        }else{
            NSMutableArray *addressBookTemp = [[NSMutableArray alloc]init];
            [addressBookTemp addObjectsFromArray:userArray];
            UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
            for (CustomerModel *addressBook in addressBookTemp) {
                NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(usernick)];
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
                NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(usernick)];
                [_dataList addObject:sortedSection];
            }
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (_isFiltered) {
//        return nil;
//    }else{
//        return [[_dataList objectAtIndex:section]count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return 0;
    }else{
        return [[_dataList objectAtIndex:section] count] ? 32 : 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    [view setBackgroundColor:COMMON_GRAY];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 32)];
    [label setTextColor:[UIColor darkTextColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setText:[[_dataList objectAtIndex:section]count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
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
    friendDetailVC.userID = [NSString stringWithFormat:@"%d",addressBook.id];
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
    __weak __typeof(self) weakSelf = self;
    if ([MyUtil isEmptyString:_shareString]) {
        [LYUserHttpTool lyGetYukebangQRCodeWithParams:nil complete:^(NSString *result) {
            if (![MyUtil isEmptyString:result]) {
                _shareString = result;
                [weakSelf shareGroup];
            }else{
                [MyUtil showPlaceMessage:@"获取分享数据失败，请稍后重试！"];
            }
        }];
    }else{
        [self shareGroup];
    }
}

- (void)shareGroup{
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"我的娱客帮",@"titleName":@"分享",@"value":@"分享到其他平台"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    NSString *string= [NSString stringWithFormat:@"猎娱 | 快来加入我的娱客帮！"];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareString;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = string;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = string;
    @try {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userModel.avatar_img]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:self];
    }
    @catch (NSException *exception) {
        [MyUtil showCleanMessage:@"无法分享！"];
    }
    @finally {
        
    }
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if (platformName == UMShareToSina || platformName == UMShareToSms) {
        socialData.shareText = [NSString stringWithFormat:@"猎娱 | 快来加入我的娱客帮！%@",_shareString];
    }
}

- (void)codeGroup:(UIButton *)sender{
    MineGroupCodeViewController *mineGroupCodeVC = [[MineGroupCodeViewController alloc]initWithNibName:@"MineGroupCodeViewController" bundle:[NSBundle mainBundle]];
    if (![MyUtil isEmptyString:_shareString]) {
        mineGroupCodeVC.codeString = _shareString;
    }
    [self.navigationController pushViewController:mineGroupCodeVC animated:YES];
}

- (void)introButtonClick:(UIButton *)sender{
    MineGroupIntroViewController *mineGroupIntroVC = [[MineGroupIntroViewController alloc]initWithNibName:@"MineGroupIntroViewController" bundle:nil];
    [self.navigationController pushViewController:mineGroupIntroVC animated:YES];
}

@end
