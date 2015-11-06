//
//  AppDelegate.m
//  lieyu
//
//  Created by pwy on 15/9/5.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "LYDataStore.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NeedHideNavigationBar.h"
#import "LYCommonHttpTool.h"
#import "DejalActivityView.h"
#import <RongIMKit/RongIMKit.h>
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "PTjoinInViewController.h"
#import "LYUserLoginViewController.h"
#import "CustomerModel.h"
#import "LYUserHttpTool.h"
#import "RCDataBaseManager.h"
@interface AppDelegate ()
<
UINavigationControllerDelegate,RCIMUserInfoDataSource
>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];

    [self loadHisData];
    [self setupDataStore];
//    [ZBarReaderView class];
    _navigationController= (UINavigationController *)self.window.rootViewController;
    _navigationController.delegate = self;
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
    [self startLocation];
     
    
    
    //引导页启动
    if (![[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
        [self showIntroWithCrossDissolve];
        UIViewController *view=[[UIViewController alloc] init];
        view.view=_intro;
        self.window.rootViewController=view;
    }
    
    
     return YES;
}
//开始定位
-(void)startLocation{
    if (![CLLocationManager locationServicesEnabled])
        
    {
        [MyUtil showMessage:@"请开启定位服务!"];
        //提示开启定位服务
        
        return ;
        
    }
    
    
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined
        
        && [[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        
    {
        
        if (!locationManager)
            
        {
            
            locationManager = [[CLLocationManager alloc] init];
            
        }
        
        
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            
        {
            
            [locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
            
        }
        
    }
    
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
             
             || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        
    {
        
        //提示开启当前应用定位服务
        [MyUtil showMessage:@"请开启定位服务!"];
        return ;
        
    }
    if (!locationManager)
        
    {
        
        locationManager = [[CLLocationManager alloc] init];
        
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    //    [self showMessage:@"定位失败!"];
}
//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
//    [locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    _userLocation=newLocation;
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    [self saveHisData];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"%@", placemark.locality);
            _citystr= placemark.locality;
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChange" object:nil];
    }];
    
}
#pragma mark 获取历史搜索数据
-(void)loadHisData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisLocation.plist"];
    if([fileManager fileExistsAtPath:filename]){
        _userLocation= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        _userLocation = [[CLLocation alloc]initWithLatitude:31.2 longitude:121.4];
        
    }
    
}
#pragma mark 保存历史数据
-(void)saveHisData{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisLocation.plist"];
//    NSString *filename1 = [Path stringByAppendingPathComponent:@"hiscity.plist"];
    [NSKeyedArchiver archiveRootObject:_userLocation toFile:filename];
    
    
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
/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
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
    if ([[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
            LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
            [login autoLogin];
    }
    
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
        NSLog(@"userid=%d",_userModel.userid);
        NSDictionary *dic=@{@"userId":[NSNumber numberWithInt:_userModel.userid]};
        [[LYCommonHttpTool shareInstance] getTokenByIMWithParams:dic block:^(NSString *result) {
            _im_token=result;
            
            [self connectWithToken];
        }];
    }
    
    
}
//IM连接服务器
-(void)connectWithToken{
    NSLog(@"_im_token=%@",_im_token);
    [[RCIM sharedRCIM] connectWithToken: _im_token success:^(NSString *userId) {
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
//    LYUserHttpTool
    
    //看本地缓存是否存在
    RCUserInfo *userInfo=[[RCDataBaseManager shareInstance] getUserByUserId:userId];
    if (userInfo==nil) {
        NSDictionary *dic = @{@"imUserId":userId};
        [[LYUserHttpTool shareInstance]getUserInfo:dic block:^(CustomerModel *result) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId =result.imUserId;
            user.name = result.name;
            user.portraitUri = result.mark;
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            return completion(user);
        }];
    }else{
        NSDictionary *dic = @{@"imUserId":userId};
        [[LYUserHttpTool shareInstance]getUserInfo:dic block:^(CustomerModel *result) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId =result.imUserId;
            user.name = result.name;
            user.portraitUri = [MyUtil getQiniuUrl:result.mark width:80 andHeight:80];
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            
        }];
        return completion(userInfo);
    }
    
    
    
    
        
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"sourceApplication: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    if ([sourceApplication isEqualToString:@"com.apple.mobilesafari"]){
        // 接受传过来的参数
        NSDictionary *dic=[MyUtil getKeyValue:[url query]];
        NSString *smid=[dic objectForKey:@"id"];
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        PTjoinInViewController *playTogetherPayViewController=[storyboard instantiateViewControllerWithIdentifier:@"PTjoinInViewController"];
        playTogetherPayViewController.title=@"拼客详情";
        playTogetherPayViewController.smid=smid.intValue;
        [navigationController pushViewController:playTogetherPayViewController animated:YES];
        return YES;
    }else{
        return NO;
    }
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}
#pragma mark--引导页
- (void)showIntroWithCrossDissolve {
    //    EAIntroPage *page1 = [EAIntroPage page];
    //    page1.title = @"Hello world";
    //    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    //    page1.bgImage = [UIImage imageNamed:@"1.jpg"];
    
    EAIntroPage *page1 = [EAIntroPage page];
    if (isRetina) {
        page1.bgImage = [UIImage imageNamed:@"1_retina.png"];
    }else{
        page1.bgImage = [UIImage imageNamed:@"1"];
    }
    
    
    EAIntroPage *page2 = [EAIntroPage page];
    if (isRetina) {
        page2.bgImage = [UIImage imageNamed:@"2_retina.png"];
    }else{
        page2.bgImage = [UIImage imageNamed:@"2"];
    }
    
    
    EAIntroPage *page3 = [EAIntroPage page];
    
    if (isRetina) {
        page3.bgImage = [UIImage imageNamed:@"3_retina.png"];
    }else{
        page3.bgImage = [UIImage imageNamed:@"3"];
    }
    
    EAIntroPage *page4 = [EAIntroPage page];
    
    if (isRetina) {
        page4.bgImage = [UIImage imageNamed:@"4_retina.png"];
    }else{
        page4.bgImage = [UIImage imageNamed:@"4"];
    }
    
    //    page4.titleImage = [UIImage imageNamed:@"skip-btn"];
    //
    //    page4.imgPositionY = SCREEN_HEIGHT-100;
    
    page4.customView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-175, SCREEN_WIDTH, 40)];
    _intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1,page2,page3,page4]];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-55, 0, 110, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"skip-btn"] forState:UIControlStateNormal];
    [button addTarget:_intro action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [page4.customView addSubview:button];
    [page4.customView bringSubviewToFront:button];//显示到最前面
    
    
    
    
    _intro.skipButton = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [_intro setDelegate:self];
    [_intro showInView:self.window animateDuration:1.0];
}
- (void)introDidFinish{
    NSLog(@"----pass-introDidFinish%@---",@"introDidFinish");
    [USER_DEFAULT setObject:@"NO" forKey:@"firstUseApp"];
    self.window.rootViewController=_navigationController;
    
}
@end





