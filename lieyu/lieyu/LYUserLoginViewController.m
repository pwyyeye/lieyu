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
#import "UMessage.h"
#import "HomePageINeedPlayViewController.h"

@interface LYUserLoginViewController ()<LYRegistrationDelegate,LYResetPasswordDelegate>

@end

@implementation LYUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
    
//    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
//    [self.navigationItem setLeftBarButtonItem:item];
    
   // [self.btn_getBack addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController setNavigationBarHidden:YES];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    _btn_submit.frame=CGRectMake(10, SCREEN_HEIGHT-62, SCREEN_WIDTH-20, 52);
    _step=1;
    
}
-(void)wait{
    [self.navigationController setNavigationBarHidden:YES];
    if (_step==2) {
        [_timer invalidate];
    }
    _step++;
}
- (IBAction)goBackClick:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES];
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    if (self.navigationController.navigationBarHidden == NO) {
//        [self.navigationController setNavigationBarHidden:YES];
//    }
//
    self.navigationController.navigationBarHidden = YES;
    //self.userNameTex.layer.borderWidth = 0.5;
  //  self.userNameTex.layer.borderColor = RGBA(255,255,255, 0.2).CGColor;
   // self.userNameTex.layer.masksToBounds = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - 忘记密码
- (IBAction)forgetPassWordAct:(UIButton *)sender {
    LYResetPasswordViewController *resetPasswordViewController=[LYResetPasswordViewController shareReset];
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
    NSDictionary *dic=@{@"username":self.userNameTex.text,@"password":[MyUtil md5HexDigest:self.passWordTex.text] };
    NSLog(@"----pass-[MyUtil md5HexDigest:self.passWordTex.text]=%@---",[MyUtil md5HexDigest:self.passWordTex.text]);
//    NSDictionary *dic=@{@"username":self.userNameTex.text,@"password":self.passWordTex.text};
    [[LYUserHttpTool shareInstance] userLoginWithParams:dic block:^(UserModel *result) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=result.token;
        app.userModel=result;
        [app getImToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
        [USER_DEFAULT setObject:self.userNameTex.text forKey:@"username"];
        [USER_DEFAULT setObject:[MyUtil md5HexDigest:self.passWordTex.text] forKey:@"pass"];
//      [self dismissViewControllerAnimated:YES completion:^{
//          
//      }];
        
        //先删除别名，然后再注册新的－－－友盟 消息推送
        if ([USER_DEFAULT objectForKey:@"userid"]) {
            [UMessage removeAlias:[USER_DEFAULT objectForKey:@"userid"] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
                NSLog(@"----pass-addAlias%@---%@",responseObject,error);
            }];
        }
        [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",result.userid] forKey:@"userid"];
        
        [UMessage addAlias:[NSString stringWithFormat:@"%d",result.userid] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
            NSLog(@"----pass-addAlias%@---%@",responseObject,error);
        }];
        
        
        [self.navigationController popViewControllerAnimated:YES ];
//        NSLog(result.username);
    }];
}

-(void)showMessage:(NSString*) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
    
}
#pragma mark - 自动登录
- (void)autoLogin{
    NSString *username=[USER_DEFAULT objectForKey:@"username"];
    NSString *password=[USER_DEFAULT objectForKey:@"pass"];
    if([MyUtil isEmptyString:username]){
        return;
    }
    if([MyUtil isEmptyString:password]){
        return;
    }
    NSDictionary *dic=@{@"username":username,@"password":password};
    [[LYUserHttpTool shareInstance] userAutoLoginWithParams:dic block:^(UserModel *result) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=result.token;
        app.userModel=result;
        [app getImToken];
//        [self.navigationController popToRootViewControllerAnimated:YES ];
    }];
}
#pragma mark - 注册
- (IBAction)zhuceAct:(UIButton *)sender {
//    LYRegistrationViewController *registrationViewController=[[LYRegistrationViewController alloc]initWithNibName:@"LYRegistrationViewController" bundle:nil];
    LYRegistrationViewController *registrationViewController = [LYRegistrationViewController shareRegist];
    registrationViewController.title=@"注册";
    registrationViewController.delegate=self;
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



-(void)gotoBack{
    if ([self.delegate respondsToSelector:@selector(loginSuccess:)]) {
        [self.delegate loginSuccess:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
 
@end
