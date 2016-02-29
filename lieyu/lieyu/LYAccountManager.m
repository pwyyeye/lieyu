//
//  LYAccountManager.m
//  lieyu
//
//  Created by pwy on 16/1/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAccountManager.h"
#import "LYResetPasswordViewController.h"
#import "WXApi.h"
#import "LYHomePageHttpTool.h"
#import "UMSocial.h"
#import "LYUserHttpTool.h"

@implementation LYAccountManager

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"账户管理"; 
    _data=@[@"修改密码",@"绑定微信",@"绑定QQ",@"绑定微博"];
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
     self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }else{
        return 50;
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    

    if(indexPath.row==0){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10 , SCREEN_WIDTH, 50)];
        titleLabel.font=[UIFont systemFontOfSize:15.0];
        titleLabel.text=_data[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH,10);
        layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow.borderWidth=10;
        [cell.layer addSublayer:layerShadow];
        
        CALayer *layerShadow2=[[CALayer alloc]init];
        layerShadow2.frame=CGRectMake(0, cell.frame.origin.y+60, SCREEN_WIDTH,10);
        layerShadow2.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow2.borderWidth=10;
        [cell.layer addSublayer:layerShadow2];
    }else{
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0 , SCREEN_WIDTH, 50)];
        titleLabel.font=[UIFont systemFontOfSize:15.0];
        titleLabel.text=_data[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        
        NSString *imageName;
        NSString *isBingding;
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if (indexPath.row==1) {
            imageName=@"wechat_s";
            if (![MyUtil isEmptyString: app.userModel.wechat]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }else if (indexPath.row==2){
            imageName=@"qq_s";
            if (![MyUtil isEmptyString: app.userModel.qq]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }else if (indexPath.row==3){
            imageName=@"sina_weibo_s";
            if (![MyUtil isEmptyString: app.userModel.weibo]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }
        imageView.image=[UIImage imageNamed:imageName];
        [cell.contentView addSubview:imageView];
        
        
        UILabel *titleLabel2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 0 , 100, 50)];
        titleLabel2.font=[UIFont systemFontOfSize:14.0];
        titleLabel2.text=isBingding;
        titleLabel2.textAlignment=NSTextAlignmentRight;
        titleLabel2.textColor=RGB(101, 11, 138);
        [cell.contentView addSubview:titleLabel2];
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH,1);
        layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow.borderWidth=1;
        [cell.layer addSublayer:layerShadow];
        
        
    }
    
    
//    if(indexPath.row==0){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UIViewController *detailViewController;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if (indexPath.row==0) {
        detailViewController=[[LYResetPasswordViewController alloc] initWithNibName:@"LYResetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if (indexPath.row==1) {
        if(![WXApi isWXAppInstalled]){
            [MyUtil showCleanMessage:@"未安装微信"];
            return;
        }
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[MyUtil isEmptyString: app.userModel.wechat]?@"立即绑定":@"更换微信",@"取消绑定", nil];
        
        actionSheet.tag=255;
        
        [actionSheet showInView:self.view];
    }else if(indexPath.row==2){
        if(![TencentOAuth iphoneQQInstalled]){
            [MyUtil showCleanMessage:@"未安装QQ"];
            return;
        }
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[MyUtil isEmptyString: app.userModel.qq]?@"立即绑定":@"更换QQ",@"取消绑定", nil];
        
        actionSheet.tag=256;
        
        [actionSheet showInView:self.view];
        
      
    }else if(indexPath.row==3){
//        [MyUtil showCleanMessage:@"暂不支持微博绑定！"];
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[MyUtil isEmptyString: app.userModel.weibo]?@"立即绑定":@"更换微播",@"取消绑定", nil];
        
        actionSheet.tag=257;
        
        [actionSheet showInView:self.view];
    }
    
    
    
}

#pragma mark - qq登录
- (void)qqLogin{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104853065" andDelegate:self];
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
    [self bangding:_tencentOAuth.openId and:1];
  
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
    __block LYAccountManager *weakSelf = self;
    NSTimeInterval timeWeixin_re = [[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinReDate"] timeIntervalSince1970];
    
    if([MyUtil isEmptyString:accessTokenStr] || timeNow - timeWeixin_re > 60 * 60 * 24 * 30){//refreshToken超过30tian
        [LYHomePageHttpTool getWeixinAccessTokenWithCode:[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinCode"] compelete:^(NSString *accessToken) {
            if(![MyUtil isEmptyString:accessToken]){
                [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessToken compelete:^(UserModel *userInfo) {
                    if(userInfo){
                        [weakSelf bangding:userInfo.openID and:2];
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
                    }];
                }
            }];
        }else{
            
            [LYHomePageHttpTool getWeixinUserInfoWithAccessToken:accessTokenStr compelete:^(UserModel *userInfo) {
                [weakSelf bangding:userInfo.openID and:2];
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
        if (flag) {//绑定
            if(type==1) delegate.userModel.qq=string;
            else if(type==2) delegate.userModel.wechat=string;
            else delegate.userModel.weibo=string;
            [weakself.tableView reloadData];
            [MyUtil showPlaceMessage:@"绑定成功"];
        }else{
            [MyUtil showPlaceMessage:@"绑定失败"];
        }
    }];

}

-(void)cancelBangding:(NSInteger) type{

    
    NSString *plantType = nil;
    if(type==1) plantType = @"qq";
    else if(type==2) plantType = @"wechat";
    else plantType = @"weibo";
    if(plantType == nil) return;
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.userModel==nil) {
        return;
    }
    NSDictionary *paraDic = @{@"id": [NSString stringWithFormat:@"%d",delegate.userModel.userid] ,plantType:@""};
    __weak typeof(self) weakself=self;
    [LYUserHttpTool tieQQWeixinAndSinaWithPara2:paraDic compelte:^(NSInteger flag) {//1 绑定成功 0 绑定失败
        if (flag) {//绑定
            if(type==1) delegate.userModel.qq=@"";
            else if(type==2) delegate.userModel.wechat=@"";
            else delegate.userModel.weibo=@"";
            [weakself.tableView reloadData];
            [MyUtil showPlaceMessage:@"取消绑定成功"];
        }else{
            [MyUtil showPlaceMessage:@"取消绑定失败"];
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
                [self bangding:userModel.openID and:3];
            }
        }});
    
    //    LYRegistrationViewController
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==255) {
        switch (buttonIndex) {
            case 0:
                //更换
                [self weixinLogin];
                break;
            case 1:
                //取消
                [self cancelBangding:2];
                break;
            case 2:
                //取消
                return;
                break;
            default:
                break;
        }
        
        
    }else if(actionSheet.tag==256){
        switch (buttonIndex) {
            case 0:
                //更换
                [self qqLogin];
                break;
            case 1:
                //取消
                [self cancelBangding:1];
                break;
            case 2:
                //取消
                return;
                break;
            default:
                break;
        }
    
    }else if(actionSheet.tag==257){
        switch (buttonIndex) {
            case 0:
                //更换
                [self weiboLogin];
                break;
            case 1:
                //取消
                [self cancelBangding:3];
                break;
            case 2:
                //取消
                return;
                break;
            default:
                break;
        }
        
    }
    
}

@end
