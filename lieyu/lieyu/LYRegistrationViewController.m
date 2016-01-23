//
//  LYRegistrationViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYRegistrationViewController.h"
#import "LYUserHttpTool.h"
#import "LYUserDetailInfoViewController.h"
#import "LYUserLoginViewController.h"
#import "HomePageINeedPlayViewController.h"
#import "IQKeyboardManager.h"
@interface LYRegistrationViewController (){
    BOOL _isRegisted;
    NSString *_flag;
}

@end

@implementation LYRegistrationViewController
static LYRegistrationViewController *_registe;

+ (instancetype)shareRegist{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _registe = [[LYRegistrationViewController alloc]init];
        });
    return _registe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _step=60;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(captchaWait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForword)];
    self.navigationItem.leftBarButtonItem = left;
    /*
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
    */
    // Do any additional setup after loading the view from its nib.
    
    if(_isTheThirdLogin){
        self.title = @"绑定手机号";
        _textField_psw.hidden = YES;
        _textField_psw_third.hidden = YES;
        _imgView_icon_four.hidden = YES;
        _passWordTex.hidden = YES;
        _againPassWordTex.hidden = YES;
        _textField_psw_little.hidden = YES;
        [_btn_regist setTitle:@"立即绑定" forState:UIControlStateNormal];
    }
}

- (void)backForword{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = NO;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"--------------------->释放");
    [_timer invalidate];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 验证码
- (IBAction)getYzmAct:(UIButton *)sender {
    
    if(![MyUtil isValidateTelephone:self.phoneTex.text]){
        
        [MyUtil showMessage:@"请输入正确的手机格式!"];
        return;
    }
    
    NSDictionary *dic=@{@"mobile":self.phoneTex.text};
    __block LYRegistrationViewController *weakSelf = self;
    if(_isTheThirdLogin){
        [LYUserHttpTool getYZMForThirdthLoginWithPara:dic compelte:^(NSString *flag) {//1 注册过 0 未注册过
            _flag = flag;
            [_timer setFireDate:[NSDate distantPast]];
            if([flag isEqualToString:@"0"]){
                //未注册显示注册等控件
                weakSelf.title = @"注册";
                _textField_psw.hidden = NO;
                _passWordTex.hidden = NO;
                _textField_psw_third.hidden = NO;
                _imgView_icon_four.hidden = NO;
                _againPassWordTex.hidden = NO;
                _textField_psw_little.hidden = NO;
                [_btn_regist setTitle:@"立即注册" forState:UIControlStateNormal];
                _isRegisted = YES;
            }else{//已注册去绑定
                _isRegisted = NO;
            }
            
            
        }];
    }else{
    [[LYUserHttpTool shareInstance] getYanZhengMa:dic complete:^(BOOL result) {
        if (result) {
            [_timer setFireDate:[NSDate distantPast]];
          [MyUtil showMessage:@"验证码发送成功请输入短信中的验证码!"];
        }
    }];
    }
}
#pragma mark - 密码
- (IBAction)zcAct:(UIButton *)sender {
    if(![MyUtil isValidateTelephone:self.phoneTex.text]){
        
        [MyUtil showMessage:@"请输入正确的手机格式!"];
        return;
    }
    if(self.yzmTex.text.length<1){
        [MyUtil showMessage:@"请输入验证码!"];
        return;
    }
    if(!_isRegisted){//绑定手机号
        if([_flag isEqualToString:@"1"]){//注册过去绑定
            NSString *plantType = nil;
            if([_thirdLoginType isEqualToString:@"1"]) plantType = @"qq";
            else if([_thirdLoginType isEqualToString:@"2"]) plantType = @"wechat";
            else plantType = @"weibo";
            if(plantType == nil) return;
            NSDictionary *paraDic = @{@"mobile":self.phoneTex.text,@"captchas":self.yzmTex.text,plantType:[MyUtil encryptUseDES:_userM.openID]};
            __block LYRegistrationViewController *weakSelf = self;
            [LYUserHttpTool tieQQWeixinAndSinaWithPara:paraDic compelte:^(NSInteger flag) {//1 绑定成功 0 绑定失败
                if (flag) {//绑定
                    [MyUtil showPlaceMessage:@"绑定成功"];
                    
                    NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:_userM.openID]};
                    [LYUserHttpTool userLoginFromOpenIdWithPara:paraDic compelte:^(UserModel *userModel) {
                        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        app.s_app_id=userModel.token;
                        app.userModel=userModel;
                        [app getImToken];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }else{
                    [MyUtil showPlaceMessage:@"绑定失败"];
                }
            }];
        }
        
    }else{
        if(self.passWordTex.text.length<1){
            [MyUtil showMessage:@"请输入密码!"];
            return;
        }
        if(self.againPassWordTex.text.length<1){
            [MyUtil showMessage:@"请输入重置密码!"];
            return;
        }
        if(![self.againPassWordTex.text isEqualToString:self.passWordTex.text]){
            [MyUtil showMessage:@"两次输入密码不一致!"];
            return;
        }
        NSDictionary *dic=@{@"mobile":self.phoneTex.text,@"captchas":self.yzmTex.text,@"password":[MyUtil md5HexDigest: self.passWordTex.text],@"confirm":[MyUtil md5HexDigest: self.againPassWordTex.text],@"type":_thirdLoginType,@"openId":[MyUtil encryptUseDES:_userM.openID]};
        [[LYUserHttpTool shareInstance] setZhuCe:dic complete:^(BOOL result) {
            if (result) {
                [_timer setFireDate:[NSDate distantPast]];
                
                [self.delegate registration];
                [USER_DEFAULT setObject:self.phoneTex.text forKey:@"username"];
                [USER_DEFAULT setObject:[MyUtil md5HexDigest:self.passWordTex.text] forKey:@"pass"];
                
                LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
                [loginVC autoLogin];
                
                LYUserDetailInfoViewController *detailVC = [[LYUserDetailInfoViewController alloc]init];
                detailVC.userM = _userM;
                detailVC.thirdLoginType = _thirdLoginType;
                detailVC.isAutoLogin = YES;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }];

    }
}

- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}

@end
