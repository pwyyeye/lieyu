//
//  LYResetPasswordViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYResetPasswordViewController.h"
#import "LYUserHttpTool.h"
@interface LYResetPasswordViewController ()

@end

@implementation LYResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _step=60;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(captchaWait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    CGSize imageSize = CGSizeMake(self.getYzmBtn.width, self.getYzmBtn.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(35, 166, 116) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.getYzmBtn setBackgroundImage:normalImg  forState:UIControlStateNormal];
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(199, 199, 199) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.getYzmBtn setBackgroundImage:selectedImg  forState:UIControlStateDisabled];
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

- (IBAction)nextAct:(UIButton *)sender {
    if(![MyUtil isValidateTelephone:self.getPassWordTypeTex.text]){
        
        [self showMessage:@"请输入正确的手机格式!"];
        return;
    }
    if(self.yzmText.text.length<1){
        [self showMessage:@"请输入验证码!"];
        return;
    }
    if(self.passWordTex.text.length<1){
        [self showMessage:@"请输入密码!"];
        return;
    }
    if(self.againPassWordTex.text.length<1){
        [self showMessage:@"请输入重置密码!"];
        return;
    }
    if(![self.againPassWordTex.text isEqualToString:self.passWordTex.text]){
        [self showMessage:@"两次输入密码不一致!"];
        return;
    }
    NSDictionary *dic=@{@"mobile":self.getPassWordTypeTex.text,@"captchas":self.yzmText.text,@"newpassword":[MyUtil md5HexDigest: self.passWordTex.text],@"password":[MyUtil md5HexDigest: self.againPassWordTex.text]};
    [[LYUserHttpTool shareInstance] setNewPassWord:dic complete:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"修改成功！"];
            [_timer setFireDate:[NSDate distantPast]];
            [self.delegate resetPassword];
            [self.navigationController popViewControllerAnimated:YES];
//            LYSurePassWordViewController *surePassWordViewController=[[LYSurePassWordViewController alloc]initWithNibName:@"LYSurePassWordViewController" bundle:nil];
//            surePassWordViewController.title=@"确定密码";
//            [self.navigationController pushViewController:surePassWordViewController animated:YES];
        }
    }];
    
}
#pragma mark - 获取验证码
- (IBAction)getYZMAct:(UIButton *)sender {
    if(![MyUtil isValidateTelephone:self.getPassWordTypeTex.text]){
        
        [self showMessage:@"请输入正确的手机格式!"];
    }
    NSDictionary *dic=@{@"mobile":self.getPassWordTypeTex.text};
    [[LYUserHttpTool shareInstance] getResetYanZhengMa:dic complete:^(BOOL result) {
        if (result) {
            [_timer setFireDate:[NSDate distantPast]];
            [self showMessage:@"验证码发送成功!"];
        }
    }];
}
#pragma mark -定时器更新验证码按钮

-(void)captchaWait{
    
    if (_step==0) {
        self.getYzmBtn.enabled=YES;
        _step=60;
        
        [_timer setFireDate:[NSDate distantFuture]];//暂停
        [self.getYzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        
    }else{
        self.getYzmBtn.enabled=NO;
        _step--;
        self.getYzmBtn.titleLabel.text=[NSString stringWithFormat:@"重新发送(%d)秒",_step];
        [self.getYzmBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)秒",_step] forState:UIControlStateDisabled];
        [self.getYzmBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)秒",_step] forState:UIControlStateNormal];
        
    }
    
    
}

-(void)dealloc{
    [_timer invalidate];
}
- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
