//
//  LYGuWenFansViewController.m
//  lieyu
//
//  Created by 狼族 on 16/6/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenFansViewController.h"
#import "LYAdviserHttpTool.h"
#import "LYAdviserManagerBriefInfo.h"
#import "CustomerCell.h"
#import "LYMyFriendDetailViewController.h"
#import "UserModel.h"
#import "LYFriendsRecommendTableViewCell.h"

@interface LYGuWenFansViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSString *_keyForData;
    NSMutableArray *_dataArray;
    UserModel *_selectModel;
}
@end

@implementation LYGuWenFansViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if(_type == 0){
        self.title = @"粉丝列表";
        _keyForData = @"vipUserid";
    }else{
        self.title = @"关注列表";
        _keyForData = @"userid";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
//type   0表示粉丝，1表示关注
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COMMON_GRAY];
    [self.tableView setBackgroundColor:COMMON_GRAY];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getData];
}

- (void)initDataListWithArray:(NSArray *)dataList{
//    NSMutableArray *addressBookTemp = [[NSMutableArray alloc]init];
//    [addressBookTemp addObjectsFromArray:dataList];
//    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//    for (LYAdviserManagerBriefInfo *infoModel in addressBookTemp) {
//        NSInteger sect = [theCollation sectionForObject:infoModel collationStringSelector:@selector(usernick)];
//        infoModel.sectionNumber = sect;
//    }
//    NSInteger highSection = [[theCollation sectionTitles]count];
//    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
//    for (int i = 0 ; i <= highSection; i ++) {
//        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//        [sectionArrays addObject:sectionArray];
//    }
//    for (LYAdviserManagerBriefInfo *infoModel in addressBookTemp) {
//        [(NSMutableArray *)[sectionArrays objectAtIndex:infoModel.sectionNumber] addObject:infoModel];
//    }
//    for (NSMutableArray *sectionArray in sectionArrays) {
//        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(usernick)];
//        [_dataArray addObject:sortedSection];
    //    }
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:dataList];
}

#pragma mark - getdata
- (void)getData{
    __weak __typeof(self)weakSelf = self;
    if (_type == 0) {
        //获取粉丝
        [LYAdviserHttpTool lyGetNewFansListWithParams:nil complete:^(NSArray *dataList) {
            if (dataList.count <= 0) {
                [_kongLabel setText:@"您还没有粉丝哦～赶紧去直播吧！"];
                _tableView.hidden = YES;
            }else{
                _tableView.hidden = NO;
                [weakSelf initDataListWithArray:dataList];
                [weakSelf.tableView reloadData];
            }
        }];
    }else if (_type == 1){
        //获取关注
        [LYAdviserHttpTool lyGetNewFollowsListWithParams:nil complete:^(NSArray *dataList) {
            if (dataList.count <= 0) {
                [_kongLabel setText:@"您还没有关注任何人哦～"];
                _tableView.hidden = YES;
            }else{
                _tableView.hidden = NO;
                [weakSelf initDataListWithArray:dataList];
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

#pragma mark - 右侧序列
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return [[NSArray arrayWithObject:UITableViewIndexSearch]arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    if (title == UITableViewIndexSearch) {
//        [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
//        return -1;
//    }else{
//        return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index - 1];
//    }
//}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYFriendsRecommendTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LYFriendsRecommendTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsRecommendTableViewCell" owner:nil options:nil]firstObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.addCareButton.tag = indexPath.row;
    [cell.addCareButton addTarget:self action:@selector(UserActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UserModel *infoModel = (UserModel *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.FanOrCareModel = infoModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [[_dataArray objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return [[_dataArray objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *infoModel = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    LYMyFriendDetailViewController *detailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
//    detailVC.title = @"";
    detailVC.userID = [NSString stringWithFormat:@"%d",infoModel.id];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 点击事件
- (void)UserActionButtonClick:(UIButton *)button{
    _selectModel = [[_dataArray objectAtIndex:0] objectAtIndex:button.tag];
//    UserModel *userModel = [[_dataArray objectAtIndex:0] objectAtIndex:button.tag];
    if (_selectModel.id == self.userModel.userid) {
        [MyUtil showPlaceMessage:@"不能对自己进行操作哦～"];
    }else{
        if ([_selectModel.friendStatus isEqualToString:@"0"] || [_selectModel.friendStatus isEqualToString:@"2"]) {
            //添加关注
            __weak __typeof(self)weakSelf = self;
            NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%d",_selectModel.id]};
            [LYAdviserHttpTool lyAddCollectWithParams:dict complete:^(BOOL result) {
                if (result) {
                    weakSelf.userModel.collectNum = [NSString stringWithFormat:@"%d",[weakSelf.userModel.collectNum intValue] + 1];
                    [weakSelf getData];
                }else{
                    [MyUtil showPlaceMessage:@"关注失败，请稍后重试！"];
                }
            }];
        }else if ([_selectModel.friendStatus isEqualToString:@"1"] || [_selectModel.friendStatus isEqualToString:@"3"]){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定不再关注此人" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
            [actionSheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (_selectModel) {
            //取消关注
            __weak __typeof(self)weakSelf = self;
            NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%d",_selectModel.id]};
            [LYAdviserHttpTool lyDeleteCollectWithParams:dict complete:^(BOOL result) {
                if (result) {
                    weakSelf.userModel.collectNum = [NSString stringWithFormat:@"%d",[weakSelf.userModel.collectNum intValue] - 1];
                    [weakSelf getData];
                }else{
                    [MyUtil showPlaceMessage:@"取消关注失败，请稍后重试！"];
                }
            }];
        }
    }
}

@end
