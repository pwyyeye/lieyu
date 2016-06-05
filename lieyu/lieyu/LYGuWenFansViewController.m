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

@interface LYGuWenFansViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_keyForData;
    NSMutableArray *_dataArray;
}
@end

@implementation LYGuWenFansViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
//type   0表示粉丝，1表示关注
- (void)viewDidLoad {
    [super viewDidLoad];
    if(_type == 0){
        self.title = @"粉丝列表";
        _keyForData = @"vipUserid";
    }else{
        self.title = @"关注列表";
        _keyForData = @"userid";
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _dataArray = [[NSMutableArray alloc]init];
    [self getData];
}

#pragma mark - getdata
- (void)getData{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dict = @{_keyForData:_userID};
        [LYAdviserHttpTool lyCheckFansWithParams:dict complete:^(NSArray *dataList) {
            NSMutableArray *addressBookTemp = [[NSMutableArray alloc]init];
            [addressBookTemp addObjectsFromArray:dataList];
            UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
            for (LYAdviserManagerBriefInfo *infoModel in addressBookTemp) {
                NSInteger sect = [theCollation sectionForObject:infoModel collationStringSelector:@selector(usernick)];
                infoModel.sectionNumber = sect;
            }
            NSInteger highSection = [[theCollation sectionTitles]count];
            NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
            for (int i = 0 ; i <= highSection; i ++) {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
                [sectionArrays addObject:sectionArray];
            }
            for (LYAdviserManagerBriefInfo *infoModel in addressBookTemp) {
                [(NSMutableArray *)[sectionArrays objectAtIndex:infoModel.sectionNumber] addObject:infoModel];
            }
            for (NSMutableArray *sectionArray in sectionArrays) {
                NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(usernick)];
                [_dataArray addObject:sortedSection];
            }
            [weakSelf.tableView reloadData];
        }];
}

#pragma mark - 右侧序列
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[NSArray arrayWithObject:UITableViewIndexSearch]arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (title == UITableViewIndexSearch) {
        [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
        return -1;
    }else{
        return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index - 1];
    }
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomerCell";
    CustomerCell *cell = (CustomerCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    LYAdviserManagerBriefInfo *infoModel = nil;
    infoModel = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.infoModel = infoModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LYAdviserManagerBriefInfo *infoModel = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    LYMyFriendDetailViewController *detailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
//    detailVC.title = @"";
    detailVC.userID = infoModel.userid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
