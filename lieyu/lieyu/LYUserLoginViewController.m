//
//  LYUserLoginViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserLoginViewController.h"
#import "LYResetPasswordViewController.h"
#import "LYRegistrationViewController.h"
@interface LYUserLoginViewController ()

@end

@implementation LYUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
#pragma mark - 忘记密码
- (IBAction)forgetPassWordAct:(UIButton *)sender {
    LYResetPasswordViewController *resetPasswordViewController=[[LYResetPasswordViewController alloc]initWithNibName:@"LYResetPasswordViewController" bundle:nil];
    resetPasswordViewController.title=@"忘记密码";
    [self.navigationController pushViewController:resetPasswordViewController animated:YES];
}
#pragma mark - 登录
- (IBAction)loginAct:(UIButton *)sender {
}
#pragma mark - 注册
- (IBAction)zhuceAct:(UIButton *)sender {
    LYRegistrationViewController *registrationViewController=[[LYRegistrationViewController alloc]initWithNibName:@"LYRegistrationViewController" bundle:nil];
    registrationViewController.title=@"注册";
    [self.navigationController pushViewController:registrationViewController animated:YES];
}
- (IBAction)otherAct:(UIButton *)sender {
}
@end
