//
//  LYNavigationController.m
//  lieyu
//
//  Created by pwy on 15/12/15.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNavigationController.h"

@interface LYNavigationController ()

@end

@implementation LYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = YES;
    
    //修改的部分
    UIColor *_inputColor0 = RGBA(109, 0, 142,0.9);
    UIColor *_inputColor1 = RGBA(64, 1, 120,0.9);
    CGPoint _inputPoint0 = CGPointMake(0.5, 0);
    CGPoint _inputPoint1 = CGPointMake(0.5, 1);
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = _inputPoint0;
    layer.endPoint = _inputPoint1;
    layer.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    layer.zPosition=-1;
    [self.navigationBar.layer addSublayer:layer];
    

    UIImage *bgImage=[UIImage imageNamed:@"navBarbg"];
    
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    //返回的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;


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

@end
