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
#import "ZSMaintViewController.h"
#define COLLECTKEY [NSString stringWithFormat:@"%@%@sc",_userid,self.beerBarDetail.barid]
#define LIKEKEY [NSString stringWithFormat:@"%@%@",_userid,self.beerBarDetail.barid]

@interface LYUserLoginViewController ()<LYRegistrationDelegate,LYResetPasswordDelegate>{
    UIButton *_qqBtn;
    __weak IBOutlet NSLayoutConstraint *btn_login_cons_top;
    UIButton *_weixinBtn;
    UIButton *_weiboBtn;
    TencentOAuth *_tencentOAuth;
    UIVisualEffectView *_effctView;
    __block UserModel *userModel;
}

@end

@implementation LYUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title = @"登录";
    // Do any additional setup after loading the view from its nib.
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //设置返回按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    _btn_submit.frame=CGRectMake(10, SCREEN_HEIGHT-62, SCREEN_WIDTH-20, 52);
    _step=1;
    
    if([[MyUtil deviceString]isEqualToString:@"iPhone 4"] || [[MyUtil deviceString]isEqualToString:@"iPhone 4S"]){
        btn_login_cons_top.constant = 53;
        [self updateViewConstraints];
    }

    //设置微信，QQ，微博登陆按钮
    CGFloat _qqBtnWidth = 44;
    _qqBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - _qqBtnWidth/2.f, SCREEN_HEIGHT - 30 - _qqBtnWidth, _qqBtnWidth, _qqBtnWidth)];

    [_qqBtn setImage:[UIImage imageNamed:@"qq_s2"] forState:UIControlStateNormal];

    [self.view addSubview:_qqBtn];
    [_qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4.f - _qqBtnWidth/2.f, SCREEN_HEIGHT - 30 - _qqBtnWidth, _qqBtnWidth, _qqBtnWidth)];

    [_weixinBtn setImage:[UIImage imageNamed:@"wechat_s2"] forState:UIControlStateNormal];

    [self.view addSubview:_weixinBtn];
    [_weixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _weiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4.f * 3 - _qqBtnWidth/2.f, SCREEN_HEIGHT - 30 - _qqBtnWidth, _qqBtnWidth, _qqBtnWidth)];
    [_weiboBtn setImage:[UIImage imageNamed:@"sina_weibo_s2"] forState:UIControlStateNormal];

    [self.view addSubview:_weiboBtn];
    [_weiboBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    
    if(![WXApi isWXAppInstalled]) _weixinBtn.hidden = YES;
    if(![TencentOAuth iphoneQQInstalled]) _qqBtn.hidden = YES;
    
    _btn_submit.layer.masksToBounds=YES;
    _btn_submit.layer.cornerRadius=3;
    
    //初始化
     userModel = [[UserModel alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
    
}


- (IBAction)goBackClick:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChiHeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
//    if([self.navigationController.childViewControllers objectAtIndex:1])
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
//    NSLog(@"----pass-[MyUtil md5HexDigest:self.passWordTex.text]=%@---",[MyUtil md5HexDigest:self.passWordTex.text]);
    __weak __typeof(self) weakSelf = self;
    [[LYUserHttpTool shareInstance] userLoginWithParams:dic block:^(UserModel *result) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=result.token;
        app.userModel=result;
        [app getImToken];
        [app getTTL];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
        [USER_DEFAULT setObject:self.userNameTex.text forKey:@"username"];
        [USER_DEFAULT setObject:[MyUtil md5HexDigest:weakSelf.passWordTex.text] forKey:@"pass"];
        [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",result.userid] forKey:@"userid"];
        if ([app.userModel.usertype isEqualToString:@"1"]) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LYMain" bundle:[NSBundle mainBundle]];

            UINavigationController *nav = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"LYNavigationController"];
            app.navigationController = nav;
            app.window.rootViewController = nav;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shanghuban"];
            
            
        }

        //先删除别名，然后再注册新的－－－友盟 消息推送
        [weakSelf addUmengAlias:[NSString stringWithFormat:@"%d",result.userid]];
        
        [weakSelf getUserCollectJiuBaList];
        [weakSelf getUserZangJiuBaList];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAndLoadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMyCollectedAndLikeBar" object:nil];
    }];
    
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [UIView animateWithDuration:0.2 animations:^{
        _effctView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_effctView removeFromSuperview];
    }];
}

//从服务器获取用户是否收藏过酒吧
- (void)getUserCollectJiuBaList{
    __weak AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NEEDGETLIKE"]) {
        [LYUserHttpTool getUserCollectionJiuBarListWithCompelet:^(NSArray *array) {
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
    __weak AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"OPENIDSTR"];
    if(![MyUtil isEmptyString:openID] ){
        __block LYUserLoginViewController *weakSelf = self;
        NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:openID]};
        [LYUserHttpTool userLoginFromQQWeixinAndSinaWithParams:paraDic compelte:^(NSInteger sucess,UserModel *userM) {
            if (sucess) {//登录成功
                AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                app.s_app_id=userM.token;
                app.userModel=userM;
                [app getImToken];
                [app getTTL];
//                if ([MyUtil isEmptyString:app.desKey] ) {
                    [app getDESKey];
//                }
                NSString * hasAddAlias=[USER_DEFAULT objectForKey:@"hasAddAlias"];
                if ([MyUtil isEmptyString:hasAddAlias]) {
                    [UMessage addAlias:[NSString stringWithFormat:@"%d",userM.userid] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
                        NSLog(@"----pass-addAlias%@---%@",responseObject,error);
                    }];
                    [USER_DEFAULT setObject:@"1" forKey:@"hasAddAlias"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];

    }
    
    
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
        [app getTTL];
//        if ([MyUtil isEmptyString:app.desKey] ) {
            [app getDESKey];
//        }
        NSString * hasAddAlias=[USER_DEFAULT objectForKey:@"hasAddAlias"];
        if ([MyUtil isEmptyString:hasAddAlias]) {
            [UMessage addAlias:[NSString stringWithFormat:@"%d",result.userid] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
                NSLog(@"----pass-addAlias%@---%@",responseObject,error);
            }];
            [USER_DEFAULT setObject:@"1" forKey:@"hasAddAlias"];
        }
        
//        [self addUmengAlias:[NSString stringWithFormat:@"%d",result.userid]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OPENIDSTR"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];

    }];
}



#pragma mark - 注册
- (IBAction)zhuceAct:(UIButton *)sender {
    LYRegistrationViewController *registrationViewController = [LYRegistrationViewController shareRegist];
    registrationViewController.title=@"注册";
    registrationViewController.delegate=self;
    [self.navigationController pushViewController:registrationViewController animated:YES];
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
    NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES: _tencentOAuth.openId]};

    userModel.usernick = response.jsonResponse[@"nickname"];
    userModel.gender = [response.jsonResponse[@"gender"] isEqualToString:@"男"] ? @"1" : @"0";
    userModel.avatar_img=response.jsonResponse[@"figureurl_qq_2"];
    userModel.openID =  _tencentOAuth.openId;
    [self login:paraDic WithType:@"1"];
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

- (void)weiXinLoginWith:(UserModel *)userModel2{
    userModel=userModel2;
    NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:userModel.openID]};
    [self login:paraDic WithType:@"2"];
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
                userModel.usernick = snsAccount.userName;
                userModel.avatar_img = snsAccount.iconURL;
                userModel.openID = snsAccount.usid;
                NSDictionary *paraDic = @{@"currentSessionId":[MyUtil encryptUseDES:snsAccount.usid]};
               
                [self login:paraDic WithType:@"3"];
                
            }
        }});
}


-(void)login:(NSDictionary*)param WithType:(NSString *)type{
    __block LYUserLoginViewController *weakSelf = self;
    [LYUserHttpTool userLoginFromQQWeixinAndSinaWithParams:param compelte:^(NSInteger sucess,UserModel *userM) {
        if (sucess) {//登录成功
            [[NSUserDefaults standardUserDefaults] setObject:userModel.openID forKey:@"OPENIDSTR"];
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.s_app_id=userM.token;
            app.userModel=userM;
            [app getImToken];
            
            [app getTTL];
            
//            if ([MyUtil isEmptyString:app.desKey] ) {
                [app getDESKey];
//            }
            [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",userM.userid] forKey:@"userid"];

            
           
            [self addUmengAlias:[NSString stringWithFormat:@"%d",userM.userid]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAndLoadData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMyCollectedAndLikeBar" object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{//去绑定手机好
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OPENIDSTR"];
            LYRegistrationViewController *registVC = [[LYRegistrationViewController alloc]init];
            registVC.userM = userModel;
            registVC.isTheThirdLogin = YES;
            registVC.thirdLoginType = type;
            [weakSelf.navigationController pushViewController:registVC animated:YES];
            
        }
    }];

}

//先删除别名，然后再注册新的－－－友盟 消息推送
-(void)addUmengAlias:(NSString *) userid{
    
    [USER_DEFAULT removeObjectForKey:@"hasAddAlias"];
    
    if ([MyUtil isEmptyString:userid]) return;
//
//    [UMessage removeAlias:userid type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
//        NSLog(@"----pass-addAlias%@---%@",responseObject,error);
//    }];
//    
//    [UMessage addAlias:userid type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
//        NSLog(@"----pass-addAlias%@---%@",responseObject,error);
//    }];
//    
    
    [UMessage setAlias:userid type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
        NSLog(@"----pass-setAlias%@---%@",responseObject,error);
    }];
}
-(void)dealloc{
    NSLog(@"----pass-pass%@---",@"test dealloc");
}

@end
