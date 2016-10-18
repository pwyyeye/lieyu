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
#import "RCIM.h"
#import "barChatroomMoreView.h"

/**
 *  文本cell标示
 */
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";

/**
 *  小灰条提示cell标示
 */
static NSString *const rcTipMessageCellIndentifier = @"rcTipMessageCellIndentifier";

/**
 *  礼物cell标示
 */
static NSString *const rcGiftMessageCellIndentifier = @"rcGiftMessageCellIndentifier";



@interface BarGroupChatViewController ()<UIActionSheetDelegate,RCIMGroupMemberDataSource>
{
    NSString *_userId_RM;
    BOOL _isGroupManage;
    BOOL _notificationStatus;//通知状态
    barChatroomMoreView *_barcahtMoreView;//选项菜单
}

@property(assign,nonatomic) BOOL isShow;//顶部

@end

@implementation BarGroupChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    RCMessageContent *messageContent = [[RCMessageContent alloc] init];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        _notificationStatus = nStatus;
    } error:^(RCErrorCode status) {
    }];
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    [RCIM sharedRCIM].groupMemberDataSource = self;
    //    [self getAllMembersOfGroup:[NSString stringWithFormat:@"%@",self.targetId] result:^(NSArray<NSString *> *userIdList) {
    //
    //    }];
    
    self.title = _titleName;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.subviews[0].frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.subviews[0].backgroundColor = [UIColor clearColor];
    
//    UIImage *back = [UIImage imageNamed:[NSString stringWithFormat:@"backimage.png"]];
//    UIImageView *backimg = [[UIImageView alloc] initWithImage:back];
//    backimg.userInteractionEnabled = YES;
//    backimg.frame = self.view.bounds;
//    [self.view addSubview:backimg];
//    [self.view sendSubviewToBack:backimg];
    
    
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
    [button setImage:[UIImage imageNamed:@"more2"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(moreAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
    
 
}

#pragma mark ---- 顶部按钮

//-(void)moreAct:(id)sender {
//    if (_isShow) {
//        [_barcahtMoreView removeFromSuperview];
//        _barcahtMoreView = nil;
//    }
//    _barcahtMoreView = [[[NSBundle mainBundle] loadNibNamed:@"barChatroomMoreView" owner:self options:nil] lastObject];
//    _barcahtMoreView.frame = CGRectMake(SCREEN_WIDTH - 125, 64, 119, 149);
//    _barcahtMoreView.backgroundColor = [UIColor clearColor];
//    [self .view addSubview:_barcahtMoreView];
//}

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
                     image:[UIImage imageNamed:@"chatPerson"]
                    target:self
                    action:@selector(checkAllPeople)],
      _notificationStatus?
      [KxMenuItem menuItem:@"关闭通知"
                     image:[UIImage imageNamed:@"chatNotification"]
                    target:self
                    action:@selector(notificationChoose)]:[KxMenuItem menuItem:@"打开通知"
                                                                         image:[UIImage imageNamed:@"chatNotification"]
                                                                        target:self
                                                                        action:@selector(notificationChoose)],
      [KxMenuItem menuItem:@"退出群组"
                     image:[UIImage imageNamed:@"quitChat"]
                    target:self
                    action:@selector(quitFromGroup)]
      ];
    for (KxMenuItem *item in menuItems) {
        item.foreColor = [UIColor whiteColor];
    }
    //    KxMenuItem *first = menuItems[0];
    
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:RGBA(72, 70, 70, 1)];
    [KxMenu setTitleFont:[UIFont italicSystemFontOfSize:15]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(SCREEN_WIDTH-90,64, 129,0)
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
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationType targetId:self.targetId isBlocked:_notificationStatus success:^(RCConversationNotificationStatus nStatus) {
        _notificationStatus = nStatus;
        
    } error:^(RCErrorCode status) {
    }];

}

#pragma mark - 退出群组
- (void)quitFromGroup{
    __weak __typeof(self)weakSelf = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":app.userModel.imuserId};
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出群组，不再接收该群组消息？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [LYYUHttpTool yuQuitGroupWith:paraDic complete:^(NSString *str) {
            
        }];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *alertQuit = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVC addAction:alertSure];
    [alertVC addAction:alertQuit];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark -- 自定义

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
