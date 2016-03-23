//
//  LYNavigationController.m
//  lieyu
//
//  Created by pwy on 15/12/15.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNavigationController.h"

@interface LYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = YES;
    
    //修改的部分
   /* UIColor *_inputColor0 = RGBA(109, 0, 142,0.9);
    UIColor *_inputColor1 = RGBA(64, 1, 120,0.9);
    CGPoint _inputPoint0 = CGPointMake(0.5, 0);
    CGPoint _inputPoint1 = CGPointMake(0.5, 1);
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = _inputPoint0;
    layer.endPoint = _inputPoint1;
    layer.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    layer.zPosition=-1;
    [self.navigationBar.layer addSublayer:layer]; */
    

   /* UIImage *bgImage=[UIImage imageNamed:@"navBarbg"];
    
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];*/
    
//    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,-20, SCREEN_WIDTH, 90)];
//    _navBar.translucent = YES;
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    _navBar = [[UIVisualEffectView alloc]initWithEffect:effect];
//    _navBar.backgroundColor = [UIColor blackColor];
//    _navBar.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
//    [self.navigationBar addSubview:_navBar];
    
//    _navBar.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
//    _navBar.layer.shadowOffset = CGSizeMake(0, 0.5);
//    _navBar.layer.shadowOpacity = 0.1;
//    _navBar.layer.shadowRadius = 1;
    //返回的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    //设置标题颜色
    
    UIColor * color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.delegate=self;
    
    
}


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
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

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //    [self.navigationController setNavigationBarHidden:NO];
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            //            [lastController viewWillDisappear:animated];
        }
        
        
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    //    [viewController viewWillAppear:animated];
    
    
}

@end
