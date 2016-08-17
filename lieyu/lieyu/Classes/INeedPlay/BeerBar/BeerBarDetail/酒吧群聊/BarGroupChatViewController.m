//
//  BarGroupChatViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BarGroupChatViewController.h"
#import "BarGroupChatAllPeopleViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LYYUHttpTool.h"
#import "KxMenu.h"
#import <RongIMKit/RCIM.h>
#import "RCMessageContent.h"

@interface BarGroupChatViewController ()<UIActionSheetDelegate>
{
    NSString *_userId_RM;
    BOOL _isGroupManage;
    BOOL _notificationStatus;//通知状态
}

@property(assign,nonatomic) BOOL isShow;//顶部

@end

@implementation BarGroupChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    RCMessageContent *messageContent = [[RCMessageContent alloc] init];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        _notificationStatus = nStatus;
    } error:^(RCErrorCode status) {
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.subviews[0].frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    //判断是否老司机
    for (NSString *userId in _groupManage) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userModel.userid == userId.integerValue) {
            _isGroupManage = YES;
        } else {
            _isGroupManage = NO;
        }
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(moreAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
    
    /*
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 50);
    [right addTarget:self action:@selector(checkAllPeople) forControlEvents:UIControlEventTouchUpInside];
    [right setImage:[UIImage imageNamed:@"列表"] forState:(UIControlStateNormal)];
//    right.titleLabel.font = [UIFont systemFontOfSize:13];
//    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    UIButton *quitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBut.frame = CGRectMake(0, 0,30, 50);
    [quitBut addTarget:self action:@selector(quitFromChatRoom) forControlEvents:UIControlEventTouchUpInside];
//    [quitBut setTitle:@"老司机列表" forState:UIControlStateNormal];
    [quitBut setImage:[UIImage imageNamed:@"退出"] forState:(UIControlStateNormal)];
//    [quitBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *quitItem = [[UIBarButtonItem alloc]initWithCustomView:quitBut];
    self.navigationItem.rightBarButtonItems = @[quitItem,rightItem];
     */
}

#pragma mark ---- 顶部按钮
- (void)moreAct:(id)sender{
    if (_isShow) {
        [KxMenu dismissMenu];
        _isShow=NO;
        return;
    }
    _isShow=YES;
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"老司机列表"
                     image:[UIImage imageNamed:@"列表"]
                    target:self
                    action:@selector(checkAllPeople)],
      _notificationStatus?
      [KxMenuItem menuItem:@"关闭通知"
                     image:[UIImage imageNamed:@"关闭通知"]
                    target:self
                    action:@selector(notificationChoose)]:[KxMenuItem menuItem:@"打开通知"
                                                                image:[UIImage imageNamed:@"打开通知"]
                                                               target:self
                                                               action:@selector(notificationChoose)],
      
      [KxMenuItem menuItem:@"退出群组"
                     image:[UIImage imageNamed:@"退出"]
                    target:self
                    action:@selector(quitFromGroup)]
      
      ];
    for (KxMenuItem *item in menuItems) {
        item.foreColor = [UIColor blackColor];
    }
    //    KxMenuItem *first = menuItems[0];
    
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:RGBA(246, 246, 246, 1)];
    [KxMenu setTitleFont:[UIFont italicSystemFontOfSize:13]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(SCREEN_WIDTH-75, 64, 100,0)
                 menuItems:menuItems];
}

#pragma marks ---- 查看所有成员
-(void)checkAllPeople{
    BarGroupChatAllPeopleViewController *barGroupVC = [[BarGroupChatAllPeopleViewController alloc] init];
    barGroupVC.groupID = [NSString stringWithFormat:@"%@",self.targetId];
    barGroupVC.isGroupM = _isGroupManage;
    [self.navigationController pushViewController:barGroupVC animated:YES];
    barGroupVC.navigationItem.leftBarButtonItem = [self getItem];
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(BaseGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}

- (void)BaseGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) didTapCellPortrait:(NSString *)userId
{
    _userId_RM = userId;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.userModel.imuserId isEqualToString:userId]) {//是自己直接返回
        return;
    } else {
        if (!_isGroupManage) {//普通用户
            [self goToPersonWithType:1];
            return;
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看" otherButtonTitles:@"禁言一个月", nil];
            [actionSheet showInView:self.view];
            return ;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://查看
            [self goToPersonWithType:1];
            break;
        case 1://禁言
            if (_isGroupManage) {
                [self removePersonFromGroup];
            }
            break;
        default:
            break;
    }
}

#pragma mark --- 查看
- (void)goToPersonWithType:(int)type{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController alloc]init];
    myFriendVC.isChatroom = type;
    myFriendVC.imUserId = _userId_RM;
    [self resignFirstResponder];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 群组禁言
- (void)removePersonFromGroup{
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":_userId_RM,@"minute":@"43200"};
    __block BarGroupChatViewController *weekSelf = self;
    [LYYUHttpTool yuAddLogInWith:paraDic complete:^(NSDictionary *dic) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示：该用户将被禁言1个月" message:@"禁言成功！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:alertSure];
        [weekSelf presentViewController:alertVC animated:YES completion:nil];
    }];
}

#pragma marks --- 通知
-(void)notificationChoose{
    NSLog(@"111111111111--%d", _notificationStatus);

    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationType targetId:self.targetId isBlocked:_notificationStatus success:^(RCConversationNotificationStatus nStatus) {
        _notificationStatus = nStatus;
        NSLog(@"222222222222222--%d", _notificationStatus);

    } error:^(RCErrorCode status) {
    }];
    NSLog(@"333333333333333--%d", _notificationStatus);
//    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
//        _notificationStatus = nStatus;
//    } error:^(RCErrorCode status) {
//    }];
}

#pragma mark - 退出群组
- (void)quitFromGroup{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":app.userModel.imuserId};
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出群组，不再接收该群组消息？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [LYYUHttpTool yuQuitGroupWith:paraDic complete:^(NSString *str) {
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *alertQuit = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVC addAction:alertSure];
    [alertVC addAction:alertQuit];
    [self presentViewController:alertVC animated:YES completion:nil];
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
