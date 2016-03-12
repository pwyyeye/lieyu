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
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "SingletonTenpay.h"
#import <AVFoundation/AVFoundation.h>
#import "LYCoreDataUtil.h"
#import "LYCache.h"

#import "HuoDongViewController.h"
#import "LPUserLoginViewController.h"

@interface AppDelegate ()
<
UINavigationControllerDelegate,RCIMUserInfoDataSource
>
@end

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];

    [self loadHisData];
    [self setupDataStore];

    
    _navigationController= (UINavigationController *)self.window.rootViewController;
    _navigationController.delegate = self;
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSError *setCategoryErr=nil;
//    NSError *activationErr=nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
//    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
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
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }

    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:NO];
    //AppID：wxf1e19b28e6b1613c
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxb1f5e1de5d4778b9" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.lie98.com"];
    
    //向微信注册
    [WXApi registerApp:@"wxb1f5e1de5d4778b9" withDescription:@"猎娱"];
    [UMSocialQQHandler setQQWithAppId:@"1104853065" appKey:@"9wumIImmJdUgJn2N" url:@"http://www.lie98.com"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [self startLocation];

    //友盟推送
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    [UMessage setAutoAlert:NO];
    
    [MTA startWithAppkey:@"I9IU4CZP47CE"];
    
    [[MTAConfig getInstance] setDebugEnable:NO];
    
    //其它SDK内置启动MTA情况下需要调用下面方法,传入MTA_SDK_VERSION,并检 查返回值。
//    [MTA startWithAppkey:@"I9IU4CZP47CE" checkedSdkVersion:MTA_SDK_VERSION];
//    if([MTA startWithAppkey:@"I9IU4CZP47CE" checkedSdkVersion:MTA_SDK_VERSION]){
//        NSLog(@"MTA start");
//    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
 
    //for log
    [UMessage setLogEnabled:NO];
    
    //引导页启动
    if (![[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
        
        [self showIntroWithCrossDissolve];
        UIViewController *view=[[UIViewController alloc] init];
        view.view=_intro;
        self.window.rootViewController=view;
    }else{
        [self animationWithApp];
    }
    
    NSString *username=[USER_DEFAULT objectForKey:@"username"];
    NSString *password=[USER_DEFAULT objectForKey:@"pass"];
    if([MyUtil isEmptyString:username] || [MyUtil isEmptyString:password]){
         LPUserLoginViewController *login=[[LPUserLoginViewController alloc] initWithNibName:@"LPUserLoginViewController" bundle:nil];
        [self.navigationController pushViewController:login animated:YES];
//         self.window.rootViewController=login;
    }

    //处理消息推送
    if (launchOptions.count>0) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self takeNotification:userInfo];
    }
    
    //是否需要统计IM消息角标
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    
     return YES;
}

- (void)animationWithApp{
//    UIWindow *awindow = [UIApplication sharedApplication].delegate.window;
//    qidongye *qidongView = [[qidongye alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////    qidongView.backgroundColor = [UIColor redColor];
//    [qidongView addUntitled1Animation];
//    [awindow addSubview:qidongView];
//    [awindow bringSubviewToFront:qidongView];
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo45.jpg"]];
    imgV.tag = 10086;
    imgV.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT + 100);
    imgV.backgroundColor = RGBA(5, 5, 5, 1);
    imgV.contentMode = UIViewContentModeCenter;
    [self.window addSubview:imgV];
    
    NSMutableArray *imgNameArr = [[NSMutableArray alloc]initWithCapacity:90];
    for(int i = 1; i < 91; i ++){
        [imgNameArr addObject:[NSString stringWithFormat:@"logo%d.jpg",i]];
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    for(int i = 0; i < imgNameArr.count; i ++){
        UIImage *img =[UIImage imageNamed:imgNameArr[i]];
        [imgArr addObject:(__bridge UIImage*)img.CGImage];
    }
    
    CAKeyframeAnimation *keyA = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    keyA.duration = 3;
    keyA.delegate = self;
    keyA.values = imgArr;
    keyA.repeatCount = 1;
    [imgV.layer addAnimation:keyA forKey:nil];
    
//    imgV.animationImages = imgArr;
//    imgV.animationDuration = 3;
//    imgV.animationRepeatCount = 1;
//    [imgV startAnimating];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    UIImageView *imgV = (UIImageView *)[self.window viewWithTag:10086];
//    imgV.contentMode = UIViewContentModeScaleAspectFill;
    [UIView animateWithDuration:.5 animations:^{
        imgV.alpha = 0.0;
//        imgV.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 1.5, (SCREEN_HEIGHT + 100) * 1.5);
        [imgV removeFromSuperview];
    }];
}
  
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object{
    NSLog(@"ndifadhfjkhsajkdfaygfhrajkfhdskfjhdkjads");
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
//            NSLog(@"%@", [test objectForKey:@"State"]);
//            NSLog(@"%@", placemark.locality);
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
//    if ([viewController conformsToProtocol:@protocol(NeedHideNavigationBar)])
//    {
//        [viewController.navigationController setNavigationBarHidden:YES];
//    }
//    else
//    {
//        BOOL isTabBarContrller = [viewController isKindOfClass:[UITabBarController class]];
//        UIViewController *dstController = viewController;
//        if (isTabBarContrller)
//        {
//            UITabBarController * tabBarController = (UITabBarController *)viewController;
//            dstController = tabBarController.selectedViewController;
//        }
//        
//        if (![dstController conformsToProtocol:@protocol(NeedHideNavigationBar)])
//        {
//            [dstController.navigationController setNavigationBarHidden:NO];
//        }
//        else
//        {
//            [dstController.navigationController setNavigationBarHidden:YES];
//        }
//    }
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
    
    [UMessage registerDeviceToken:deviceToken];
}
/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"----pass-userInfo%@---",userInfo);
    
    //判断是否友盟消息推送 根据反馈信息
    /**
     userInfo{
     aps =     {
     alert = "\U5c0a\U656c\U7684xxx\U4e13\U5c5e\U7ecf\U7406\Uff0c\U4f60\U6709\U4e00\U4efd\U8ba2\U5355\Uff0c\U8bf7\U53ca\U65f6\U5904\U7406\U3002";
     sound = default;
     };
     d = uu04812144712755443811;
     p = 0;
     }*/
    [self takeNotification:userInfo];
    
}

#pragma --mark 消息推送处理
-(void)takeNotification:(NSDictionary *)dic{
   
    if ([dic objectForKey:@"aps"]&&[dic objectForKey:@"d"]) {
        [UMessage didReceiveRemoteNotification:dic];
        if([dic objectForKey:@"activity"]){
            HuoDongViewController *huodong =[[HuoDongViewController alloc] init];
            NSString *linkid=[dic objectForKey:@"activity"];
            huodong.linkid=linkid.integerValue;
            [self.navigationController pushViewController:huodong animated:YES];
        }
        [self getTTL];
        
    }else if(dic.count>0){//否则认为是im推送
//        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
//        NSString *count=[USER_DEFAULT objectForKey:@"badgeValue"];
//        if (![MyUtil isEmptyString:count]) {
//            [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",count.intValue<99?count.intValue+1:99]  forKey:@"badgeValue"];
//            [UIApplication sharedApplication].applicationIconBadgeNumber=count.intValue;
//        }else{
//            [USER_DEFAULT setObject:@"1" forKey:@"badgeValue"];
//            [UIApplication sharedApplication].applicationIconBadgeNumber=1;
//        }
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    UIApplication *app=[UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask;
//    bgTask =[app beginBackgroundTaskWithExpirationHandler:^{
//        if (bgTask!=UIBackgroundTaskInvalid) {
//            bgTask=UIBackgroundTaskInvalid;
//        }
//    }];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (bgTask!=UIBackgroundTaskInvalid) {
//            bgTask=UIBackgroundTaskInvalid;
//        }
//    });
    
//    [_timer setFireDate:[NSDate distantPast]];//开启
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *pngDir = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSArray *contents = [manager contentsOfDirectoryAtPath:pngDir error:nil];
//    NSLog(@"%@",contents);
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject]) {
        filename = [NSString stringWithFormat:@"/%@",filename];
        [manager removeItemAtPath:[pngDir stringByAppendingString:filename] error:nil];
    }
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
    
    [self forcedUpdate];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark - 心跳获取7牛key
-(void)doHeart{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app startLoading];
    
    if ([[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
        LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
        [login autoLogin];
        
        [[LYCommonHttpTool shareInstance] getTokenByqiNiuWithParams:nil block:^(NSString *result) {
            _qiniu_token=result;
        }];
        
        [[LYCommonHttpTool shareInstance] getMediaTokenByqiNiuWithParams:nil block:^(NSString *result) {
            _qiniu_media_token=result;
        }];
        
    }
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
//        NSLog(@"userid=%d",_userModel.userid);
        NSDictionary *dic=@{@"userId":[NSNumber numberWithInt:_userModel.userid]};
        [[LYCommonHttpTool shareInstance] getTokenByIMWithParams:dic block:^(NSString *result) {
            _im_token=result;
            [self connectWithToken];
        }];
    }
}

//IM连接服务器
-(void)connectWithToken{
//    NSLog(@"_im_token=%@",_im_token);
//    _im_token=@"aqw73LOC9fju/Zfr+G0uCIZ6iyJm4gkQBO3AbCIB4IoMo7IJ9CyOesCxoHF0+KU1I2fSIds0iGGsdNrAeyA1L6CePnAuGYiF";
    @try {
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
    @catch (NSException *exception) {
        NSLog(@"----pass-pass%@---",exception);
    }
    @finally {
        
    }
    
}

// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
//    LYUserHttpTool
    NSDictionary *dic = @{@"imUserId":userId};
    [[LYUserHttpTool shareInstance]getUserInfo:dic block:^(CustomerModel *result) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId =result.imUserId;
        user.name = result.name;
        user.portraitUri = result.mark;
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        completion(user);
    }];
    //看本地缓存是否存在
//    RCUserInfo *userInfo=[[RCDataBaseManager shareInstance] getUserByUserId:userId];
//    if (userInfo==nil) {
//        
//    }else{
//        NSDictionary *dic = @{@"imUserId":userId};
//        [[LYUserHttpTool shareInstance]getUserInfo:dic block:^(CustomerModel *result) {
//            RCUserInfo *user = [[RCUserInfo alloc]init];
//            user.userId =result.imUserId;
//            user.name = result.name;
//            user.portraitUri = result.mark;
//            [[RCDataBaseManager shareInstance] insertUserToDB:user];
//            
//        }];
//         completion(userInfo);
//    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:[SingletonTenpay singletonTenpay]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"sourceApplication: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    if([sourceApplication isEqualToString:@"com.tencent.mqq"]){
        return [TencentOAuth HandleOpenURL:url];
    }
    
    NSString *code = nil;
    if(![MyUtil isEmptyString:[url query]]){
        NSArray *arrayStr = [[url query] componentsSeparatedByString:@"&"];
        if (arrayStr.count>=2) {
            NSArray *arrayStr2 = [arrayStr[0] componentsSeparatedByString:@"="];
            code = arrayStr2[1]; 
        }
        
    }
    
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
    }else if([sourceApplication isEqualToString:@"com.tencent.xin"]){
        //如果是微信分享回来 无参数
        if([MyUtil isEmptyString:[url query]]){
            return NO;
        }else if(![MyUtil isEmptyString:code]){
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"weixinCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ [NSNotificationCenter defaultCenter] postNotificationName:@"weixinCode" object:nil];
            return [WXApi handleOpenURL:url delegate:self];
        }else{//如果是微信支付回来 带参数
            return [WXApi handleOpenURL:url delegate:[SingletonTenpay singletonTenpay]];
        }
        
    }else{
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
//    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
    NSLog(@"----pass-pass%@---",notification);
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
        page1.bgImage = [UIImage imageNamed:@"1_retina.jpg"];
    }else{
        page1.bgImage = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    EAIntroPage *page2 = [EAIntroPage page];
    if (isRetina) {
        page2.bgImage = [UIImage imageNamed:@"2_retina.jpg"];
    }else{
        page2.bgImage = [UIImage imageNamed:@"2.jpg"];
    }
    
    
    EAIntroPage *page3 = [EAIntroPage page];
    
    if (isRetina) {
        page3.bgImage = [UIImage imageNamed:@"3_retina.jpg"];
    }else{
        page3.bgImage = [UIImage imageNamed:@"3.jpg"];
    }
    
    EAIntroPage *page4 = [EAIntroPage page];
    
    if (isRetina) {
        page4.bgImage = [UIImage imageNamed:@"4_retina.jpg"];
    }else{
        page4.bgImage = [UIImage imageNamed:@"4.jpg"];
    }
    
//    EAIntroPage *page5 = [EAIntroPage page];
//    
//    if (isRetina) {
//        page5.bgImage = [UIImage imageNamed:@"5_retina.jpg"];
//    }else{
//        page5.bgImage = [UIImage imageNamed:@"5.jpg"];
//    }

    //    page4.titleImage = [UIImage imageNamed:@"skip-btn"];
    //
    //    page4.imgPositionY = SCREEN_HEIGHT-100;
    
    page4.customView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-122, SCREEN_WIDTH, 40)];
    _intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1,page2,page3,page4]];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-55, 0, 112, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"skip-btn"] forState:UIControlStateNormal];
    [button addTarget:_intro action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [page4.customView addSubview:button];
    [page4.customView bringSubviewToFront:button];//显示到最前面
    
    
    
    
    _intro.skipButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _intro.pageControl.currentPageIndicatorTintColor = RGB(211, 20, 237);
    _intro.pageControl.pageIndicatorTintColor = RGB(219, 217, 217);
//    _intro.pageControlY=35;
    
    [_intro setDelegate:self];
    [_intro showInView:self.window animateDuration:1.0];
}
- (void)introDidFinish{
    NSLog(@"----pass-introDidFinish%@---",@"introDidFinish");
    [USER_DEFAULT setObject:@"NO" forKey:@"firstUseApp"];
    self.window.rootViewController=_navigationController;
    
}


#pragma --mark 是否强制更新

-(void)forcedUpdate{
    [[LYUserHttpTool shareInstance] getAppUpdateStatus:nil complete:^(BOOL result) {
        if (result) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@""
                                   
                                                            message:@"有新版本，点击确定更新！"
                                   
                                                           delegate:self
                                   
                                                  cancelButtonTitle:nil
                                   
                                                  otherButtonTitles:@"确定",nil];
            
            [alert show];
        }
    }];
    
}


-(void)getDESKey{
    __weak typeof(self) weakself=self;
    [[LYUserHttpTool shareInstance] getAppDesKey:nil complete:^(NSString *result) {
        weakself.desKey=result;
    }];
    
}

-(void)getTTL{
    if (![MyUtil isEmptyString:self.s_app_id]) {
        [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
            _orderTTL=result;
            [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETE_MESSAGE object:nil];
        }];
    }
    
}

#pragma mark - alert 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/gb/app/yi-dong-cai-bian/id1056569271"]];
    }
    [alertView show];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.langzu.test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"lieyu" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lieyu.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end





