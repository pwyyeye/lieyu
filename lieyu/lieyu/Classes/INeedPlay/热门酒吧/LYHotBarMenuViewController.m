//
//  LYHotBarMenuViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarMenuViewController.h"
#import "LYLMenuDropViewController.h"

@interface LYHotBarMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (nonatomic,strong) UIViewController *controller;
@property (nonatomic,strong) LYLMenuDropViewController *menuDropVC;

@end

@implementation LYHotBarMenuViewController

- (instancetype)initWithFrame:(CGRect)frame :(UIViewController *)controller{
    self = [super init];
    if (self) {
        _controller = controller;
        self.view.frame = frame;
    }
    return self;
}

- (IBAction)test:(id)sender {
    
    NSLog(@"---------%@",sender);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:_btn_aroundMe];
    [self.view bringSubviewToFront:_btn_allPlace];
    [self.view bringSubviewToFront:_btn_music];
    
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"%@",view.class);
//    };
    // Do any additional setup after loading the view from its nib.
    _view_line.bounds = CGRectMake(0, 0, 320, 0.5);
    NSLog(@"--------->%@",NSStringFromCGRect(self.view.frame));
//    _menuVC = [[LYHotBarMenuViewController alloc]init];
//    [self.btn_allPlace addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btn_music addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btn_aroundMe addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)menuClick:(UIButton *)sender{
    _menuDropVC = [[LYLMenuDropViewController alloc]init];
    _menuDropVC.view.frame = CGRectMake(0, 104, 320, 124);
    [self removeMenuDropViewWith:sender.currentTitle];
    if (sender.tag <= 3) {
        //下拉gaiwei 456
        [_controller.view addSubview:_menuDropVC.view];
        
        if ([sender.currentTitle isEqualToString:@"所有地区"]) {
            for (UIButton *button in _menuDropVC.btn_menuArray) {
                [button setTitle:@"激情夜店" forState:UIControlStateNormal];
            }
            [self.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop down"]];
            sender.tag = 4;
        }else if([sender.currentTitle isEqualToString:@"音乐清吧"]){
            for (UIButton *button in _menuDropVC.btn_menuArray) {
                [button setTitle:@"音乐清吧" forState:UIControlStateNormal];
            }
            [self.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop down"]];
            sender.tag = 5;
        }else{
            for (UIButton *button in _menuDropVC.btn_menuArray) {
                [button setTitle:@"所有地区" forState:UIControlStateNormal];
            }
            [self.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop down"]];
            sender.tag = 6;
        }
    }else{
        //上回 gaiwei 123
        [_menuDropVC.view removeFromSuperview];
        if ([sender.currentTitle isEqualToString:@"所有地区"]) {
            [self.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
            sender.tag = 1;
        }else if([sender.currentTitle isEqualToString:@"音乐清吧"]){
            [self.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
            sender.tag = 2;
        }else{[self.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
            sender.tag = 3;
        }
    }
}

- (void)removeMenuDropViewWith:(NSString *)title{
    if ([title isEqualToString:@"所有地区"]) {
        [self.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
        [self.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
        self.btn_music.tag = 2;
        self.btn_aroundMe.tag = 3;
    }else if([title isEqualToString:@"音乐清吧"]){
        [self.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
        [self.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
        self.btn_allPlace.tag = 1;
        self.btn_aroundMe.tag = 3;
    }else{
        [self.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
        [self.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
        self.btn_allPlace.tag = 1;
        self.btn_music.tag = 2;
    }
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

@end
