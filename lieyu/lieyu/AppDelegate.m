//
//  AppDelegate.m
//  lieyu
//
//  Created by pwy on 15/9/5.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "LYDataStore.h"
#import "NeedHideNavigationBar.h"
#import "LYCommonHttpTool.h"
#import "DejalActivityView.h"
#import <RongIMKit/RongIMKit.h>
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "PTjoinInViewController.h"
@interface AppDelegate ()
<
UINavigationControllerDelegate,RCIMUserInfoDataSource
>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    [self setupDataStore];
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    nav.delegate = self;
    self.window.backgroundColor = [UIColor whiteColor];
    _timer=[NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(doHeart) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停
    
    //IM推送
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //AppID：wxf1e19b28e6b1613c
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx93dfab7e2f716610" appSecret:@"67e20dbce508b01bb4a934c9f38b5ac3" url:@"http://www.peikua.com"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    return YES;
}

- (void)setupDataStore
{
    [LYDataStore currentInstance];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController conformsToProtocol:@protocol(NeedHideNavigationBar)])
    {
        [viewController.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        BOOL isTabBarContrller = [viewController isKindOfClass:[UITabBarController class]];
        UIViewController *dstController = viewController;
        if (isTabBarContrller)
        {
            UITabBarController * tabBarController = (UITabBarController *)viewController;
            dstController = tabBarController.selectedViewController;
        }
        
        if (![dstController conformsToProtocol:@protocol(NeedHideNavigationBar)])
        {
            [dstController.navigationController setNavigationBarHidden:NO];
        }
        else
        {
            [dstController.navigationController setNavigationBarHidden:YES];
        }
    }
}
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_timer setFireDate:[NSDate distantPast]];//开启
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark - 心跳获取7牛key
-(void)doHeart{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app startLoading];
    [[LYCommonHttpTool shareInstance] getTokenByqiNiuWithParams:nil block:^(NSString *result) {
        _qiniu_token=result;
    }];
    
}
- (void)startLoading
{
    [DejalBezelActivityView activityViewForView:self.window];
}

- (void)stopLoading
{
    [DejalBezelActivityView removeViewAnimated:YES];
}
//获取IMToken
-(void)getImToken{
    if(_userModel){
        NSDictionary *dic=@{@"userId":[NSNumber numberWithInt:_userModel.userid]};
        [[LYCommonHttpTool shareInstance] getTokenByIMWithParams:dic block:^(NSString *result) {
            _im_token=result;
            [self connectWithToken];
        }];
    }
    
    
}
//IM连接服务器
-(void)connectWithToken{
    [[RCIM sharedRCIM] connectWithToken:_im_token success:^(NSString *userId) {
        // Connect 成功
        NSLog(@"****登录成功%@",userId);
    }
    error:^(RCConnectErrorCode status) {
        NSLog(@"****登录失败");
                                      // Connect 失败
    }
    tokenIncorrect:^() {
        NSLog(@"Token 失效的状态处理");

                             // Token 失效的状态处理
    }];
}

// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    
    
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"1";
        user.name = @"韩梅梅";
        user.portraitUri = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
        
        return completion(user);
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"sourceApplication: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    if ([sourceApplication isEqualToString:@"com.3Sixty.CallCustomURL"]){
        // 接受传过来的参数
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *rootNavi = [storyboard
                                            instantiateViewControllerWithIdentifier:@"rootNavi"];
        PTjoinInViewController *playTogetherPayViewController=[storyboard instantiateViewControllerWithIdentifier:@"PTjoinInViewController"];
        playTogetherPayViewController.title=@"拼客详情";
        [rootNavi pushViewController:playTogetherPayViewController animated:YES];
        return YES;
    }else{
        return NO;
    }
    
}
@end





