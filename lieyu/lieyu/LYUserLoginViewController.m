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
#import "LYUserHttpTool.h"
@interface LYUserLoginViewController ()<LYRegistrationDelegate,LYResetPasswordDelegate>

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
    if(self.userNameTex.text.length<1){
        [self showMessage:@"请输入用户名!"];
        return;
    }
    if(self.passWordTex.text.length<1){
        [self showMessage:@"请输入密码!"];
        return;
    }
    NSDictionary *dic=@{@"username":self.userNameTex.text,@"password":self.passWordTex.text};
    [[LYUserHttpTool shareInstance] userLoginWithParams:dic block:^(UserModel *result) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=result.token;
        app.userModel=result;
        [app getImToken];
//        NSLog(result.username);
    }];
}
#pragma mark - 自动登录
- (void)aotuLogin:(NSString *)username and:(NSString *) password {
    if(username.length<1){
        return;
    }
    if(password.length<1){
        return;
    }
    NSDictionary *dic=@{@"username":username,@"password":password};
    [[LYUserHttpTool shareInstance] userLoginWithParams:dic block:^(UserModel *result) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=result.token;
        app.userModel=result;
        [app getImToken];
        //        NSLog(result.username);
    }];
}
#pragma mark - 注册
- (IBAction)zhuceAct:(UIButton *)sender {
    LYRegistrationViewController *registrationViewController=[[LYRegistrationViewController alloc]initWithNibName:@"LYRegistrationViewController" bundle:nil];
    registrationViewController.title=@"注册";
    [self.navigationController pushViewController:registrationViewController animated:YES];
}

- (IBAction)otherAct:(UIButton *)sender {
}

- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
#pragma mark - 注册代理
- (void)registration{
    [MyUtil showMessage:@"注册成功"];
}
#pragma mark - 重置密码代理
- (void)resetPassword{
    [MyUtil showMessage:@"重置密码成功"];
}
@end
