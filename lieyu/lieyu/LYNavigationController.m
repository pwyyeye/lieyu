//
//  LYNavigationController.m
//  lieyu
//
//  Created by pwy on 15/12/15.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNavigationController.h"
#import "LYBaseTableViewController.h"
#define CJScreenHeight [UIScreen mainScreen].bounds.size.height
#define CJScreenWidth [UIScreen mainScreen].bounds.size.width

#define CJOffsetFloat  0.65// 拉伸参数
#define CJOffetDistance 100// 最小回弹距离
@interface LYNavigationController ()<UIGestureRecognizerDelegate>{
    UIPanGestureRecognizer *_panGestureRecognizer;
}
@property(nonatomic,assign) CGPoint mStartPoint;

@property(nonatomic,strong) UIImageView *mLastScreenShotView;

@property (nonatomic, strong) UIView *mBgView;

@property (nonatomic, strong) NSMutableArray *mScreenShots;

@property (nonatomic, assign) BOOL mIsMoving;

@property (nonatomic,strong) UIViewController *currentShowVC;

@end

@implementation LYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = YES;
    self.delegate = self;
    //    self.automaticallyAdjustsScrollViewInsets = NO;

    
    
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
    
    
//    self.cj_canDragBack = YES;
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didHandlePanGesture:)];
//    [recognizer delaysTouchesBegan];
//    [self.view addGestureRecognizer:recognizer];
    
//    self.interactivePopGestureRecognizer.delegate = (id)self;
}


/*

-(NSMutableArray *)mScreenShots{
    if (!_mScreenShots) {
        _mScreenShots = [NSMutableArray new];
    }
    return _mScreenShots;
}

//初始化截屏的view
-(void)initViews{
    if (!self.mBgView) {
        self.mBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.mBgView.backgroundColor = [UIColor whiteColor];
        [self.view.superview insertSubview:self.mBgView belowSubview:self.view];
    }
    self.mBgView.hidden = NO;
    if (self.mLastScreenShotView) [self.mLastScreenShotView removeFromSuperview];
    UIImage *lastScreenShot = [self.mScreenShots lastObject];
    self.mLastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    self.mLastScreenShotView.frame = (CGRect){-(CJScreenWidth*CJOffsetFloat),0,CJScreenWidth,CJScreenHeight};
    [self.mBgView addSubview:self.mLastScreenShotView];
}
//改变状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        [self.mScreenShots addObject:[self capture]];
        NSLog(@"%@",self.mScreenShots);
        //        [self pushAnimation:viewController];
        //        return;
    }
    [super pushViewController:viewController animated:animated];
    
}

-(void)pushAnimation:(UIViewController *)viewController{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.2];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [super pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}
- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    [self initViews];
    [UIView animateWithDuration:0.4 animations:^{
        [self doMoveViewWithX:CJScreenWidth];
    } completion:^(BOOL finished) {
        [self completionPanBackAnimation];
    }];
}


- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark ------------  UIPanGestureRecognizer -------

-(void)didHandlePanGesture:(UIPanGestureRecognizer *)recoginzer{
    if (  !self.cj_canDragBack) return;
    if(self.viewControllers.count <= 1) return;
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    CGFloat offsetX = touchPoint.x - self.mStartPoint.x;
    if(recoginzer.state == UIGestureRecognizerStateBegan)
    {
        [self initViews];
        _mIsMoving = YES;
        _mStartPoint = touchPoint;
        offsetX = 0;
    }
    
    if(recoginzer.state == UIGestureRecognizerStateEnded)
    {
        if (offsetX > CJOffetDistance)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:CJScreenWidth];
            } completion:^(BOOL finished) {
                [self completionPanBackAnimation];
                
                self.mIsMoving = NO;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:0];
            } completion:^(BOOL finished) {
                self.mIsMoving = NO;
                self.mBgView.hidden = YES;
            }];
        }
        self.mIsMoving = NO;
    }
    if(recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self doMoveViewWithX:0];
        } completion:^(BOOL finished) {
            self.mIsMoving = NO;
            self.mBgView.hidden = YES;
        }];
        self.mIsMoving = NO;
    }
    if (self.mIsMoving) {
        [self doMoveViewWithX:offsetX];
    }
}
-(void)doMoveViewWithX:(CGFloat)x{
    x = x>CJScreenWidth?CJScreenWidth:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    self.mLastScreenShotView.frame = (CGRect){-(CJScreenWidth*CJOffsetFloat)+x*CJOffsetFloat,0,CJScreenWidth,CJScreenHeight};
}
-(void)completionPanBackAnimation{
    [self.mScreenShots removeLastObject];
    [super popViewControllerAnimated:NO];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    self.mBgView.hidden = YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}*/

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}

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
    
    
    
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

@end
