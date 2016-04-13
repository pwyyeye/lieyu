//
//  FindNotificationNextDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationNextDetailViewController.h"
#import "FindNewMessageList.h"
#import "LYMyOrderManageViewController.h"
#import "MainTabbarViewController.h"
#import "LYFriendsMessageViewController.h"
#import "ZSOrderViewController.h"
#import "LPMyOrdersViewController.h"

@interface FindNotificationNextDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UIView *View_bg;
@property (weak, nonatomic) IBOutlet UILabel *label_content;

@end

@implementation FindNotificationNextDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知详情";
    // Do any additional setup after loading the view from its nib.
    _label_title.text = _findNewList.title;
    _label_time.text = _findNewList.createDate;
    _label_content.text = _findNewList.content;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_View_bg addGestureRecognizer:tapGes];
}

- (void)tapClick{
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
        LYFriendsMessageViewController *messageVC = [[LYFriendsMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
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
