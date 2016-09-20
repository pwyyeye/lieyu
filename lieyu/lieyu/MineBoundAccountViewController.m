//
//  MineBoundAccountViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineBoundAccountViewController.h"
#import "wechatCheckAccountViewController.h"
#import "LYHomePageHttpTool.h"
#import "LYUserHttpTool.h"
#import "WXApi.h"

@interface MineBoundAccountViewController ()

@property (nonatomic, assign) NSInteger choosedIndex;

@end

@implementation MineBoundAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"绑定账户";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _finishButton.layer.cornerRadius = 19;
    _finishButton.layer.masksToBounds = YES;
    [_finishButton addTarget:self action:@selector(sendAccountInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _choosedIndex = 1;
    
    UIButton *button = [[UIButton alloc]init];
    button.tag = 1;
    [self withdrawButtonClick:button];
}

- (void)setButtonSelected:(int)index{
    for (UIButton *button in _withdrawButtons) {
        if (button.tag == index) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)withdrawButtonClick:(UIButton *)sender {
    [_firstTextField setText:@""];
    [_secondTextField setText:@""];
    [_thirdTextField setText:@""];
    [self setButtonSelected:(int)sender.tag];
    _choosedIndex = sender.tag;
    if (sender.tag == 1) {
        [_firstLabel setText:@"微信号"];
        [_firstTextField setPlaceholder:@"请输入您的微信号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeDefault];
        [_secondLabel setText:@"姓名"];
        [_secondTextField setPlaceholder:@"请输入您的姓名"];
        _thirdLabel.hidden = YES;
        _thirdTextField.hidden = YES;
        _seperateLabel.hidden = YES;
        _viewHeight.constant = 101;
        _wechatLabel.hidden = NO;
    }else if (sender.tag == 2){
        [_firstLabel setText:@"支付宝账号"];
        [_firstTextField setPlaceholder:@"请输入您的支付宝账号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeDefault];
        [_secondLabel setText:@"姓名"];
        [_secondTextField setPlaceholder:@"请输入支付宝绑定的姓名"];
        _thirdLabel.hidden = YES;
        _thirdTextField.hidden = YES;
        _seperateLabel.hidden = YES;
        _viewHeight.constant = 101;
        _wechatLabel.hidden = YES;
    }else{
        [_firstLabel setText:@"银行卡号"];
        [_firstTextField setPlaceholder:@"请输入您的银行卡号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_secondLabel setText:@"开户支行"];
        [_secondTextField setPlaceholder:@"请输入您的开户支行"];
        [_thirdLabel setText:@"开户姓名"];
        [_thirdTextField setPlaceholder:@"请输入您的开户姓名"];
        _thirdLabel.hidden = NO;
        _thirdTextField.hidden = NO;
        _seperateLabel.hidden = NO;
        _viewHeight.constant = 151;
        _wechatLabel.hidden = YES;
    }
}

- (void)sendAccountInfo{
    if ([MyUtil isEmptyString:_firstTextField.text] || [MyUtil isEmptyString:_secondTextField.text] || ([MyUtil isEmptyString:_thirdTextField.text] && _choosedIndex == 3)) {
        [MyUtil showPlaceMessage:@"请将信息填写完整"];
        return;
    }
    if(_choosedIndex == 1){
        //绑定微信
        [self weixinLogin];
    }else{
        [self lyUserBoundAccount];
    }
}

- (void)lyUserBoundAccount{
    NSDictionary *dict ;
    //accountType : 1、支付宝 2、银行卡 3、微信
    if (_choosedIndex == 1) {
        dict = @{@"accountType":@"3",
                 @"accountNo":_secondTextField.text,
                 @"accountName":_firstTextField.text};
    }else if (_choosedIndex == 2){
        dict = @{@"accountType":@"1",
                 @"accountNo":_firstTextField.text,
                 @"accountName":_secondTextField.text};
    }else if (_choosedIndex == 3){
        dict = @{@"accountType":@"2",
                 @"accountNo":_firstTextField.text,
                 @"accountName":_thirdTextField.text};
    }
    __weak __typeof(self)weakSelf = self;
    [LYUserHttpTool lyUserBoundAccountWithParams:dict complete:^(BOOL result) {
        if (result) {
            //代理方法，绑定成功
            [weakSelf goBack];
        }
    }];
}

- (void)lyUserBoundWechat:(UserModel *)model{
    NSDictionary *dict = @{@"accountType":@"3",
                           @"accountNo":model.openID,
                           @"accountName":model.usernick};
    __weak __typeof(self)weakSelf = self;
    [LYUserHttpTool lyUserBoundAccountWithParams:dict complete:^(BOOL result) {
        if (result) {
            //代理方法，绑定成功
            [weakSelf goBack];
        }
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)weixinLogin{
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
    __weak __typeof(self)weakSelf = self;
    NSTimeInterval timeWeixin_re = [[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinReDate"] timeIntervalSince1970];
    
    if([MyUtil isEmptyString:accessTokenStr] || timeNow - timeWeixin_re > 60 * 60 * 24 * 30){//refreshToken超过30tian
        [LYHomePageHttpTool getWeixinAccessTokenWithCode:[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinCode"] compelete:^(NSString *accessToken) {
            if(![MyUtil isEmptyString:accessToken]){
                [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessToken compelete:^(UserModel *userInfo) {
                    if(userInfo){
                        [weakSelf bangding:userInfo.openID and:2];
                        [weakSelf lyUserBoundWechat:userInfo];
                    }
                }];
            }
        }];
    }else{
        if(timeNow - timeWeixin > 2 * 60 * 60){
            [LYHomePageHttpTool getWeixinNewAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]          objectForKey:@"weixinRefresh_token"] compelete:^(NSString *accessToken) {
                if(![MyUtil isEmptyString:accessToken]){
                    [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessToken compelete:^(UserModel *userInfo) {
                        [weakSelf bangding:userInfo.openID and:2];
                        [weakSelf lyUserBoundWechat:userInfo];
                    }];
                }
            }];
        }else{
            
            [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessTokenStr compelete:^(UserModel *userInfo) {
                [weakSelf bangding:userInfo.openID and:2];
                [weakSelf lyUserBoundWechat:userInfo];
            }];
            
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixinCode" object:nil];
}

-(void)bangding:(NSString *)openid and:(NSInteger) type{
    NSString *string= [MyUtil encryptUseDES:openid];
    NSLog(@"----pass-pass%@---",string);
    
    NSString *plantType = nil;
    if(type==1) plantType = @"qq";
    else if(type==2) plantType = @"wechat";
    else plantType = @"weibo";
    if(plantType == nil) return;
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.userModel==nil) {
        return;
    }
    NSDictionary *paraDic = @{@"id": [NSString stringWithFormat:@"%d",delegate.userModel.userid] ,plantType:string};
    __weak typeof(self) weakself=self;
    [LYUserHttpTool tieQQWeixinAndSinaWithPara2:paraDic compelte:^(NSInteger flag) {//1 绑定成功 0 绑定失败
    }];
    
}

@end
