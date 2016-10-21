//
//  ZSMaintViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSMaintViewController.h"
#import "FunctionListCell.h"
#import "ZSSeatControlView.h"
#import "ZSOrderViewController.h"
#import "ZSMyClientsViewController.h"
#import "ZSMyShopsManageViewController.h"
#import "ZSNoticeCenterViewController.h"
#import "XiaoFeiMaUiew.h"
#import "ZSListCell.h"
#import "LYRecentContactViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SaoYiSaoViewController.h"
#import "LYUserHttpTool.h"
#import "ZSMyReceiveViewController.h"
#import "ZSManageHttpTool.h"
#import "ZSBalance.h"
#import "FindNotificationViewController.h"
#import "OrderTTL.h"
#import "MainTabbarViewController.h"
#import "LYMyFreeOrdersViewController.h"
#import "ZSManageCustomerViewController.h"

@interface ZSMaintViewController ()<UITextFieldDelegate>{
    UIButton *_balanceButton;
    ZSBalance *_balance;
    UIVisualEffectView *_effctView;
    OrderTTL *_orderTTL;
}
@property (nonatomic,strong) UINavigationController *navShangHu;
@end

@implementation ZSMaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [self initRightItem];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    listArr =[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets=1;
    self.tableView.bounces=NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self getDataForShowList];
    
    
    //   [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToShanHu) name:@"loadUserInfo" object:nil];
    //    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [app addObserver:self forKeyPath:@"desKey" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"loadUserInfo" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"商户中心";
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![MyUtil isEmptyString:app.s_app_id]) {
        [self getBalance];
        [self getBadge];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UITextField *text = [self.view viewWithTag:123];
    text.text = @"";
}

- (void)initRightItem{
    UIButton *userButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [userButton setTitle:@"用户版" forState:UIControlStateNormal];
    [userButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [userButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [userButton setTitleColor:NAVIGATIONBARTITLECOLOR forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(gotoUserInterface) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:userButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)getData{
    [self getBalance];
    [self getBadge];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadUserInfo" object:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    [self getBalance];
//    [self getBadge];
//}

- (void)getBalance{
    [[ZSManageHttpTool shareInstance] getPersonBalanceWithParams:nil complete:^(ZSBalance *balance) {
        
        _balance = balance;
        [_balanceButton setTitle:[NSString stringWithFormat:@"%.2f",_balance.balances.floatValue] forState:UIControlStateNormal];
        
    }];
}

- (void)dealloc{
    NSLog(@"----pass-pass%@---",@"test");
}

#pragma mark 初始化数据
-(void)getDataForShowList{
    [listArr removeAllObjects];
    NSDictionary *myNotification = @{@"colorRGB":RGB(65, 154, 241),@"imageContent":@"shopMyNotification",@"title":@"消息中心",@"delInfo":@""};
    NSDictionary *myReceiveDic = @{@"colorRGB":RGB(254, 221, 87),@"imageContent":@"shopMyReceive",@"title":@"我的收入",@"delInfo":@""};
    NSDictionary *dic=@{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座设置",@"delInfo":@""};
    NSDictionary *dic1=@{@"colorRGB":RGB(136, 223, 121),@"imageContent":@"Fill20179",@"title":@"最近联系",@"delInfo":@"您有客户留言请及时查收"};
    NSDictionary *dic2=@{@"colorRGB":RGB(254, 147, 87),@"imageContent":@"Fill20219",@"title":@"订单管理",@"delInfo":@"您有订单要处理请及时确定"};
    NSDictionary *dic3=@{@"colorRGB":RGB(65, 241, 221),@"imageContent":@"Fill20176",@"title":@"客户管理",@"delInfo":@""};
    NSDictionary *dic5=@{@"colorRGB":RGB(154, 147, 87),@"imageContent":@"Fill20520",@"title":@"免费订台",@"delInfo":@"您有订单要处理请及时确定"};
    NSDictionary *dic6 = @{@"colorRGB":RGB(154, 147, 87),@"imageContent":@"Fill20520",@"title":@"套餐管理",@"delInfo":@""};
    [listArr addObject:myNotification];//消息中心
    [listArr addObject:myReceiveDic];//我的收入
    [listArr addObject:dic2];//订单管理
    [listArr addObject:dic5];//免费订台
    //    [listArr addObject:dic4];//速核码扫描
    [listArr addObject:dic];//卡座设置
    [listArr addObject:dic6];//新增套餐管理
    [listArr addObject:dic1];//最近联系
    [listArr addObject:dic3];//客户管理
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157)];
    
    //    view.backgroundColor=RGB(35, 166, 116);
    //    view.backgroundColor = RGB(186, 40, 227);
    view.backgroundColor = COMMON_GRAY;
    
    
    UIButton *suheButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH / 2, 106)];
    [suheButton setBackgroundColor:[UIColor whiteColor]];
    [suheButton addTarget:self action:@selector(zsQRCodeScanClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:suheButton];
    UIImageView *suheImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 17, 25, 34, 34)];
    [suheImageView setImage:[UIImage imageNamed:@"businessSuhe"]];
    suheImageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *suheLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 25, 63, 50, 20)];
    [suheLabel setText:@"速核码"];
    [suheLabel setTextAlignment:NSTextAlignmentCenter];
    [suheLabel setFont:[UIFont systemFontOfSize:14]];
    [suheLabel setTextColor:[UIColor blackColor]];
    [suheButton addSubview:suheImageView];
    [suheButton addSubview:suheLabel];
    
    UIButton *balanceButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/ 2, 6, SCREEN_WIDTH/ 2, 106)];
    [balanceButton setBackgroundColor:[UIColor whiteColor]];
    [balanceButton addTarget:self action:@selector(pushMyReceived) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:balanceButton];
    UIImageView *balanceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 20, 30, 40, 32)];
    [balanceImageView setImage:[UIImage imageNamed:@"balanceIcon"]];
    balanceImageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 25, 63, 50, 20)];
    [balanceLabel setText:@"余额"];
    [balanceLabel setTextAlignment:NSTextAlignmentCenter];
    [balanceLabel setFont:[UIFont systemFontOfSize:14]];
    [balanceLabel setTextColor:[UIColor blackColor]];
    [balanceButton addSubview:balanceLabel];
    [balanceButton addSubview:balanceImageView];
    
    UILabel *spaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 25, 0.5, 68)];
    [spaceLabel setBackgroundColor:RGBA(204, 204, 204, 1)];
    [view addSubview:spaceLabel];
    
    UIView *textPlaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, 45)];
    [textPlaceView setBackgroundColor:COMMON_GRAY];
    [view addSubview:textPlaceView];
    
    UITextField *textView = [[UITextField alloc]initWithFrame:CGRectMake(5, 6, SCREEN_WIDTH - 10, 33)];
    textView.placeholder = @"输入用户消费码";
    textView.font = [UIFont systemFontOfSize:18];
    textView.delegate = self;
    textView.tag = 123;
    textView.borderStyle = UITextBorderStyleRoundedRect;
    textView.layer.borderColor = [[UIColor clearColor] CGColor];
    textView.layer.borderWidth = 0.f;
    textView.keyboardType = UIKeyboardTypeNumberPad;
    textView.textAlignment = NSTextAlignmentCenter;
    [textPlaceView addSubview:textView];
    
    //返回按钮
    _btnBack=[[UIButton alloc] initWithFrame:CGRectMake(5, 10, 48, 48)];
    [_btnBack setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    _btnBack.hidden = _btnBackHidden;
    [_btnBack addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnBack];
    self.tableView.tableHeaderView=view;
    [self.tableView reloadData];
}

//跳转到我的帐号界面
- (void)pushMyReceived{
    ZSMyReceiveViewController *zsMyReceiveVC = [[ZSMyReceiveViewController alloc]init];
    if(_balance == nil){
        [MyUtil showCleanMessage:@"余额获取失败"];
        [MyUtil gotoLogin];
        return;
    }
    zsMyReceiveVC.balance = _balance;
    [self.navigationController pushViewController:zsMyReceiveVC animated:YES];
}


#pragma mark - 角标
- (void)getBadge{
    [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
        _orderTTL=result;
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
        ZSListCell *cell = [_tableView cellForRowAtIndexPath:indexP];
        if (result.pushMessageNum > 0) {//有消息
            cell.mesImageView.hidden = NO;
        }else{//无新消息
            cell.mesImageView.hidden = YES;
        }
    }];
    
    
    int pageCount = 0,perCount = 20;
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"1,2"};
    [[ZSManageHttpTool shareInstance]getZSOrderList2WithParams:dic block:^(NSMutableArray *result) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:2 inSection:0];
        ZSListCell *cell = [_tableView cellForRowAtIndexPath:indexP];
        if (result.count > 0) {//有消息
            cell.mesImageView.hidden = NO;
        }else{//无新消息
            cell.mesImageView.hidden = YES;
        }
        
    }];
}

#pragma mark - 扫一扫
- (void)zsQRCodeScanClick{
    SaoYiSaoViewController *saoyisaoVC = [[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
    [self.navigationController pushViewController:saoyisaoVC animated:YES];
}

#pragma mark - 输入完消费码之后
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *consuer = [MyUtil encryptUseDES:textField.text withKey:app.desKey];
        NSDictionary *dic = @{@"consumptionCode":consuer};
        __weak __typeof(self) weakSelf = self;
        [LYUserHttpTool zsCheckConsumerIDWith:dic complete:^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (![MyUtil isEmptyString:app.s_app_id]) {
                [weakSelf getBalance];
                [weakSelf getBadge];
            }
        }];
        
        
        textField.text = @"";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}

#pragma mark tableview代理方法
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == listArr.count) {
    //        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //        cell.textLabel.text = @"切换为用户版";
    //        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //        return cell;
    //    }
    static NSString *CellIdentifier = @"ZSListCell";
    
    ZSListCell *cell = (ZSListCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ZSListCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    NSDictionary *dic=[listArr objectAtIndex:indexPath.row];
    //    UIColor *bColor=[dic objectForKey:@"colorRGB"];
    //    UIImage *imge=[UIImage imageNamed:[dic objectForKey:@"imageContent"]];
    NSString *title=[dic objectForKey:@"title"];
    [cell.mesImageView setHidden:YES];
    //    cell.backImageView.backgroundColor=bColor;
    //    cell.CoutentImageView.image=imge;
    cell.titleLbl.text=title;
    //    cell.delLal.text=delInfo;
    //    cell.disImageView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row == 0) {
        //消息中心
        FindNotificationViewController *findNotificationVC = [[FindNotificationViewController alloc]init];
        [self.navigationController pushViewController:findNotificationVC animated:YES];
    }else if (indexPath.row == 1){
        //我的收入
        ZSMyReceiveViewController *zsMyReceiveVC = [[ZSMyReceiveViewController alloc]init];
        if(_balance == nil){
            [MyUtil showCleanMessage:@"余额获取失败"];
            [MyUtil gotoLogin];
            return;
        }
        zsMyReceiveVC.balance = _balance;
        [self.navigationController pushViewController:zsMyReceiveVC animated:YES];
    }else if (indexPath.row == 2){
        //订单管理
        ZSOrderViewController *orderManageViewController=[[ZSOrderViewController alloc]initWithNibName:@"ZSOrderViewController" bundle:nil];
        [self.navigationController pushViewController:orderManageViewController animated:YES];
    }else if (indexPath.row == 3){
        //免费订台
        NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"商户中心",@"titleName":@"免费订台"};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
        
        LYMyFreeOrdersViewController *freeOrderVC = [[LYMyFreeOrdersViewController alloc]init];
        freeOrderVC.isFreeOrdersList = YES;
        [self.navigationController pushViewController:freeOrderVC animated:YES];
    }else if (indexPath.row == 4){
        //卡座设置
        ZSSeatControlView *seatControlView=[[ZSSeatControlView alloc]initWithNibName:@"ZSSeatControlView" bundle:nil];
        [self.navigationController pushViewController:seatControlView animated:YES];
    }else if (indexPath.row == 5){
        //套餐管理
        [MyUtil showPlaceMessage:@"套餐管理敬请期待！"];
    }else if (indexPath.row == 6){
        //最近联系
        LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
        [self.navigationController pushViewController:chat animated:YES];

    }else if (indexPath.row == 7){
        //客户管理
        ZSManageCustomerViewController *zsManagerCustomerVC = [[ZSManageCustomerViewController alloc]init];
        [self.navigationController pushViewController:zsManagerCustomerVC animated:YES];
    }else if (indexPath.row == 8){
        
    }
}

- (void)gotoUserInterface{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LYMain" bundle:[NSBundle mainBundle]];
    NSLog(@"--->%@",[storyBoard instantiateViewControllerWithIdentifier:@"LYNavigationController"]);
    UINavigationController *nav = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"LYNavigationController"];
    app.navigationController = nav;
    app.window.rootViewController = nav;
    MainTabbarViewController *tabVC = (MainTabbarViewController *)nav.viewControllers.firstObject;
    tabVC.selectedIndex = tabVC.viewControllers.count - 1;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shanghuban"];
    
    if(app.userModel.usertype.intValue==2 || app.userModel.usertype.intValue == 3){
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effctView = [[UIVisualEffectView alloc]initWithEffect:effect];
        //            effctView.frame = [UIScreen mainScreen].bounds;
        _effctView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [window addSubview:_effctView];
        
        CGFloat imgVWidth = 50;
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgVWidth, imgVWidth)];
        imgV.center = _effctView.center;
        imgV.image = [UIImage imageNamed:@"loading1"];
        [_effctView addSubview:imgV];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame),SCREEN_WIDTH, imgVWidth)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"切换中....";
        [_effctView addSubview:titleLabel];
        
        NSMutableArray *imgArray = [[NSMutableArray alloc]initWithCapacity:9];
        for (int i = 1; i < 10; i ++) {
            
            UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d@2x",i] ofType:@"png"]];
            [imgArray addObject:(__bridge UIImage *)img.CGImage];
        }
        
        CAKeyframeAnimation *keyFrameA = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        keyFrameA.duration = imgArray.count * 0.1;
        keyFrameA.delegate = self;
        keyFrameA.values = imgArray;
        keyFrameA.repeatCount = 1;
        [imgV.layer addAnimation:keyFrameA forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [UIView animateWithDuration:0.2 animations:^{
        _effctView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_effctView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
