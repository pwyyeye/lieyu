//
//  LYBaseViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LYBaseViewController ()

@end

@implementation LYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.automaticallyAdjustsScrollViewInsets=0;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.barTintColor=RGB(64,1,120);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = YES;
//    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
//        self.navigationController.navigationBar.translucent = NO;
//            self.extendedLayoutIncludesOpaqueBars = NO;
//            self.modalPresentationCapturesStatusBarAppearance=NO;
//    }

    
    //修改的部分
//    UIColor *_inputColor0 = RGBA(109, 0, 142,0.9);
//    UIColor *_inputColor1 = RGBA(64, 1, 120,0.9);
//    CGPoint _inputPoint0 = CGPointMake(0.5, 0);
//    CGPoint _inputPoint1 = CGPointMake(0.5, 1);
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
//    layer.startPoint = _inputPoint0;
//    layer.endPoint = _inputPoint1;
//    layer.frame = CGRectMake(0, -20, 320, 64);
//    layer.zPosition=-1;
//    [self.navigationController.navigationBar.layer addSublayer:layer];
    
//    CALayer *layer=[[CALayer alloc] init];
//    layer.backgroundColor=RGB(114, 5, 147).CGColor;
//    layer.zPosition=-1;
//    [self.navigationController.navigationBar.layer addSublayer:layer];
    
//    [self.navigationController.navigationBar setBarTintColor:RGB(114, 5, 147)];
    
//    UIImage *bgImage=[UIImage imageNamed:@"navBarbg"];
 
//    UIColor *color2=[UIColor colorWithPatternImage:bgImage];
//    [self.navigationController.navigationBar setBarTintColor:RGB(255, 255, 255)];
    
//    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.navigationController.navigationBar.frame;
//    gradient.colors = [NSArray arrayWithObjects: RGB(109, 0, 142),RGB(64, 1, 120),nil];
//    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
    
    
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back2"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
//    UIImage *buttonImage = [UIImage imageNamed:@"btn_back"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
//    [button addTarget:self action: @selector(gotoBack)
//     forControlEvents:UIControlEventTouchUpInside];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
//    [view addSubview:button];
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
//    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    

    // Do any additional setup after loading the view.
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)showMessage:(NSString*) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
    
}
-(void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UserModel *)userModel{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     return  app.userModel;
}

- (void)setCustomTitle:(NSString *)title
{
    int titleTag = 1000000;
//    self.title = nil;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UILabel *label = (UILabel *)[self.navigationController.navigationBar viewWithTag:titleTag];
    if (label)
    {
        [label removeFromSuperview];
    }
    
    if (title == nil)
    {
        return ;
    }
    
    UIFont * font = navBar.titleTextAttributes[NSFontAttributeName];
    UIColor * textColor = navBar.titleTextAttributes[NSForegroundColorAttributeName];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navBar.frame.size.width, 44)];
    labelTitle.font = font;
    labelTitle.textColor = textColor;
    labelTitle.tag = titleTag;
    labelTitle.text = title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    [self.navigationController.navigationBar addSubview:labelTitle];
}
#pragma mark - Helpers

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}


-(void)initMJRefeshHeaderForGif:(MJRefreshGifHeader *) header{
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [header setImages:@[[UIImage imageNamed:@"mjRefresh"]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStateRefreshing];
}

-(void)initMJRefeshFooterForGif:(MJRefreshBackGifFooter *) footer{

    // 设置普通状态的动画图片
    [footer setImages:@[[UIImage imageNamed:@"mjRefresh"]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStateRefreshing];
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
