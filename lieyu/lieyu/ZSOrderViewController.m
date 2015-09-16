//
//  ZSOrderViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSOrderViewController.h"

@interface ZSOrderViewController ()

@end

@implementation ZSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuView.backgroundColor=[UIColor clearColor];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.timeLal.text=dateStr;
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    [self getMenuHrizontal];
    // Do any additional setup after loading the view from its nib.
}
-(void)getMenuHrizontal{
    NSArray *menuArrNew=@[@"待消费",@"待留位",@"待催促",@"已消费",@"退单"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5), 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGB(229, 255, 245) set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject:normalImg forKey:NOMALKEY];
        
        // 使用颜色创建UIImage //选中颜色
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject: selectedImg forKey:HEIGHTKEY];
        [itemTemp setObject: ss forKey:TITLEKEY];
        [itemTemp setObject:[NSNumber numberWithFloat:self.view.width/5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@"88"  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }

    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:self.menuView.frame ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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

- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)timeChooseAct:(UIButton *)sender {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    
    [self.view addSubview:_bgView];

    self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 266+45)];
    self.calendarView.draggble = YES;
    
    
    /*
    //左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToPreviousMonth:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [_bgView addGestureRecognizer:swipeLeft];
    
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextMonth:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [_bgView addGestureRecognizer:swipeRight];
    */
    [_bgView addSubview:self.calendarView];
    
    
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    [self.calendarLogic reloadCalendarView:self.calendarView];
    surebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT+50+266+45, SCREEN_WIDTH,45 );
    [surebutton setBackgroundColor:RGB(35, 166, 116)];
    [surebutton setTitle:@"确定" forState:0];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [surebutton addTarget:self action:@selector(SetViewDisappearForSure:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:surebutton aboveSubview:_bgView];
    
    //上下月
    monView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    monView.backgroundColor=[UIColor whiteColor];
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preBtn.frame = (CGRect){25, 3, 60, 44};
    [preBtn addTarget:self action:@selector(goToPreviousMonth:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [monView addSubview:preBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = (CGRect){235, 3, 60, 44};
    [nextBtn addTarget:self action:@selector(goToNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [monView addSubview:nextBtn];
    
    CGRect labelRect = (CGRect){110, 3, 100, 44};
    self.monthLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    self.monthLabel.textColor = [UIColor blackColor];
    [monView addSubview:self.monthLabel];
    [_bgView insertSubview:monView aboveSubview:_bgView];
    
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.calendarView cache:NO];
    monView.frame=CGRectMake(0, SCREEN_HEIGHT-266-45-50, SCREEN_WIDTH, 50);
    self.calendarView.frame= CGRectMake(0, SCREEN_HEIGHT-266-45, SCREEN_WIDTH, 266+45);
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT-45, SCREEN_WIDTH,45 );
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-266-45-50);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
    
    
//    button.backgroundColor=[UIColor clearColor];
}
//立即购买消失按钮
-(void)SetViewDisappear:(id)sender
{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        
    }
    //    if (btn.selected==NO)
    //    {
    //        [btn setImage:BundleImage(@"bt_close_n.png") forState:0];
    //        btn.selected=YES;
    //    }else{
    //        [btn setImage:BundleImage(@"bt_close_s.png") forState:0];
    //        btn.selected=NO;
    //    }
    
}
-(void)SetViewDisappearForSure:(id)sender{
    
    self.timeLal.text=[dateFormatter stringFromDate:[self.calendarLogic.selectedCalendarDay date]];
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        
    }
}

#pragma mark -

- (void)goToNextMonth:(id)sender
{
    [self.calendarLogic goToNextMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    

}

- (void)goToPreviousMonth:(id)sender
{
    [self.calendarLogic goToPreviousMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    

}
@end
