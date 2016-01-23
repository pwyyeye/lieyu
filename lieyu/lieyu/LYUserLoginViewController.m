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
#import "ChiHeViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "LYHomePageHttpTool.h"
#import "UMSocial.h"
#import "LYRegistrationViewController.h"
#import "IQKeyboardManager.h"
#define COLLECTKEY [NSString stringWithFormat:@"%@%@sc",_userid,self.beerBarDetail.barid]
#define LIKEKEY [NSString stringWithFormat:@"%@%@",_userid,self.beerBarDetail.barid]

@interface LYUserLoginViewController ()<LYRegistrationDelegate,LYResetPasswordDelegate>{
    UIButton *_qqBtn;
    UIButton *_weixinBtn;
    UIButton *_weiboBtn;
    TencentOAuth *_tencentOAuth;
}

@end

@implementation LYUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    //    [self.navigationItem setLeftBarButtonItem:item];
    
    // [self.btn_getBack addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController setNavigationBarHidden:YES];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    _btn_submit.frame=CGRectMake(10, SCREEN_HEIGHT-62, SCREEN_WIDTH-20, 52);
    _step=1;
    

    _qqBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 400, 100, 30)];
    [_qqBtn setTitle:@"qq登录" forState:UIControlStateNormal];
    _qqBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_qqBtn];
    [_qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 400, 100, 30)];
    [_weixinBtn setTitle:@"weixin登录" forState:UIControlStateNormal];
    _weixinBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_weixinBtn];
    [_weixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _weiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(240, 400, 100, 30)];
    [_weiboBtn setTitle:@"weibo登录" forState:UIControlStateNormal];
    _weiboBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_weiboBtn];
    [_weiboBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    
    if(![WXApi isWXAppInstalled]) _weixinBtn.hidden = YES;
    if(![TencentOAuth iphoneQQInstalled]) _qqBtn.hidden = YES;
    
}
-(void)wait{
    [self.navigationController setNavigationBarHidden:YES];
    if (_step==2) {
        [_timer invalidate];
    }
    _step++;
}
- (IBAction)goBackClick:(id)sender {
    //    NSLog(@"-------pop:%@",self.popoverPresentationController);
    //    NSLog(@"-------pop:%@",self.parentViewController);
    //    NSLog(@"-------pop:%@",self.childViewControllers);
    //    NSLog(@"-------pop:%@",self.navigationController.childViewControllers);
    //    NSLog(@"-------pop:%d",self.navigationController.childViewControllers.count);
    //    NSLog(@"-------pop:%@",self.navigationController.childViewControllers);
    //
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChiHeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    //    if([self.navigationController.childViewControllers objectAtIndex:1])
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
        
        [self getUserCollectJiuBaList];
        [self getUserZangJiuBaList];
        
        [self.navigationController popViewControllerAnimated:YES ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAndLoadData" object:nil];
    }];
    
    
    
    
}

//从服务器获取用户是否收藏过酒吧
- (void)getUserCollectJiuBaList{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NEEDGETLIKE"]) {
        [LYUserHttpTool getUserCollectionJiuBarListWithCompelet:^(NSArray *array) {
            //  NSLog(@"------->%d",array.count);
            for (JiuBaModel *jiuBa in array) {
                NSString *jiuBaId = [NSString stringWithFormat:@"%d",jiuBa.barid];
                [[NSUserDefaults standardUserDefaults] setObject:jiuBaId forKey:[NSString stringWithFormat:@"%@%@sc",[NSString stringWithFormat:@"%d",app.userModel.userid],jiuBaId]];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

//从服务器获取用户是否赞过酒吧
- (void)getUserZangJiuBaList{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NEEDGETCOLLECT"]) {
        [LYUserHttpTool getUserZangJiuBarListWithCompelet:^(NSArray *array) {
            //    NSLog(@"------->%d",array.count);
            for (JiuBaModel *jiuBa in array) {
                NSString *jiuBaId = [NSString stringWithFormat:@"%d",jiuBa.barid];
                [[NSUserDefaults standardUserDefaults] setObject:jiuBaId forKey:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%d",app.userModel.userid],jiuBaId]];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
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

#pragma mark - qq登录
- (void)qqLogin{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104853065"  andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
    NSArray *_permissions =  [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, @"get_simple_userinfo", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
    
}

- (void)tencentDidLogin{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"---->%@", _tencentOAuth.accessToken);
        [_tencentOAuth getUserInfo];
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)getUserInfoResponse:(APIResponse *)response{
    NSLog(@"----->%@",response);
    __block LYUserLoginViewController *weakSelf = self;
    NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES: _tencentOAuth.openId]};
    
    UserModel *userModel = [[UserModel alloc]init];
    userModel.usernick = response.jsonResponse[@"nickname"];
    userModel.gender = [response.jsonResponse[@"gender"] isEqualToString:@"男"] ? @"1" : @"0";
    userModel.avatar_img=response.jsonResponse[@"figureurl_qq_2"];
    
     userModel.openID =  _tencentOAuth.openId;
    
    [LYUserHttpTool userLoginFromQQWeixinAndSinaWithParams:paraDic compelte:^(NSInteger sucess,UserModel *userM) {
        if (sucess) {//登录成功
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.s_app_id=userM.token;
            app.userModel=userM;
            [app getImToken];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{//去绑定手机好
            LYRegistrationViewController *registVC = [[LYRegistrationViewController alloc]init];
           
            registVC.userM = userModel;
            
            registVC.isTheThirdLogin = YES;
            registVC.thirdLoginType = @"1";
            [weakSelf.navigationController pushViewController:registVC animated:YES];
        }}];
}

#pragma mark - 微信登录
- (void)weixinLogin{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if ([WXApi sendReq:req]) NSLog(@"-->success");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiXinAccessToken) name:@"weixinCode" object:nil];
}

- (void)getWeiXinAccessToken{
    NSString *accessTokenStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"weixinGetAccessToken"];
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeWeixin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weixinDate"] timeIntervalSince1970];
    NSLog(@"------------------>%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinCode"]);
    NSLog(@"--->%f",timeNow - timeWeixin);
    __block LYUserLoginViewController *weakSelf = self;
    NSTimeInterval timeWeixin_re = [[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinReDate"] timeIntervalSince1970];
    
    if([MyUtil isEmptyString:accessTokenStr] || timeNow - timeWeixin_re > 60 * 60 * 24 * 30){//refreshToken超过30tian
        [LYHomePageHttpTool getWeixinAccessTokenWithCode:[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinCode"] compelete:^(NSString *accessToken) {
            if(![MyUtil isEmptyString:accessToken]){
                [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessToken compelete:^(UserModel *userInfo) {
                    if(userInfo){
                        [weakSelf weiXinLoginWith:userInfo];
                    }
                }];
            }
        }];
    }else{
        if(timeNow - timeWeixin > 2 * 60 * 60){
            [LYHomePageHttpTool getWeixinNewAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]          objectForKey:@"weixinRefresh_token"] compelete:^(NSString *accessToken) {
                if(![MyUtil isEmptyString:accessToken]){
                    [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessToken compelete:^(UserModel *userInfo) {
                        [weakSelf weiXinLoginWith:userInfo];
                    }];
                }
            }];
        }else{
            
            [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessTokenStr compelete:^(UserModel *userInfo) {
                [weakSelf weiXinLoginWith:userInfo];
            }];
            
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixinCode" object:nil];
}

- (void)weiXinLoginWith:(UserModel *)userModel{
    __block LYUserLoginViewController *weakSelf = self;
    NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:userModel.openID]};
    [LYUserHttpTool userLoginFromQQWeixinAndSinaWithParams:paraDic compelte:^(NSInteger sucess,UserModel *userM) {
        if (sucess) {//登录成功
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.s_app_id=userM.token;
            app.userModel=userM;
            [app getImToken];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{//去绑定手机好
            LYRegistrationViewController *registVC = [[LYRegistrationViewController alloc]init];
            registVC.userM = userModel;
            registVC.isTheThirdLogin = YES;
            registVC.thirdLoginType = @"2";
            [weakSelf.navigationController pushViewController:registVC animated:YES];
        }
    }];
}

#pragma mark - 新浪微博登录
- (void)weiboLogin{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            NSLog(@"--->%@",snsAccount);
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            if(![MyUtil isEmptyString:snsAccount.usid]){
                UserModel *userModel = [[UserModel alloc]init];
                userModel.usernick = snsAccount.userName;
                userModel.avatar_img = snsAccount.iconURL;
                userModel.openID = snsAccount.usid;
                
                NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:snsAccount.usid]};
                NSLog(@"---->%@",paraDic);
                __block LYUserLoginViewController *weakSelf = self;
                [LYUserHttpTool userLoginFromQQWeixinAndSinaWithParams:paraDic compelte:^(NSInteger sucess,UserModel *userM) {
                    if (sucess) {//登录成功
                        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        app.s_app_id=userM.token;
                        app.userModel=userM;
                        [app getImToken];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }else{//去绑定手机好
                        [MyUtil showPlaceMessage:@"绑定手机号"];
                        LYRegistrationViewController *registVC = [[LYRegistrationViewController alloc]init];
                        userModel.openID = snsAccount.usid;
                        registVC.userM = userModel;
                        registVC.isTheThirdLogin = YES;
                        registVC.thirdLoginType = @"3";
                        [weakSelf.navigationController pushViewController:registVC animated:YES];
                        
                    }
                }];
                
                
            }
        }});
    
    //    LYRegistrationViewController 
}

@end
