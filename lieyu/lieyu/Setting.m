//
//  Setting.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "Setting.h"
#import "LYUserHttpTool.h"
#import "LYUserDetailInfoViewController.h"
#import "LYUserDetailController.h"
#import "AboutLieyu.h"
#import "SDImageCache.h"
#import "LYAccountManager.h"
#import "MyZSManageViewController.h"
#import "LYZSApplicationViewController.h"
#import "UMSocial.h"
#import "UserNotificationViewController.h"
#import "LPUserLoginViewController.h"
#import "ZSApplyStatusModel.h"
#import "WechatCheckAccountViewController.h"
#import "checkUnpassedViewController.h"
#import "IQKeyboardManager.h"
#import "LYPrivateViewController.h"

@interface Setting (){
    UIButton *_logoutButton;
    UserModel *userModel;
    ZSApplyStatusModel *statusModel;
    BOOL canApply;//
    int enterStep;//1开始、2支付
    NSString *sn;
}

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    _data=@[@"编辑个人资料",@"清除缓存",@"通知",@"账户管理",@"猎娱APP分享",@"申请专属经理",@"关于猎娱",@"收货地址"];
//    _data=@[@"编辑个人资料",@"清除缓存",@"通知",@"账户管理",@"猎娱APP分享",@"申请专属经理",@"关于猎娱"];
    _data = @[@"账户管理",@"通知设置",@"隐私设置",@"清除缓存",@"分享猎娱",@"帮助与反馈",@"关于猎娱"];
    
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.frame=CGRectMake(8, 64, SCREEN_WIDTH - 16, SCREEN_HEIGHT);
//    self.tableView.bounces=NO;
    
    
     
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"个人设置";
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logout{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    __weak __typeof(self) weakSelf = self;
    [[LYUserHttpTool shareInstance] userLogOutWithParams:@{@"sessionid":app.s_app_id,@"id":[NSString stringWithFormat:@"%d",app.userModel.userid]} block:^(BOOL result) {
        if (result) {
            app.s_app_id=nil;
            app.userModel=nil;
            [USER_DEFAULT removeObjectForKey:@"username"];
            [USER_DEFAULT removeObjectForKey:@"password"];
            [USER_DEFAULT removeObjectForKey:@"OPENIDSTR"];
            [USER_DEFAULT removeObjectForKey:@"FriendUserBgImage"];
            
//            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
//            if([MyUtil isEmptyString:app.s_app_id]){
                LPUserLoginViewController *login=[[LPUserLoginViewController alloc] initWithNibName:@"LPUserLoginViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:login animated:YES];
                
//            

//            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFirstViewController" object:nil];
//             [weakSelf.navigationController popViewControllerAnimated:YES ];
        }
    }];

}

- (void)getApplyType{
    [LYUserHttpTool getZSJLStatusComplete:^(ZSApplyStatusModel *model) {
        statusModel = model;
//        statusModel.applyType 1.支付宝 2.银行卡 3.微信
//        statusModel.wechatAccount
//        userModel.applyStatus 0.未申请 1.审核中 2.已审核 3.审核未通过 4.待处理
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 218, 10, 200, 30)];
        label.textAlignment = NSTextAlignmentRight;
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setTextColor:COMMON_PURPLE];
        [label setFont:[UIFont systemFontOfSize:14]];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell addSubview:label];
        if (userModel.applyStatus == 1) {
            if ([statusModel.applyType isEqualToString:@"3"] && !statusModel.wechatAccount.length) {
                [label setText:@"请完成支付确认!"];
                canApply = YES;
                enterStep = 2;
                sn=statusModel.sn;
            }else{
                [label setText:@"审核中"];
            }
        }else if(userModel.applyStatus == 0){
            canApply = YES;
            enterStep = 1;
        }else if (userModel.applyStatus == 3){
            [label setText:@"审核未通过"];
            canApply = YES;
            enterStep = 3;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(indexPath.row == 3 || indexPath.row == 6) return 60;
    else return 50;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [cell viewWithTag:10086];
    if (label) {
        [label removeFromSuperview];
    }
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height-10)];
//    label.backgroundColor=[UIColor whiteColor];
//    //清除cell背景颜色 在底部添加白色背景label 高度小于cell 使之看起来有间隔
//    cell.backgroundColor=[UIColor clearColor];
//    cell.contentView.backgroundColor=[UIColor clearColor];
//    
//    [cell.contentView insertSubview:label atIndex:0];
//
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, (SCREEN_WIDTH - 16), 50)];
    titleLabel.tag = 10086;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.layer.masksToBounds = YES;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    if(indexPath.row == 0 || indexPath.row == 4){
            shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)].CGPath;
            titleLabel.layer.mask = shapeLayer;
    }else if(indexPath.row == 3 || indexPath.row == 6){
        shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)].CGPath;
        titleLabel.layer.mask = shapeLayer;
    }
//    else if(indexPath.row == 6|| indexPath.row == 7){
//        titleLabel.layer.cornerRadius = 2;
//    }
    titleLabel.text=[NSString stringWithFormat:@"  %@",_data[indexPath.row]];
    [cell.contentView addSubview:titleLabel];
    
    
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.backgroundColor = RGB(237, 237, 237).CGColor;
    if (indexPath.row == 3 || indexPath.row == 6) {
        layerShadow.frame=CGRectMake(0,50 , SCREEN_WIDTH, 10);
    }else{
    layerShadow.frame=CGRectMake(0, 49, SCREEN_WIDTH,  1);
    }
    [cell.layer addSublayer:layerShadow];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    
//    if([userModel.usertype isEqualToString:@"1"] &&indexPath.row == 1){
//        //普通用户
//        [self getApplyType];
//    }
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowRight"]];
    imgView.frame = CGRectMake(SCREEN_WIDTH - 26, 17, 8, 15 );
    [cell addSubview:imgView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UIViewController *detailViewController;
    
   /* if (indexPath.row==0) {
//        [self gotoAppStorePageRaisal:@""];//app评价地址
//        detailViewController=[[LYUserDetailInfoViewController alloc] init];
        
    }else*/ if (indexPath.row==4) {
        NSString *string= [NSString stringWithFormat:@"猎娱 | 中高端玩咖美女帅哥社交圈，轻奢夜生活娱乐！"];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageNamed:@"CommonIcon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
        
        [USER_DEFAULT removeObjectForKey:@"user_name"];
        [USER_DEFAULT removeObjectForKey:@"user_pass"];
    }else if(indexPath.row == 2){
        //隐私设置
        detailViewController = [[LYPrivateViewController alloc]init];
    }else if(indexPath.row==0){
        detailViewController=[[LYAccountManager alloc] init];
    }else if(indexPath.row == 3){
        [USER_DEFAULT removeObjectForKey:@"OPENIDSTR"];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[LYCoreDataUtil shareInstance] deleteLocalSQLLite];
        [MyUtil showMessage:@"清除成功！"];
    }else if(indexPath.row==6){
        detailViewController=[[AboutLieyu alloc] initWithNibName:@"AboutLieyu" bundle:nil];
    }else if (indexPath.row == 1){
//        if([userModel.usertype isEqualToString:@"2"] && !canApply){
//            [MyUtil showLikePlaceMessage:@"您已经是专属经理了！"];
//            return;
//        }else if ([userModel.usertype isEqualToString:@"1"]){
//            if (userModel.applyStatus == 1 && !canApply) {
//                [MyUtil showLikePlaceMessage:@"正在审核中！"];
//                return;
//            }
//        }
//        if (canApply && enterStep == 1) {
//            detailViewController = [[LYZSApplicationViewController alloc]initWithNibName:@"LYZSApplicationViewController" bundle:nil];
//            detailViewController.title=@"申请专属经理";
//        }else if (canApply && enterStep == 2){
//            detailViewController = [[wechatCheckAccountViewController alloc]initWithNibName:@"wechatCheckAccountViewController" bundle:nil];
//            ((wechatCheckAccountViewController *)detailViewController).nsCode=sn;
//            detailViewController.title = @"微信帐号验证";
//        }else if (canApply && enterStep == 3){
//            detailViewController = [[checkUnpassedViewController alloc]initWithNibName:@"checkUnpassedViewController" bundle:nil];
//            detailViewController.title = @"申请专属经理";
//        }else if ([userModel.usertype isEqualToString:@"3"] || userModel.applyStatus == 4){
//            [MyUtil showLikePlaceMessage:@"您已经是专属经理！"];
//        }
        detailViewController = [[UserNotificationViewController alloc]init];
    }else if(indexPath.row == 5){
        //统计我的页面的选择
        NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"设置页面",@"titleName":@"客服"};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
        
        RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
        conversationVC.conversationType = ConversationType_APPSERVICE;
        conversationVC.targetId = @"KEFU144946169476221";//KEFU144946169476221 KEFU144946167494566  测试
        conversationVC.title = @"猎娱客服";
        [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
        [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [view addSubview:button];
        [button addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
        conversationVC.navigationItem.leftBarButtonItem = item;
        [self.navigationController pushViewController:conversationVC animated:YES];
        [conversationVC.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)backForword{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        return;
    }
    if(self.tableView.contentSize.height + 40 >= SCREEN_HEIGHT){
    if(_logoutButton == nil){
    _logoutButton=[[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height , SCREEN_WIDTH, 40)];
    _logoutButton.backgroundColor=[UIColor clearColor];
    
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    _logoutButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_logoutButton setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
//    __weak __typeof(self) weakSelf = self;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [self.view addSubview:_logoutButton];
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 40);
//    });
    }
        
    }else{
        _logoutButton=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40 - 64 -10, SCREEN_WIDTH, 40)];
        _logoutButton.backgroundColor=[UIColor clearColor];
        
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_logoutButton setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//        __weak __typeof(self) weakSelf = self;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            [self.view addSubview:_logoutButton];
//        });
    }
}



- (void)dealloc{
    NSLog(@"dealloc");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//去app页面评价
-(void) gotoAppStorePageRaisal:(NSString *) nsAppId
{
    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",nsAppId  ];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
}

@end
