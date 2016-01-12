//
//  LYFriendsMessageViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessageViewController.h"
#import "LYNewMessageTableViewCell.h"
#import "LYFriendsHttpTool.h"
#import "LYFriendsMessageDetailViewController.h"
#import "FriendsNewsModel.h"

#define LYFriendsNewMessage @"LYNewMessageTableViewCell"

@interface LYFriendsMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setupTableViewCell];
}

- (void)setupTableViewCell{
    self.title =@"消息";
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:LYFriendsNewMessage bundle:nil] forCellReuseIdentifier:LYFriendsNewMessage];
}

- (void)getData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userId = [NSString stringWithFormat:@"%d",app.userModel.userid];
    NSDictionary *paraDic = @{@"userId":userId};
    __weak LYFriendsMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetFriendsMessageNotificationDetailWithParams:paraDic compelte:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [weakSelf.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYNewMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNewMessage forIndexPath:indexPath];
    FriendsNewsModel *friendNewM = _dataArray[indexPath.row];
    cell.friendsNesM = friendNewM;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsNewsModel *friendNewM = _dataArray[indexPath.row];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%d",app.userModel.userid],@"messageId":friendNewM.messageId};
    [LYFriendsHttpTool friendsGetAMessageWithParams:dic compelte:^(FriendsRecentModel *recentM) {
        LYFriendsMessageDetailViewController *friendDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
        friendDetailVC.recentM = recentM;
        [self.navigationController pushViewController:friendDetailVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
