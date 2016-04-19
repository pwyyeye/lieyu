//
//  LPOrderDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrderDetailViewController.h"
#import "LPOrdersHeaderView.h"
#import "LPOrdersBodyCell.h"
#import "LPOrdersFooterCell.h"
#import "DetailUserInfoCell.h"
#import "DetailPlaceTimeCell.h"
#import "DetailLabelView.h"
#import "LYUserHttpTool.h"
#import "ChoosePayController.h"
#import "MJExtension.h"
#import "LYEvaluationController.h"
#import "PinkerShareController.h"
#import "UMSocial.h"
#import "IQKeyboardManager.h"


@interface LPOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    RCPublicServiceChatViewController *_conversationVC;
}
@end

@implementation LPOrderDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCells];
    [self initBottomView];
}

- (void)registerCells{
    [self.myTableView registerNib:[UINib nibWithNibName:@"LPOrdersBodyCell" bundle:nil] forCellReuseIdentifier:@"LPOrdersBodyCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"LPOrdersFooterCell" bundle:nil] forCellReuseIdentifier:@"LPOrdersFooterCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailUserInfoCell" bundle:nil] forCellReuseIdentifier:@"DetailUserInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailPlaceTimeCell" bundle:nil] forCellReuseIdentifier:@"DetailPlaceTimeCell"];
}

- (void)initBottomView{
    if (self.orderInfoModel.orderStatus == 2 || self.orderInfoModel.orderStatus == 1) {
        //待消费
        self.consumerCodeLbl.hidden = NO;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *consumer = [MyUtil decryptUseDES:self.orderInfoModel.consumptionCode withKey:app.desKey];
        [self.consumerCodeLbl setText:[NSString stringWithFormat:@"消费码：%@",consumer]];
    }else{
        self.consumerCodeLbl.hidden = YES;
    }
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
    if (self.orderInfoModel.orderStatus == 0) {
        //
        _firstButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        _firstButton.layer.borderWidth = 0.5;
        [_firstButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _secondButton.layer.borderWidth = 0 ;
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        if (self.orderInfoModel.ordertype == 1) {
            //组局
            if(self.orderInfoModel.userid == self.userModel.userid){
                //我发起
                BOOL isPay = NO;
                for (NSDictionary *dic in self.orderInfoModel.pinkerList) {
                    if ([[dic objectForKey:@"inmember"]intValue] == self.userModel.userid &&
                        [[dic objectForKey:@"paymentStatus"]intValue] == 1) {
                        isPay = YES;
                    }
                }
                if (isPay == YES) {//我付过钱
                    if (self.orderInfoModel.pinkerType == 2) {//免费发起
                        int payCount = 0 ;
                        for(NSDictionary *dic in self.orderInfoModel.pinkerList){
                            if ([[dic objectForKey:@"inmember"]intValue] != self.userModel.userid &&
                                [[dic objectForKey:@"paymentStatus"]intValue] == 1) {
                                payCount ++;
                            }
                        }
                        if (payCount >= 1) {
                            [_firstButton setTitle:@"取消组局" forState:UIControlStateNormal];
                            [_firstButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            [_firstButton setTitle:@"删除组局" forState:UIControlStateNormal];
                            [_firstButton addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }else{//不是免费发起
                        [_firstButton setTitle:@"取消组局" forState:UIControlStateNormal];
                        [_firstButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    [_secondButton setTitle:@"立即组局" forState:UIControlStateNormal];
                    [_secondButton addTarget:self action:@selector(shareOrder:) forControlEvents:UIControlEventTouchUpInside];
                }else{//我没付钱
                    [_firstButton setTitle:@"删除组局" forState:UIControlStateNormal];
                    [_firstButton addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                    [_secondButton setTitle:@"立即付款" forState:UIControlStateNormal];
                    [_secondButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else{//我是参与者
                BOOL isPayed = NO;
                for (NSDictionary *dict in self.orderInfoModel.pinkerList) {
                    if ([[dict objectForKey:@"inmember"]intValue] == self.userModel.userid && [[dict objectForKey:@"paymentStatus"] intValue] == 1) {
                        isPayed = YES;
                    }
                }
                if (isPayed == YES) {
                    _firstButton.hidden = YES;
                    [_secondButton setTitle:@"等待通知" forState:UIControlStateNormal];
                }else{
                    //未付款
                    [_firstButton setTitle:@"退出组局" forState:UIControlStateNormal];
                    [_firstButton addTarget:self action:@selector(deleteJoinedOrder:) forControlEvents:UIControlEventTouchUpInside];
                    [_secondButton setTitle:@"立即支付" forState:UIControlStateNormal];
                    [_secondButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{//不是组局
            [_firstButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_firstButton addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
            [_secondButton setTitle:@"立即付款" forState:UIControlStateNormal];
            [_secondButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (self.orderInfoModel.orderStatus == 1 ||
              self.orderInfoModel.orderStatus == 2){
        //待消费
        _firstButton.hidden = YES;
        _secondButton.layer.borderColor = [RGBA(128, 128, 128, 1) CGColor];
        _secondButton.layer.borderWidth = 0.5;
        [_secondButton setBackgroundColor:[UIColor whiteColor]];
        [_secondButton setTitleColor:RGBA(128, 128, 128, 1) forState:UIControlStateNormal];
        if(self.orderInfoModel.ordertype == 1){
            if (self.userModel.userid == self.orderInfoModel.userid) {
                [_secondButton setTitle:@"取消组局" forState:UIControlStateNormal];
                [_secondButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                _secondButton.hidden = YES;
            }
        }else{
            [_secondButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_secondButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (self.orderInfoModel.orderStatus == 8){
        //待评价
        _firstButton.hidden = YES;
        _secondButton.layer.borderWidth = 0 ;
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        [_secondButton setTitle:@"立即评价" forState:UIControlStateNormal];
        [_secondButton addTarget:self action:@selector(judgeOrder:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _firstButton.hidden = YES;
        _secondButton.layer.borderWidth = 0 ;
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        [_secondButton setTitle:@"咨询猎娱" forState:UIControlStateNormal];
        [_secondButton addTarget:self action:@selector(messageHurtingFun:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 表格中代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderInfoModel.ordertype == 1) {
        if (self.orderInfoModel.userid == self.userModel.userid) {
            return 4;
        }else{
            return 3;
        }
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.orderInfoModel.pinkerList.count;
    }else if(section == 0){
        if (self.orderInfoModel.ordertype == 2) {
            return self.orderInfoModel.goodslist.count;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LPOrdersBodyCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"LPOrdersBodyCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderInfoModel;
        return cell;
    }else if (indexPath.section == 1){
        DetailPlaceTimeCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailPlaceTimeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderInfoModel = self.orderInfoModel;
        return cell;
    }else if (indexPath.section == 2){
        DetailUserInfoCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailUserInfoCell" forIndexPath:indexPath];
        cell.phoneBtn.tag = indexPath.section * 10000 + indexPath.row;
        cell.messageBtn.tag = indexPath.section * 10000 + indexPath.row;
        [cell.phoneBtn addTarget:self action:@selector(callUser:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageBtn addTarget:self action:@selector(messageUser:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureManagerCell:self.orderInfoModel];
        return cell;
    }else{
        DetailUserInfoCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailUserInfoCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.phoneBtn.tag = indexPath.section * 10000 + indexPath.row;
        cell.messageBtn.tag = indexPath.section * 10000 + indexPath.row;
        [cell.phoneBtn addTarget:self action:@selector(callUser:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageBtn addTarget:self action:@selector(messageUser:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureFriendsCell:self.orderInfoModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 76;
    }else if (indexPath.section == 1){
        return 56;
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        LPOrdersHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"LPOrdersHeaderView" owner:nil options:nil]firstObject];
        headerView.model = self.orderInfoModel;
        return headerView;
    }else if(section == 2){
        DetailLabelView *labelView = [[[NSBundle mainBundle]loadNibNamed:@"DetailLabelView" owner:nil options:nil]firstObject];
        if (self.orderInfoModel.ordertype == 1 && self.orderInfoModel.userid != self.userModel.userid) {
            //拼客并且我不是发起人
            [labelView configureManager:NO];
        }else{
            [labelView configureManager:YES];
        }
        return labelView;
    }else if (section == 3){
        DetailLabelView *labelView = [[[NSBundle mainBundle]loadNibNamed:@"DetailLabelView" owner:nil options:nil]firstObject];
        [labelView configureNumber:self.orderInfoModel.pinkerCount];
        return labelView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 58;
    }else if (section == 2){
        return 26;
    }else if (section == 3){
        return 26;
    }else{
        return 0.000001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        LPOrdersFooterCell *footerView = [[[NSBundle mainBundle]loadNibNamed:@"LPOrdersFooterCell" owner:nil options:nil]firstObject];
        footerView.detail = YES;
        footerView.model = self.orderInfoModel;
        return footerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }else{
        return 0.000001;
    }
}

#pragma mark - 列表中联系方式
- (void)callUser:(UIButton *)button{
    int section = (int)button.tag / 10000;
    int row = (int)button.tag % 10000;
    DetailUserInfoCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    
//    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if( [MyUtil isPureInt:_orderInfoModel.checkUserMobile]){
        //        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_orderInfoModel.phone];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",cell.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
    
//    NSLog(@"%@",cell.mobile);
}

- (void)messageUser:(UIButton *)button{
    int section = (int)button.tag / 10000;
    int row = (int)button.tag % 10000;
    DetailUserInfoCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = cell.imuserId; // 接收者的 targetId，这里为举例。
//    conversationVC.userName =cell.username; // 接受者的 username，这里为举例。
    conversationVC.title =cell.username; // 会话的 title。
    
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    // 把单聊视图控制器添加到导航栈。
    //            [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    //            [self.navigationController pushViewController:conversationVC animated:YES];
    
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
//    //    [view addSubview:backButton];
//    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    conversationVC.navigationItem.leftBarButtonItem = item;
    
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    conversationVC.navigationItem.leftBarButtonItem = item;
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
//    conversationVC.navigationItem.leftBarButtonItem = backItem;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - 底部按钮
- (void)deleteOrder:(UIButton *)button{
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:_orderInfoModel.id]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要删除订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]delMyOrder:dic complete:^(BOOL result) {
                if(result){
                    //WTT
                    [self.delegate refreshTableView];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    [alert show];
}

- (void)deleteJoinedOrder:(UIButton *)button{
    NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
    int orderid=0;
    if(pinkerList.count>0){
        for (PinkInfoModel *pinkInfoModel in pinkerList) {
            if(pinkInfoModel.inmember==self.userModel.userid){
                
                orderid=pinkInfoModel.id;
            }
        }
    }
    
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderid]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]delMyOrderByCanYu:dic complete:^(BOOL result) {
                if(result){
                    //WTT
                    [self.delegate refreshTableView];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    [alert show];
}

- (void)cancelOrder:(UIButton *)button{
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:_orderInfoModel.id]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要取消订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]cancelMyOrder:dic complete:^(BOOL result) {
                if(result){
                    //刷新
                    [self.delegate refreshTableView];
                    [self.navigationController popViewControllerAnimated:YES];
                    //            [weakSelf refreshData];
                }
            }];
            
        }
    }];
    [alert show];
}

- (void)payOrder:(UIButton *)button{
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    detailViewController.orderNo=_orderInfoModel.sn;
    detailViewController.payAmount=_orderInfoModel.amountPay.doubleValue;
    detailViewController.productName=_orderInfoModel.fullname;
    detailViewController.productDescription=@"暂无";
    //如果是拼客 特殊处理
    if(_orderInfoModel.ordertype==1){
        if(_orderInfoModel.pinkerList.count>0){
            for (NSDictionary *dic in _orderInfoModel.pinkerList) {
                PinkInfoModel *pinkInfoModel =[PinkInfoModel mj_objectWithKeyValues:dic];
                if(pinkInfoModel.inmember==self.userModel.userid){
                    detailViewController.orderNo=pinkInfoModel.sn;
                    detailViewController.payAmount=pinkInfoModel.price.doubleValue;
                    detailViewController.isPinker=YES;
                    detailViewController.createDate=[MyUtil getFullDateFromString:pinkInfoModel.createDate];
                    if (pinkInfoModel.inmember==_orderInfoModel.userid) {
                        detailViewController.isFaqi=YES;
                    }else{
                        detailViewController.isFaqi=NO;
                    }
                    
                }
            }
        }
    }
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = left;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)judgeOrder:(UIButton *)button{
    LYEvaluationController *eva=[[LYEvaluationController alloc] initWithNibName:@"LYEvaluationController" bundle:nil];
    eva.orderInfoModel = self.orderInfoModel;
    [self.navigationController pushViewController:eva animated:YES];
}

- (void)shareOrder:(UIButton *)button{
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"选择分享平台" message:@"" cancelButtonTitle:@"分享到娱" otherButtonTitles:@"其他平台" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到娱"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            PinkerShareController *zujuVC = [[PinkerShareController alloc]initWithNibName:@"PinkerShareController" bundle:nil];
            zujuVC.orderid=_orderInfoModel.id;
            [weakSelf.navigationController pushViewController:zujuVC animated:YES];
        }else if (buttonIndex == 1){
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到其他平台"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            //http://121.40.229.133:8001/lieyu/inPinkerWebAction.do?id=77
            NSString *ss=[NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩～",weakSelf.userModel.usernick,_orderInfoModel.barinfo.barname];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,_orderInfoModel.id];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,_orderInfoModel.id];
            @try {
                [UMSocialSnsService presentSnsIconSheetView:weakSelf
                                                     appKey:UmengAppkey
                                                  shareText:ss
                                                 shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_orderInfoModel.pinkerinfo.linkUrl]]]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                                   delegate:nil];
            }
            @catch (NSException *exception) {
                [MyUtil showCleanMessage:@"无法分享！"];
            }
            @finally {
                
            }
        }
        
    }];
    [alert show];
}

- (void)messageHurtingFun:(UIButton *)button{
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"吃喝明细",@"titleName":@"客服"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    _conversationVC = [[RCPublicServiceChatViewController alloc] init];
    _conversationVC.conversationType = ConversationType_APPSERVICE;;
    _conversationVC.targetId = @"KEFU144946169476221";
    [_conversationVC.navigationController.navigationBar setHidden:NO];
//    _conversationVC.userName = @"猎娱客服";
    _conversationVC.title = @"猎娱客服";
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
////    [view addSubview:backButton];
//    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    _conversationVC.navigationItem.leftBarButtonItem = item;
    
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    _conversationVC.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

- (void)backBtnClick{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
