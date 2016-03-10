//
//  LPUserLoginViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPUserLoginViewController.h"
#import "LYUserLoginViewController.h"
#import "LYRegistrationViewController.h"

@interface LPUserLoginViewController ()

@end

@implementation LPUserLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rambleBtn.hidden = YES;
////    LPLoginInView *loginView = [[LPLoginInView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_CartoonView.frame), CGRectGetHeight(_CartoonView.frame))];
//    float height = SCREEN_HEIGHT - 268;
////    NSLog(@"%@",NSStringFromCGRect(loginView.frame));
////    NSLog(@"%@",NSStringFromCGRect(_CartoonView.frame));
//    CGAffineTransform affineTransform;
//    affineTransform = CGAffineTransformScale(_CartoonView.transform, height / 313, height / 313);
////    affineTransform = CGAffineTransformScale(loginView.transform, 0.8, 0.8);
////    _cartoonLeft.constant =( SCREEN_WIDTH - height / 313 * 194 ) / 2;
//    [_CartoonView setTransform:affineTransform];
//    _CartoonView.center=self.view.center;
////    [_CartoonView addSubview:loginView];
//    [_CartoonView addUntitled1Animation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginClick:(UIButton *)sender {
    LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]initWithNibName:@"LYUserLoginViewController" bundle:nil];
//    [self presentViewController:loginVC animated:YES completion:^{
//    }];
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)registerClick:(UIButton *)sender {
    LYRegistrationViewController *registerVC = [[LYRegistrationViewController alloc]initWithNibName:@"LYRegistrationViewController" bundle:nil];
//    [self presentViewController:registerVC animated:YES completion:^{
//    }];
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)rambleClick:(UIButton *)sender {
}
@end
