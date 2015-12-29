//
//  MainTabbarViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "MacroDefinition.h"
#import "LYLocationManager.h"
#import "LYUserLocation.h"
#import <MapKit/MapKit.h>
#import "UITabBarItem+CustomBadge.h"
#import "LYUserLoginViewController.h"
@interface MainTabbarViewController ()

<
    UITabBarControllerDelegate,
    UITabBarDelegate,
    LYLocationManagerDelegate
>

@property(nonatomic,strong)LYLocationManager * locationManager;
@end

@implementation MainTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewStyles];
    self.delegate=self;
    
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarChagne) name:RECEIVES_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarChagneComplete:) name:COMPLETE_MESSAGE object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postANotification) name:@"RCKitDispatchMessageNotification" object:nil];
    if([USER_DEFAULT objectForKey:@"badgeValue"]!=nil){
        NSArray *items = self.tabBar.items;
        UITabBarItem *item=[items objectAtIndex:3];
        item.badgeValue=((NSString *)[USER_DEFAULT objectForKey:@"badgeValue"]);
    }
    
}

- (void)postANotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
}

-(void)tabbarChagne{
    //单独启动新线程
//    [NSThread detachNewThreadSelector:@selector(doChange) toTarget:self withObject:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [self doChange];
    });
}

-(void)doChange{
    NSArray *items = self.tabBar.items;
    UITabBarItem *item=[items objectAtIndex:3];
    
//    if ([MyUtil isEmptyString:item.badgeValue]) {
//        item.badgeValue=[NSString stringWithFormat:@"%d",1];
//    }else{
//        if (item.badgeValue.intValue<99) {
//            item.badgeValue=[NSString stringWithFormat:@"%d",item.badgeValue.intValue+1];
//        }
//        
//    }
    NSString *count=[USER_DEFAULT objectForKey:@"badgeValue"];
    if (![MyUtil isEmptyString:count]) {
        [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",count.intValue+1]  forKey:@"badgeValue"];
    }else{
        [USER_DEFAULT setObject:@"1" forKey:@"badgeValue"];
    }
    
    if (![MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"badgeValue"]]) {
        NSString *badgeValue=(NSString *)[USER_DEFAULT objectForKey:@"badgeValue"];
        item.badgeValue=badgeValue.intValue>99?@"99":badgeValue;
        [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue.intValue>99?99:badgeValue.intValue;
    }else{
        item.badgeValue=nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
    
    
}

-(void)tabbarChagneComplete:(NSNotification*) notification{
    //单独启动新线程
    [NSThread detachNewThreadSelector:@selector(doComplete) toTarget:self withObject:nil];

}

-(void)doComplete{
    NSString *delBadgeValue=[USER_DEFAULT objectForKey:@"delBadgeValue"];
    NSString *badgeValue=[USER_DEFAULT objectForKey:@"badgeValue"];
    NSArray *items= self.tabBar.items;
    UITabBarItem *item=[items objectAtIndex:3];
    
    if (![MyUtil isEmptyString:badgeValue]) {//判断角标是否存在 －－存在
        //减去已读角标
        if (![MyUtil isEmptyString:delBadgeValue]) {
            int result=badgeValue.intValue-delBadgeValue.intValue;
            //比对已读和未读
            result<=0?[USER_DEFAULT removeObjectForKey:@"badgeValue"]:[USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",result] forKey:@"badgeValue"];
            [USER_DEFAULT removeObjectForKey:@"delBadgeValue"];
        }
        
        //根据计算结果算出新角标数量
        if ([USER_DEFAULT objectForKey:@"badgeValue"]) {
            NSString *badgeValue=(NSString *)[USER_DEFAULT objectForKey:@"badgeValue"];
            //设置应用icon角标
            [UIApplication sharedApplication].applicationIconBadgeNumber=badgeValue.intValue>99?99:badgeValue.intValue;
            //设置发现角标
            item.badgeValue=badgeValue.intValue>99?@"99":badgeValue;
        }else{
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            item.badgeValue=nil;
        }
       
    }else{//--不存在
        [USER_DEFAULT removeObjectForKey:@"badgeValue"];
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        item.badgeValue=nil;
    }
    
    
}

#pragma --mark IM消息接受
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    NSLog(@"----pass-pass%@---%d",message,left);
    NSString *needcount =[USER_DEFAULT objectForKey:@"needCountIM"];
    if (![MyUtil isEmptyString:needcount] && needcount.intValue==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
    }
    
    
}



- (void)setupViewStyles
{
    NSArray * aryImages = @[@"iNeedPlay_normal",@"PlayTogether_normal",@"biaoqian_wanyouquan_zhuangtai2",@"Find_normal",@"Mine_normal"];
    NSArray * selectedImages = @[@"iNeedPlay_selected",@"PlayTogether_selected",@"biaoqian_wanyouquan_zhuangtai1",@"Find_selected",@"Mine_selected"];

    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(114, 5, 147, 1.0), NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(114, 5, 147, 0.3), NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    int i = 0;
    for (UITabBarItem *item in self.tabBar.items)
    {
        item.image = [[UIImage imageNamed:aryImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        i ++;
    }

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)onLocationUpdated:(CLLocation *)location
{
    [LYUserLocation instance].currentLocation = location;
    __weak __typeof(self) weakSelf = self;
    [self.locationManager reverseGeocode:location completionHandle:^(NSArray *placemarks, NSError *error)
     {
         MKPlacemark *pk = [placemarks firstObject];
         if (pk) {
             [LYUserLocation instance].city = pk.locality;
             if (pk.locality) {
                 [weakSelf.locationManager stopUpdateLocation];
             }
         }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    item.imageInsets = UIEdgeInsetsZero;
//    item.imageInsets = UIEdgeInsetsMake(-3, 0, 4, 0);
//    item.titlePositionAdjustment = UIOffsetMake(0, -5);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - tabBarController delegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.lastSelectIndex=self.selectedIndex;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"----pass-tabBarController%d---",self.selectedIndex);
    if (self.selectedIndex==2||self.selectedIndex==3||self.selectedIndex==4) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if([MyUtil isEmptyString:app.s_app_id]){
            LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
//            [self.navigationController presentViewController:login animated:YES completion:^{
//               
//            }];
            login.delegate=self;
            [self.navigationController pushViewController:login animated:YES];
            
        }

    }
    
}

-(void)loginSuccess:(BOOL)isLoginSucces{
    if (isLoginSucces) {
        
    }else{
        self.selectedIndex=_lastSelectIndex;
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //用户退出以后 返回到首页
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([MyUtil isEmptyString:app.s_app_id]){
        self.selectedIndex=0;
    }
}
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //用户退出以后 返回到首页
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([MyUtil isEmptyString:app.s_app_id]){
        self.selectedIndex=0;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVES_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMPLETE_MESSAGE object:nil];
}

@end
