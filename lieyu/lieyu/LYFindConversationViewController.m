//
//  LYFindConversationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFindConversationViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LYYUHttpTool.h"
#import "LYChatrommAllPeopleViewController.h"
#import "BeerBarOrYzhDetailModel.h"
#import "LYCache.h"
#import "LYHomePageHttpTool.h"
#import "LYToPlayRestfulBusiness.h"
#import "BarGroupChatAllPeopleViewController.h"
#import "KxMenu.h"
#import <RongIMKit/RCIM.h>


@interface LYFindConversationViewController ()<UIActionSheetDelegate>{
    NSString *_userId_RM;//点击的融云id
    BOOL _isGroupManage;
    BOOL _notificationStatus;//通知状态

}
@property (strong, nonatomic)BeerBarOrYzhDetailModel *beerBarDetail;//酒吧数据
@property(assign,nonatomic) BOOL isShow;//顶部

@end

@implementation LYFindConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.conversationType == ConversationType_CHATROOM){//添加群成员按钮
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"群成员" style:UIBarButtonItemStylePlain target:self action:@selector(allPeople)];
        rightItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    } else if (self.conversationType == ConversationType_GROUP) {//群组
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
        [button setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
        [view addSubview:button];
        [button addTarget:self action:@selector(moreAct:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self loadBarDetail];//获取当前酒吧的数据
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



#pragma mark - 查看所有聊天室成员
- (void)allPeople{
    LYChatrommAllPeopleViewController *chatRoomAllPeopelVC = [[LYChatrommAllPeopleViewController alloc]init];
    chatRoomAllPeopelVC.chatRoomId = self.targetId;
    [self.navigationController pushViewController:chatRoomAllPeopelVC animated:YES];
}

#pragma marks ---- 查看所有成员
-(void)checkAllPeople{
    BarGroupChatAllPeopleViewController *barGroupVC = [[BarGroupChatAllPeopleViewController alloc] init];
    barGroupVC.groupID = [NSString stringWithFormat:@"%@",self.targetId];
    barGroupVC.isGroupM = _isGroupManage;
    [self.navigationController pushViewController:barGroupVC animated:YES];
    barGroupVC.navigationItem.leftBarButtonItem = [self getItem];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId{
//    NSLog(@"------>%@",userId);
    
    _userId_RM = userId;
    if(self.conversationType == ConversationType_CHATROOM){//聊天室
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *managerUserIdArray = [app.userModel.manageUserids componentsSeparatedByString:@","];//管理员账号
    for (NSString *str in managerUserIdArray) {
        if(app.userModel.userid == str.intValue){//登录的是管理员
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看",@"移除聊天室", nil];
//            [alertView show];
            if([app.userModel.imuserId isEqualToString:userId]) break;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从聊天室移除" otherButtonTitles:@"查看", nil];
            [actionSheet showInView:self.view];
            return ;
        }
    }
        [self goToPersonWithType:1];
    }else if(self.conversationType == ConversationType_GROUP){//群组
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
    }else{
        [self goToPersonWithType:0];
    }
}

#pragma mark - 跳转到用户个人界面
- (void)goToPersonWithType:(int)type{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController alloc]init];
    myFriendVC.isChatroom = type;
    myFriendVC.imUserId = _userId_RM;
    [self resignFirstResponder];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.conversationType == ConversationType_CHATROOM) {//聊天室
        switch (buttonIndex) {
            case 0://从聊天室移除
                [self removePersonFromChatRoom];
                break;
            case 1://查看
                [self goToPersonWithType:1];
                break;
            default:
                break;
        }
    } else {//群组
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
}


#pragma mark - 踢人
- (void)removePersonFromChatRoom{
//   121.40.229.133:80/portal/friendAction.do?action=expand&chatroomId=150&imuserId=130615&minute=1&SEM_LOGIN_TOKEN=g6hccy5yqo78xk3yarls7888
    
    NSDictionary *paraDic = @{@"chatroomId":self.targetId,@"imuserId":_userId_RM,@"minute":@"43200"};
    [LYYUHttpTool yuRemoveUserFromeChatRoomWith:paraDic complete:^(BOOL result) {
        
    }];
}

#pragma mark - 加载酒吧详情的数据
- (void)loadBarDetail
{
       NSArray *array = [self getDataFromLocal];
    if (array.count) {
        BeerBarOrYzhDetailModel *beerM = array.firstObject;
        _beerBarDetail = beerM;
    }
    __weak __typeof(self ) weakSelf = self;
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    [bus getBearBarOrYzhDetail:[NSNumber numberWithInt:self.targetId.integerValue] results:^(LYErrorMessage *erMsg, BeerBarOrYzhDetailModel *detailItem)
     {
         if (erMsg.state == Req_Success) {
             weakSelf.beerBarDetail = detailItem;
         }
     } failure:^(BeerBarOrYzhDetailModel *beerModel) {
         //本地加载酒吧详情数据
         weakSelf.beerBarDetail = beerModel;

     }];
}
#pragma mark - 从本地获取数据
- (NSArray *)getDataFromLocal{
    NSString *keyStr = [NSString stringWithFormat:@"%@%@",CACHE_JIUBADETAIL,self.targetId];
    NSDictionary *paraDic = @{@"lyCacheKey":keyStr};
    NSArray *dataArray = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" andSearchPara:paraDic];
    NSDictionary *dataDic = ((LYCache *)dataArray.firstObject).lyCacheValue;
    BeerBarOrYzhDetailModel *beerModel = [BeerBarOrYzhDetailModel initFormDictionary:dataDic];
    return beerModel?@[beerModel]:nil;
}

#pragma marks --- 检测用户身份（管理员或玩家）
-(void)checkUserInfo{
    NSArray *groupManage = [_beerBarDetail.groupManage componentsSeparatedByString:@","];
    //判断是否老司机
    for (NSString *userId in groupManage) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userModel.userid == userId.integerValue) {
            _isGroupManage = YES;
        } else {
            _isGroupManage = NO;
        }
    }
}

#pragma mark - 群组禁言
- (void)removePersonFromGroup{
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":_userId_RM,@"minute":@"43200"};
    __block LYFindConversationViewController *weekSelf = self;
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
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        _notificationStatus = nStatus;
    } error:^(RCErrorCode status) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
