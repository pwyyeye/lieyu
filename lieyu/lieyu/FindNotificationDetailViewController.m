//
//  FindNotificationDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationDetailViewController.h"
#import "FindNotificatinDetailTableViewCell.h"
#import "LYFindHttpTool.h"
#import "FindNewMessageList.h"
#import "LPMyOrdersViewController.h"
#import "LYFriendsMessageViewController.h"
#import "ZSOrderViewController.h"
#import "LYFriendsAMessageDetailViewController.h"
#import "LYFriendsHttpTool.h"
#import "MainTabbarViewController.h"
#import "LYMyFreeOrdersViewController.h"

@interface FindNotificationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FindNotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"消息通知";  
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FindNotificatinDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindNotificatinDetailTableViewCell"];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getData{
    NSDictionary *dic = @{@"type":_type};
    __weak __typeof(self) weakSelf = self;
    [LYFindHttpTool getNotificationMessageListWithParams:dic compelte:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [weakSelf.tableView reloadData];
//        if (dataArray.count) {
            NSDictionary *dic = @{@"type":_type,@"read":@"1"};
            [LYFindHttpTool NotificationMessageListReadedWithParams:dic compelte:nil];
//        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNotificatinDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FindNotificatinDetailTableViewCell" forIndexPath:indexPath];
    FindNewMessageList *findNewMessList = _dataArray[indexPath.row];
    cell.findMessList = findNewMessList;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     FindNewMessageList *findNewMessList = _dataArray[indexPath.row];
//    FindNotificationNextDetailViewController *findNextDetailVC = [[FindNotificationNextDetailViewController alloc]init];
//    findNextDetailVC.findNewList = findNewMessList;
//    [self.navigationController pushViewController:findNextDetailVC animated:YES];
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 73;
    FindNewMessageList *findNewMessList = _dataArray[indexPath.row];
    CGSize size = [findNewMessList.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 71, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 ]} context:nil].size;
    if (size.height + 53 < 73) {
        return 73;
    }else{
        if (size.height + 53 > 96 ) {
            return 96;
        }
        return size.height + 53;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNewMessageList *_findNewList = _dataArray[indexPath.row];
    if ([_findNewList.type isEqualToString:@"1"]) {//订单1.普通用户，2.专属经理
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.userModel.usertype isEqualToString:@"1"]) {
            //            LYMyOrderManageViewController *detailVC = [[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
            LPMyOrdersViewController *detailVC = [[LPMyOrdersViewController alloc]init];
            detailVC.title=@"我的订单";  
            detailVC.orderIndex=0;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            ZSOrderViewController *orderManageViewController=[[ZSOrderViewController alloc]initWithNibName:@"ZSOrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderManageViewController animated:YES];
        }
    }else if([_findNewList.type isEqualToString:@"13"] ||[_findNewList.type isEqualToString:@"14"]) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
        NSDictionary *dic = @{@"userId":useridStr,@"messageId":_findNewList.bzId};
        __weak __typeof(self) weakSelf = self;
        [LYFriendsHttpTool friendsGetAMessageWithParams:dic compelte:^(FriendsRecentModel *friendRecentM) {
            if (friendRecentM) {
                LYFriendsAMessageDetailViewController *friendMessageDetailVC = [[LYFriendsAMessageDetailViewController alloc]init];
                friendMessageDetailVC.recentM = friendRecentM;
                friendMessageDetailVC.isFriendToUserMessage = YES;
                friendMessageDetailVC.isMessageDetail = YES;
                [weakSelf.navigationController pushViewController:friendMessageDetailVC animated:YES];
            }else{
                [MyUtil showCleanMessage:@"这条动态已被删除"];
            }
        }];
        
    }else if([_findNewList.type isEqualToString:@"15"]){
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LYMain" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"LYNavigationController"];
        app.navigationController = nav;
        app.window.rootViewController = nav;
        MainTabbarViewController *tabVC = (MainTabbarViewController *)nav.viewControllers.firstObject;
        tabVC.selectedIndex = 1;
        
    }else if([_findNewList.type isEqualToString:@"17"]){
        LYMyFreeOrdersViewController *detailVC = [[LYMyFreeOrdersViewController alloc]init];
        detailVC.orderIndex=0;
        detailVC.isFreeOrdersList=YES;
        detailVC.isManager=YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
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
