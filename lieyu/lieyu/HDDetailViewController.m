//
//  HDDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "HDDetailViewController.h"
#import "HeaderTableViewCell.h"
#import "HDDetailTableViewCell.h"
#import "LYDinWeiTableViewCell.h"
#import "LPAlertView.h"
#import "ChooseNumber.h"
#import "UIImageView+WebCache.h"
#import "YUOrderInfo.h"
#import "LYUserLocation.h"
#import "LYHomePageHttpTool.h"
#import "BeerNewBarViewController.h"
#import "YUPinkerinfo.h"
#import "YUPinkerListModel.h"
#import "LYMyOrderManageViewController.h"
#import "ChoosePayController.h"
#import "LYFriendsToUserMessageViewController.h"
#import "DetailView.h"
#import "preview.h"
#import "UMSocial.h"
#import "LYYUHttpTool.h"
#import "LYUserLoginViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LPMyOrdersViewController.h"

@interface HDDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate,showImageInPreview>
{
    YUOrderInfo *orderInfo;
    YUPinkerinfo *pinkeModel;
    YUPinkerListModel *listModel;
    int store;
    double allMoney;
    AppDelegate *app;
}
@property (nonatomic, strong) HeaderTableViewCell *headerCell;
@property (nonatomic, strong) LYDinWeiTableViewCell *LYdwCell;
@property (nonatomic, strong) HDDetailTableViewCell *HDDetailCell;
@property (nonatomic, strong) JoinedTableViewCell *joinedCell;
@property (nonatomic, strong) ChooseNumber *chooseNumber;

@property (nonatomic, strong) preview *subView;

@end

@implementation HDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.joinBtn.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self getData];
    [MTA trackCustomEvent:@"ZJDetail" args:nil];
//    orderInfo = _YUModel.orderInfo;
//    pinkeModel = orderInfo.pinkerinfo;
//    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 52);
//    [self configureStore];
    [self configureRightItem];
//    [self configurePinkeStatus];
    [self registerCell];
    self.label_bottom.layer.shadowColor = [RGBA(0, 0, 0, 0.2) CGColor];
    self.label_bottom.layer.shadowOffset = CGSizeMake(-1, 0);
    self.label_bottom.layer.shadowOpacity = 0.5;
    self.label_bottom.layer.shadowRadius = 1;
    self.title = @"活动详情";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

#pragma mark - 获取数据
- (void)getData{
    if (_YUModel!=nil&&_YUid==nil) {
        _YUid=_YUModel.id;
    }
    NSDictionary *dict = @{@"id":_YUid};
    __weak __typeof(self) weakSelf = self;
    [LYYUHttpTool yuGetYuModelWithParams:dict complete:^(YUOrderShareModel *YUModel) {
        _YUModel = YUModel;
        orderInfo = _YUModel.orderInfo;
        pinkeModel = orderInfo.pinkerinfo;
        [weakSelf configurePinkeStatus];
        [weakSelf configureStore];
        [weakSelf.tableView reloadData];
        weakSelf.joinBtn.hidden = NO;
    }];
}

#pragma mark - 右侧按钮
- (void)configureRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [button addTarget:self action:@selector(shareZuju) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 分享组局
- (void)shareZuju{
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"活动详情",@"titleName":@"分享"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //http://121.40.229.133:8001/lieyu/inPinkerWebAction.do?id=77
    NSString *ss=[NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩~",app.userModel.usernick,orderInfo.barinfo.barname];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%@",LY_SERVER,orderInfo.id];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%@",LY_SERVER,orderInfo.id];
    @try {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UmengAppkey
                                          shareText:ss
                                         shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderInfo.pinkerinfo.linkUrl]]]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                           delegate:nil];
    }
    @catch (NSException *exception) {
        [MyUtil showCleanMessage:@"无法分享！"];
    }
    @finally {
        
    }
}

#pragma mark - 计算剩余参与人数
- (void)configureStore{
    int num = 0;
    for (int i = 0 ; i < orderInfo.pinkerList.count; i ++) {
        listModel = [orderInfo.pinkerList objectAtIndex:i];
        num = num + [listModel.quantity intValue];
    }
    store = [orderInfo.allnum intValue] - num ;
    if(store <= 0){
        self.joinBtn.enabled = NO;
        self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
    }
}

#pragma mark - 判断拼客形成
- (void)configurePinkeStatus{
    if(![orderInfo.orderStatus isEqualToString:@"0"]){
        self.joinBtn.enabled = NO;
        self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
    }
    if ([[MyUtil residueTimeFromDate:orderInfo.reachtime] isEqualToString:@"已过期"]) {
        [self.joinBtn setTitle:@"已过期" forState:UIControlStateNormal];
        self.joinBtn.enabled = NO;
        self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
    }
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    for (YUPinkerListModel *pinker in orderInfo.pinkerList) {
        if (delegate.userModel!=nil) {
            if (pinker.inmember.intValue==delegate.userModel.userid) {
                self.joinBtn.enabled = NO;
                if (pinker.paymentStatus!=nil&& pinker.paymentStatus.intValue==1) {
                    [self.joinBtn setTitle:@"已参与" forState:UIControlStateNormal];
                }else{
                    [self.joinBtn setTitle:@"已参与(待付款)" forState:UIControlStateNormal];
                }
                
                self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
                break;
            }
        }
    }
}

#pragma mark - 注册cell
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JoinedTableViewCell" bundle:nil] forCellReuseIdentifier:@"JoinedTableViewCell"];
}

#pragma mark - tableView的代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_YUModel){
        return 5;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        _headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderTableViewCell" forIndexPath:indexPath];
        [_headerCell.avatar_button addTarget:self action:@selector(CheckMyMessage) forControlEvents:UIControlEventTouchUpInside];
        if (_YUModel) {
            [_headerCell setYUShare:_YUModel];
        }
        if (orderInfo) {
            [_headerCell setOrderInfo:orderInfo];
        }
//        [_headerCell.avatar_image sd_setImageWithURL:[NSURL URLWithString:orderInfo.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
//        _headerCell.name_label.text = orderInfo.username;
//        _headerCell.viewNumber_label.text = @"";
//        _headerCell.title_label.text = _YUModel.shareContent;
        _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _headerCell;
    }else if (indexPath.section == 1){
        _LYdwCell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
        [_LYdwCell.imageView_button addTarget:self action:@selector(clickThisImageView) forControlEvents:UIControlEventTouchUpInside];
        _LYdwCell.pinkeInfo = pinkeModel;
        _LYdwCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _LYdwCell;
    }else if(indexPath.section == 2){
        _HDDetailCell = [tableView dequeueReusableCellWithIdentifier:@"HDDetailTableViewCell" forIndexPath:indexPath];
        _HDDetailCell.YUModel = _YUModel;
        _HDDetailCell.orderInfo = orderInfo;
        
        double payamout;
        if ([orderInfo.pinkerType isEqualToString:@"0"]) {
            //发起人请客
            payamout = 0 ;
        }else if([orderInfo.pinkerType isEqualToString:@"1"]){
            //AA付款
            payamout = orderInfo.amountPay.doubleValue / [orderInfo.allnum intValue];
        }else if ([orderInfo.pinkerType isEqualToString:@"2"]){
            //发起人自由付款，其他人AA
            NSLog(@"amountPay:%f",orderInfo.amountPay.doubleValue - 0.01);
             payamout = (orderInfo.amountPay.doubleValue - 0.01) / ([orderInfo.allnum intValue] - 1);
        }

        NSString *payStr = [NSString stringWithFormat:@"¥%.2f",payamout];
        _HDDetailCell.label_prieceWayRight.text = payStr;
        
        [_HDDetailCell.checkAddress_button addTarget:self action:@selector(checkAddress) forControlEvents:UIControlEventTouchUpInside];
        [_HDDetailCell.checkBar_button addTarget:self action:@selector(checkBar) forControlEvents:UIControlEventTouchUpInside];
        _HDDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _HDDetailCell;
    }else if(indexPath.section == 3){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureJoinedNumber:[orderInfo.allnum intValue]andPeople:orderInfo];
        _joinedCell.delegate = self;
        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _joinedCell;
//    }else if(indexPath.section == 4){
//        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
//        [_joinedCell configureMessage];
//        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return _joinedCell;
    }else if (indexPath.section == 4){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureMoreAction];
        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _joinedCell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        _headerCell.title_label.font = [UIFont systemFontOfSize:14];
        CGSize size = [_headerCell.title_label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 146, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        height = size.height + 51;
    }else if (indexPath.section == 1){
        height = 104;
    }else if(indexPath.section == 2){
        height = 243;
    }else if (indexPath.section == 3){
        int width = SCREEN_WIDTH - 24;
        int shang = width / 50;
        int yushu = width % 50;
        if(yushu / 10 * 50 >= 40){
            shang ++;
        }
        //shang为一行能摆几个头像
        int row = (int)orderInfo.pinkerList.count / shang;
        int duoyu = orderInfo.pinkerList.count % shang;
        if(duoyu > 0){
            row ++;
        }
        height = row * 50 + 34;
    }else if(indexPath.section == 4){
        height = 164;
    }else if(indexPath.section == 5){
        return 320 / 16 * 9;
    }
    return height;
}

#pragma --mark 参与拼客

- (IBAction)WannaJoin:(UIButton *)sender {
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel){
        LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
        alertView.delegate = self;
        _chooseNumber = [[[NSBundle mainBundle]loadNibNamed:@"ChooseNumber" owner:nil options:nil]firstObject];
        _chooseNumber.tag = 14;
        
        _chooseNumber.store = store;
        _chooseNumber.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20, 250);
        [_chooseNumber configureTitle];
        alertView.contentView = _chooseNumber;
        [alertView show];
    }else{
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
    if(buttonIndex){
        
        NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"活动详情",@"titleName":@"想要参加",@"value":[NSString stringWithFormat:@"%d",app.userModel.userid]};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
        
        allMoney = [orderInfo.amountPay doubleValue];
        //    orderInfo.pinkerType
        //    0、请客 1、AA付款 2、自由付款 （发起人自由 其他AA）
        //    _YUModel.allowSex
        //    0、只有女生 1、只有男生 2、全部
        //    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    _context = app.managedObjectContext;
        //    _userid = [NSString stringWithFormat:@"%d",app.userModel.userid];
        
        //    app.userModel.gender   0表示女生
        if ([_YUModel.allowSex isEqualToString:@"2"]) {
            //全部都可以参加
        }else if ([_YUModel.allowSex isEqualToString:@"0"]){
            if (![app.userModel.gender isEqualToString:@"0"]) {
                //不是女生
                [MyUtil showCleanMessage:@"抱歉，该组局仅允许女生加入"];
                return;
            }
        }else if ([_YUModel.allowSex isEqualToString:@"1"]){
            if (![app.userModel.gender isEqualToString:@"1"]) {
                //不是男生
                [MyUtil showCleanMessage:@"抱歉，该组局仅允许男生生加入"];
                return;
            }
        }
        
        app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if(app.userModel.userid==orderInfo.userid.intValue){
            [MyUtil showCleanMessage:@"不能参加自己的组局！"];
            return;
        }
        
        double payamout;
        if ([orderInfo.pinkerType isEqualToString:@"0"]) {
            //发起人请客
            payamout = 0 ;
        }else if([orderInfo.pinkerType isEqualToString:@"1"]){
            //AA付款
            if ([_chooseNumber.numberField.text intValue] == store) {
                [self configureRestMoney];
                payamout = allMoney;
            }else{
                payamout = allMoney / [orderInfo.allnum intValue];
                payamout = payamout * [_chooseNumber.numberField.text intValue];
            }
        }else if ([orderInfo.pinkerType isEqualToString:@"2"]){
            //发起人自由付款，其他人AA
            if ([_chooseNumber.numberField.text intValue] == store) {
                [self configureRestMoney];
                payamout = allMoney;
            }else{
                for (YUPinkerListModel *userModel in orderInfo.pinkerList) {
                    if ([userModel.inmember isEqualToString:orderInfo.userid]) {//检索到发起人
                        payamout = (allMoney - [userModel.price doubleValue]) / ([orderInfo.allnum intValue] - 1);
                        payamout = payamout * [_chooseNumber.numberField.text intValue];
                        break;
                    }
                }
            }
        }
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",_YUModel.orderInfo.id],
                              @"payamount":[NSString stringWithFormat:@"%.2f",payamout],
                              @"allnum":_chooseNumber.numberField.text};
        __weak __typeof(self) weakSelf = self;
        [[LYHomePageHttpTool shareInstance]inTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(payamout == 0.0){
                LPMyOrdersViewController *detailVC = [[LPMyOrdersViewController alloc]init];
//                LYMyOrderManageViewController *detailVC = [[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }else{
                ChoosePayController *detailVC = [[ChoosePayController alloc]init];
                detailVC.orderNo = result;
                NSString *payStr = [NSString stringWithFormat:@"%.2f",payamout];
                detailVC.payAmount = payStr.doubleValue;
                detailVC.productName = pinkeModel.smname;
                detailVC.createDate=[NSDate date];
                detailVC.isPinker=YES;
                detailVC.isFaqi=NO;
                detailVC.productDescription = @"暂无";
                [MyUtil showMessage:@"请在五分钟之内完成支付，否则订单将自动取消！"];
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:weakSelf action:nil];
                weakSelf.navigationItem.backBarButtonItem = left;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }
        }];
    }
}

#pragma mark - 计算还需要多少钱
- (void)configureRestMoney{
    NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (int i = 0 ; i < orderInfo.pinkerList.count ; i ++) {
        listModel = [orderInfo.pinkerList objectAtIndex:i];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:listModel.price];
        money = [money decimalNumberByAdding:num];
    }
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",allMoney]];
    one = [one decimalNumberBySubtracting:money];
    NSLog(@"%f",[one doubleValue]);
    allMoney = [one doubleValue];
}

- (void)checkAddress{
    NSDictionary *dic=@{@"title":orderInfo.barinfo.barname,@"latitude":orderInfo.barinfo.latitude,@"longitude":orderInfo.barinfo.longitude};
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"活动详情",@"titleName":@"地图"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    [[LYUserLocation instance] daoHan:dic];
}

- (void)checkBar{
    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
    controller.beerBarId = [NSNumber numberWithInt:orderInfo.barinfo.id];
    [self.navigationController pushViewController:controller animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动详情" titleName:orderInfo.barinfo.barname]];
}

- (void)CheckMyMessage{
    [self HDDetailJumpToFriendDetail:orderInfo.userid];
}

- (void)gotoUserPage:(UIButton *)button{
        NSInteger index = button.tag;
//    NSInteger index = tap.view.tag;
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"活动详情",@"titleName":@"个人主页",@"value":((YUPinkerListModel *)[orderInfo.pinkerList objectAtIndex:index]).inmember};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self HDDetailJumpToFriendDetail:((YUPinkerListModel *)[orderInfo.pinkerList objectAtIndex:index]).inmember];
}


- (void)HDDetailJumpToFriendDetail:(NSString *)friendId{
    
    LYMyFriendDetailViewController *myFriendDetailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendDetailVC.userID = friendId;
    [self.navigationController pushViewController:myFriendDetailVC animated:YES];
}

- (void)clickThisImageView{
    UIView *bigView = [[UIView alloc]initWithFrame:self.view.bounds];
    bigView.backgroundColor = RGBA(0, 0, 0, 0.3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigView:)];
    [bigView addGestureRecognizer:tap];
    
    DetailView *detailView = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:nil options:nil]firstObject];
    detailView.frame = CGRectMake(8, 64, SCREEN_WIDTH - 16, 268 + SCREEN_WIDTH / 3);
    detailView.delegate = self;
    NSDictionary *dic=@{@"smid":pinkeModel.id};
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        NSLog(@"%@",result);
        [detailView setTcModel:result];
        [detailView Configure];
    }];
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"活动详情",@"titleName":@"查看套餐详情",@"value":pinkeModel.id};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self.view addSubview:bigView];
    [bigView addSubview:detailView];
}

- (void)hideBigView:(UITapGestureRecognizer *)gesture{
    [gesture.view removeFromSuperview];
}

- (void)showImageInPreview:(UIImage *)image{
//    [self.navigationController.navigationBar setHidden:YES];
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(previewHide)];
    [_subView addGestureRecognizer:tap];
    _subView.image = image;
    [_subView viewConfigure];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_subView];
    
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"活动详情",@"titleName":@"预览套餐图片",@"value":pinkeModel.id};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)previewHide{
//    [self.navigationController.navigationBar setHidden:NO];
    [_subView removeFromSuperview];
}

@end
