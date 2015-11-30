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
//    self.locationManager = [[LYLocationManager alloc] init];
//    [_locationManager beginUpdateLocation:kCLLocationAccuracyBest];
//    _locationManager.locationDelegate = self;
    self.delegate=self;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarChagne) name:RECEIVES_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarChagneComplete) name:COMPLETE_MESSAGE object:nil];
    
    
}

-(void)tabbarChagne{
   NSArray *items= self.tabBar.items;
   UITabBarItem *item=[items objectAtIndex:2];
    if ([MyUtil isEmptyString:item.badgeValue]) {
        item.badgeValue=[NSString stringWithFormat:@"%d",1];
    }else{
        item.badgeValue=[NSString stringWithFormat:@"%d",item.badgeValue.intValue+1];
    }
    
    
    
}



-(void)tabbarChagneComplete{
    NSArray *items= self.tabBar.items;
    UITabBarItem *item=[items objectAtIndex:2];
    item.badgeValue=nil;

}

- (void)setupViewStyles
{
    NSArray * aryImages = @[@"icon_woyaowan",@"icon_yiqiwan",@"icon_faxian",@"icon_wode"];
    NSArray * selectedImages = @[@"icon_woyaowan_selected",@"icon_yiqiwan_selected",@"icon_faxian_selected",@"icon_wode_selected"];

    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(13, 159, 103, 1.0), NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBA(166, 166, 166, 1.0), NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    item.imageInsets = UIEdgeInsetsZero;
    item.imageInsets = UIEdgeInsetsMake(-3, 0, 4, 0);
    item.titlePositionAdjustment = UIOffsetMake(0, -5);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.lastSelectIndex=self.selectedIndex;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"----pass-tabBarController%d---",self.selectedIndex);
    if (self.selectedIndex==2||self.selectedIndex==3) {
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
