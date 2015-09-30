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
@interface AppDelegate ()
<
    UINavigationControllerDelegate
>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupDataStore];
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    nav.delegate = self;
    self.window.backgroundColor = [UIColor whiteColor];
    _timer=[NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(doHeart) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停
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
@end





