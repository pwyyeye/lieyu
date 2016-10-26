//
//  LPMyOrdersViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPMyOrdersViewController.h"
#import "LPOrderButton.h"
#import "LYUserHttpTool.h"
#import "OrderInfoModel.h"
#import "PinkInfoModel.h"
#import "ChoosePayController.h"
#import "LYEvaluationController.h"
#import "PinkerShareController.h"
#import "UMSocial.h"

#import "LPOrdersHeaderCell.h"
#import "LPOrdersBodyCell.h"
#import "LPOrdersFooterCell.h"
#import "LPOrdersHeaderView.h"
#import "LYOrderDetailViewController.h"
#import "MainTabbarViewController.h"

@interface LPMyOrdersViewController ()<LPOrdersFootDelegate,UMSocialUIDelegate>
{
    UIVisualEffectView *effectView;
    NSArray *titleArray;
    
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
    NSMutableArray *dataList;
    
    UILabel *kongLabel;
    UIButton *kongButton;
    OrderTTL *_orderTTL;
    OrderInfoModel *_shareOrderInfoModel;
}
@end

@implementation LPMyOrdersViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isFreeOrdersList) {
        titleArray = @[@"所有订单",@"待确认",@"待评价",@"已评价"];
    }else{
        titleArray = @[@"订单",@"待付款",@"待消费",@"待评价",@"待返利",@"待退款"];
    }
    arrayButton = [NSMutableArray array];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    [myTableView setContentOffset:CGPointMake(0, 90)];
    [myTableView setContentInset:UIEdgeInsetsMake(90, 0, 0, 0)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    
//    [self.view setBackgroundColor:[UIColor greenColor]];
    perCount = 10;
    dataList = [NSMutableArray array];
    
    
    [self initHeader];
    //
    [self changeTableViewAtIndex:_orderIndex];
    
    [self getData];
    [self registerCells];
}

#pragma mark - registerCells
- (void)registerCells{
//    [myTableView registerNib:[UINib nibWithNibName:@"LPOrdersHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPOrdersHeaderCell"];
    [myTableView registerNib:[UINib nibWithNibName:@"LPOrdersBodyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPOrdersBodyCell"];
    [myTableView registerNib:[UINib nibWithNibName:@"LPOrdersFooterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPOrdersFooterCell"];
//    [myTableView registerNib:[UINib nibWithNibName:@"LPOrderHeaderCell" bundle:nil] forCellReuseIdentifier:@"LPOrderHeaderCell"];
}

#pragma mark - 获取数据
- (void)getData{
    __weak LPMyOrdersViewController *weakSelf = self;
    myTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        [weakSelf getOrderWithDic:nowDic];
        [weakSelf refreshData];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)myTableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    myTableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)myTableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

#pragma mark - 顶部导航栏
- (void)initHeader{
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [effectView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    effectView.alpha = 5;
    effectView.layer.shadowColor = [RGBA(0, 0, 0, 1)CGColor];
    effectView.layer.shadowOffset = CGSizeMake(0, 0.5);
    if (![MyUtil isMoreThaniOSTen]) {
        effectView.layer.shadowOpacity = 0.3;
    }
    effectView.layer.shadowRadius = 1;
    [self.view addSubview:effectView];
    
    //title
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 31, SCREEN_WIDTH - 200, 22)];
    [label setFont:[UIFont systemFontOfSize:18]];
    if (_isFreeOrdersList) {
        [label setText:@"免费订台"];
    }else{
        [label setText:@"订单中心"];
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [effectView addSubview:label];
    
    //几个分类按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-5, 25, 60, 34)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    [effectView addSubview:button];
    
    int buttonWidth ;
    if (_isFreeOrdersList) {
        buttonWidth = SCREEN_WIDTH / 4;
    }else{
        buttonWidth = 70;
    }
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 26)];
    [scrollView setContentSize:CGSizeMake(buttonWidth * titleArray.count, 26)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [effectView addSubview:scrollView];
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        LPOrderButton *button = [[LPOrderButton alloc]initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, 26)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        button.tag = i ;
        [button addTarget:self action:@selector(changeTableViewAtButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
//        if (self.bagesArr.count == 6) {
//            if ([[self.bagesArr objectAtIndex:i] isEqualToString:@"0"]) {
//                [button.pointLabel setHidden:YES];
//            }else{
//                [button.pointLabel setHidden:NO];
//            }
//        }
        [scrollView addSubview:button];
        [arrayButton addObject:button];
    }
}

#pragma mark - 点击按钮后
- (void)changeTableViewAtButton:(LPOrderButton *)button{
    _orderIndex = (int)button.tag;
    [self changeTableViewAtIndex:_orderIndex];
}

#pragma mark - 根据按钮tag获取对应数据
- (void)changeTableViewAtIndex:(int)newTag{
    for (LPOrderButton *btn in arrayButton) {
//        NSLog(@"%ld--%d",btn.tag,newTag);
        if (btn.tag == newTag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if (newTag <= 2) {
        [UIView animateWithDuration:0.5 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }else if (newTag >= 3){
        [UIView animateWithDuration:0.5 animations:^{
            [scrollView setContentOffset:CGPointMake(420 - SCREEN_WIDTH, 0)];
        }];
    }
    switch (newTag) {
        case 0:
            [self getAllOrder];
            break;
        case 1:
            [self getDaiFuKuan];
            break;
        case 2:
            [self getDaiXiaoFei];
            break;
        case 3:
            [self getDaiPingJia];
            break;
        case 4:
            [self getDaiFanLi];
            break;
        case 5:
            [self getDaiTuiKuan];
            break;
        default:
            break;
    }
}

#pragma mark - 获取全部数据
- (void)getAllOrder{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount]};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

#pragma mark - 获取待付款数据
- (void)getDaiFuKuan{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount],
                          @"orderStatus":@"0"};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

#pragma mark - 获取待消费数据
- (void)getDaiXiaoFei{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount],
                          @"orderStatus":@"1,2"};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

#pragma mark - 获取待评价数据
- (void)getDaiPingJia{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount],
                          @"orderStatus":@"8"};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

#pragma mark - 获取待返利数据
- (void)getDaiFanLi{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount],
                          @"orderStatus":@"7,9"};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

#pragma mark - 获取待退款数据
- (void)getDaiTuiKuan{
    pageCount = 1;
    NSDictionary *dic = @{@"p":[NSNumber numberWithInt:pageCount],
                          @"per":[NSNumber numberWithInt:perCount],
                          @"orderStatus":@"3,4,5,10"};
    nowDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
}

- (void)getOrderWithDic:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyOrderListWithParams:dic block:^(NSMutableArray *result) {
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (![MyUtil isEmptyString:app.s_app_id]) {
            [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
                _orderTTL=result;
                [weakSelf loadBadge:_orderTTL];
            }];
        }
        
        [dataList removeAllObjects];
        [dataList addObjectsFromArray:result];
        if (dataList.count > 0 ) {
            [weakSelf hideKongView];
            pageCount ++;
            [myTableView.mj_footer endRefreshing];
            ///////////////////
        }else{
            [weakSelf addKongView];
             [myTableView.mj_footer endRefreshingWithNoMoreData];
        }
        myTableView.contentOffset = CGPointMake(0, -90);
        [myTableView reloadData];
    }];
    [myTableView.mj_header endRefreshing];
    
}

#pragma mark - 角标
- (void)loadBadge:(OrderTTL *)orderTTL{
    _bagesArr = [[NSMutableArray alloc]init];
    [_bagesArr addObject:@"0"];
    [_bagesArr addObject:orderTTL.waitPay > 0 ? @"1" : @"0"];
    [_bagesArr addObject:orderTTL.waitConsumption > 0 ? @"1" : @"0"];
    [_bagesArr addObject:orderTTL.waitEvaluation > 0 ? @"1" : @"0"];
    [_bagesArr addObject:orderTTL.waitRebate > 0 ? @"1" : @"0"];
    [_bagesArr addObject:orderTTL.waitPayBack > 0 ? @"1" : @"0"];
    for (int i = 0 ; i < 6; i ++) {
        if (self.bagesArr.count == 6) {
            if ([[self.bagesArr objectAtIndex:i] isEqualToString:@"0"]) {
                [((LPOrderButton *)[arrayButton objectAtIndex:i]).pointLabel setHidden:YES];
            }else{
                [((LPOrderButton *)[arrayButton objectAtIndex:i]).pointLabel setHidden:NO];
            }
        }
    }
}

#pragma mark - 刷新数据
- (void)refreshData{
    pageCount = 1;
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [self getOrderWithDic:nowDic];
}

#pragma mark - 刷新表
- (void)refreshTableView{
    [self refreshData];
}

- (void)loadMoreData{
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [self getOrderWithDicMore:nowDic];
}

#pragma mark － 获取更多数据
- (void)getOrderWithDicMore:(NSDictionary *)dic{
//    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyOrderListWithParams:dic block:^(NSMutableArray *result) {
        if (result.count > 0) {
            [dataList addObjectsFromArray:result];
            pageCount ++;
            [myTableView reloadData];
        }else{
            [myTableView.mj_footer noticeNoMoreData];
        }
    }];
    [myTableView.mj_footer endRefreshing];
}

#pragma mark - 空数据界面
- (void)addKongView{
//    [myTableView setHidden:YES];
    if (![self.view viewWithTag:501]) {
        kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 50, 200, 20)];
        [kongLabel setBackgroundColor:[UIColor clearColor]];
        [kongLabel setTextColor:COMMON_PURPLE];
        [kongLabel setTextAlignment:NSTextAlignmentCenter];
        [kongLabel setText:@"暂无订单"];
        [kongLabel setFont:[UIFont systemFontOfSize:12]];
        kongLabel.tag = 501;
        [self.view addSubview:kongLabel];
    }
    if (![self.view viewWithTag:502]) {
        kongButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT / 2 - 15, 120, 35)];
        [kongButton setBackgroundColor:COMMON_PURPLE];
        [kongButton setTitle:@"约约去" forState:UIControlStateNormal];
        [kongButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        kongButton.layer.cornerRadius = 4;
        kongButton.tag = 502;
        [kongButton addTarget:self action:@selector(jumpToYue) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:kongButton];
    }
}

- (void)hideKongView{
    if ([self.view viewWithTag:502]) {
        [kongButton removeFromSuperview];
    }
    if ([self.view viewWithTag:501]) {
        [kongLabel removeFromSuperview];
    }
    [myTableView setHidden:NO];
}

#pragma mark - 约约去
- (void)jumpToYue{
//    NSLog(@"dsafds");
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToFirstViewController" object:nil];
     BOOL shanghuban = [[NSUserDefaults standardUserDefaults] boolForKey:@"shanghuban"];
    if (shanghuban) {
        [MyUtil showMessage:@"请先切换到用户版"];
        return;
    }
    MainTabbarViewController *tabBarVC = (MainTabbarViewController *)self.navigationController.viewControllers.firstObject;
//    NSLog(@"--->%@",self.navigationController.viewControllers.firstObject);
    tabBarVC.selectedIndex = 0;
    [self.navigationController popToViewController:tabBarVC animated:YES];
    
}

#pragma mark - 返回事件
- (void)backForward{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChoosePayController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        if ([controller isKindOfClass:[PinkerShareController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderInfoModel *model = [dataList objectAtIndex:section];
    if (model.ordertype != 2) {
        return 1;
    }else{
        return model.goodslist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPOrdersBodyCell *bodyCell = [myTableView dequeueReusableCellWithIdentifier:@"LPOrdersBodyCell" forIndexPath:indexPath];
    bodyCell.tag = indexPath.row;
    bodyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderInfoModel *model = [dataList objectAtIndex:indexPath.section];
    bodyCell.model = model;
    return bodyCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderInfoModel *model = [dataList objectAtIndex:section];
    LPOrdersHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"LPOrdersHeaderView" owner:nil options:nil]firstObject];
    headerView.model = model;
//    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderInfoModel *model = [dataList objectAtIndex:section];
    LPOrdersFooterCell *footerCell = [myTableView dequeueReusableCellWithIdentifier:@"LPOrdersFooterCell"];
    footerCell.delegate = self;
    footerCell.tag = section;
    footerCell.model = model;
    return footerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoModel *orderInfoModel= dataList[indexPath.section];
    LPOrderDetailViewController *detailViewController = [[LPOrderDetailViewController alloc]init];
    detailViewController.title = @"订单详情";
    detailViewController.delegate = self;
    detailViewController.orderInfoModel = orderInfoModel;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
//    LYOrderDetailViewController *orderDetailViewController=[[LYOrderDetailViewController alloc]init];
//    orderDetailViewController.title=@"订单详情";
//    orderDetailViewController.delegate=self;
//    orderDetailViewController.orderInfoModel=orderInfoModel;
//    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 102;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 各按钮事件
//删除自己的订单
- (void)deleteOrder:(UIButton *)button{
    OrderInfoModel *orderInfoModel = [dataList objectAtIndex:button.tag];
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确定要删除订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            NSDictionary *dict = @{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
            [[LYUserHttpTool shareInstance]delMyOrder:dict complete:^(BOOL result) {
                if (result) {
                    [MyUtil showLikePlaceMessage:@"删除成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadUserInfo" object:nil];
                    if (orderInfoModel.ordertype == 1) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"YunoticeToReload" object:nil];
                    }
                    [weakSelf refreshData];
                }
            }];
        }
    }];
    [alert show];
}

//支付
- (void)payForOrder:(UIButton *)button{
    OrderInfoModel *orderInfoModel = dataList[button.tag];
    ChoosePayController *detailViewController = [[ChoosePayController alloc]init];
    detailViewController.orderNo = orderInfoModel.sn;
    detailViewController.payAmount = orderInfoModel.amountPay.doubleValue;
    detailViewController.productName = orderInfoModel.fullname;
    detailViewController.productDescription = @"暂无";
    //如果是拼客，特殊处理
    if (orderInfoModel.ordertype == 1) {
        if (orderInfoModel.pinkerList.count > 0) {
            for (NSDictionary *dic  in orderInfoModel.pinkerList) {
                PinkInfoModel *pinkeInfoModel = [PinkInfoModel mj_objectWithKeyValues:dic];
                if (pinkeInfoModel.inmember == self.userModel.userid) {
                    detailViewController.orderNo = pinkeInfoModel.sn;
                    detailViewController.payAmount = pinkeInfoModel.price.doubleValue;
                    detailViewController.isPinker = YES;
                    detailViewController.createDate = [MyUtil getFullDateFromString:pinkeInfoModel.createDate];
                    if (pinkeInfoModel.inmember == orderInfoModel.userid) {
                        detailViewController.isFaqi = YES;
                    }else{
                        detailViewController.isFaqi = NO;
                    }
                }
            }
        }
    }
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = left;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//查看详情
- (void)checkForDetail:(UIButton *)button{
//    NSLog(@"checkForDetail");
    OrderInfoModel *orderInfoModel= dataList[button.tag];
    LPOrderDetailViewController *detailViewController = [[LPOrderDetailViewController alloc]init];
    detailViewController.title = @"订单详情";
    detailViewController.delegate = self;
    detailViewController.orderInfoModel = orderInfoModel;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//取消订单
- (void)cancelOrder:(UIButton *)button{
//    NSLog(@"cancelOrder");
    OrderInfoModel *orderInfoModel= dataList[button.tag];
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确定要取消订单吗" cancelButtonTitle:@"取消" otherButtonTitles:@"确认" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            NSDictionary *dic = @{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
            [[LYUserHttpTool shareInstance]cancelMyOrder:dic complete:^(BOOL result) {
                if (result) {
                    [MyUtil showLikePlaceMessage:@"取消订单成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadUserInfo" object:nil];
                    [weakSelf refreshData];
                }
            }];
        }
    }];
    [alert show];
}

//评价
- (void)JudgeForOrder:(UIButton *)button{
    OrderInfoModel *orderInfoModel = dataList[button.tag];
    LYEvaluationController *eva = [[LYEvaluationController alloc]initWithNibName:@"LYEvaluationController" bundle:nil];
    eva.orderInfoModel = orderInfoModel;
    [self.navigationController pushViewController:eva animated:YES];
}

//立即组局
- (void)shareZujuOrder:(UIButton *)button{
//    NSLog(@"shareZujuOrder");
    OrderInfoModel *orderInfoModel = dataList[button.tag];
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"选择分享平台" message:@"" cancelButtonTitle:@"分享到娱" otherButtonTitles:@"其他平台" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到娱"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            PinkerShareController *zujuVC = [[PinkerShareController alloc]initWithNibName:@"PinkerShareController" bundle:nil];
            zujuVC.orderid=orderInfoModel.id;
            [weakSelf.navigationController pushViewController:zujuVC animated:YES];
        }else if (buttonIndex == 1){
            _shareOrderInfoModel = orderInfoModel;
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到其他平台"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            //http://121.40.229.133:8001/lieyu/inPinkerWebAction.do?id=77
            NSString *ss=[NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩～",weakSelf.userModel.usernick,orderInfoModel.barinfo.barname];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,orderInfoModel.id];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,orderInfoModel.id];
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = ss;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = ss;
            @try {
                [UMSocialSnsService presentSnsIconSheetView:weakSelf
                                                     appKey:UmengAppkey
                                                  shareText:@"精彩活动，尽在猎娱！"
                                                 shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderInfoModel.pinkerinfo.linkUrl]]]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil]
                                                   delegate:self];
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

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if (platformName == UMShareToSina || platformName == UMShareToSms) {
        if (_shareOrderInfoModel) {
            socialData.shareText = [NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩～%@inPinkerWebAction.do?id=%d",self.userModel.usernick,_shareOrderInfoModel.barinfo.barname,LY_SERVER,_shareOrderInfoModel.id];
        }else{
            socialData.shareText = [NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩～http://www.lie98.com",self.userModel.usernick,_shareOrderInfoModel.barinfo.barname];
        }
    }
}

//删除参与的订单
- (void)deleteSelfOrder:(UIButton *)button{
    OrderInfoModel *orderInfoModel = [dataList objectAtIndex:button.tag];
    __weak __typeof(self)weakSelf = self;
    NSArray *pinkerList = [PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
    int orderID = 0 ;
    if (pinkerList.count > 0) {
        for (PinkInfoModel *pinkInfoModel in pinkerList) {
            if (pinkInfoModel.inmember == self.userModel.userid) {
                orderID = pinkInfoModel.id;
            }
        }
    }
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确定要确认删除吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确认" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            NSDictionary *dic = @{@"id":[NSNumber numberWithInt:orderID]};
            [[LYUserHttpTool shareInstance]delMyOrderByCanYu:dic complete:^(BOOL result) {
                [MyUtil showLikePlaceMessage:@"删除成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadUserInfo" object:nil];
                [weakSelf refreshData];
            }];
        }
    }];
    [alert show];
}

@end
