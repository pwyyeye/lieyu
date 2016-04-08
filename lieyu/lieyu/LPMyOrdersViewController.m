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

@interface LPMyOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIVisualEffectView *effectView;
    UIScrollView *scrollView;
    NSMutableArray *arrayButton;
    NSArray *titleArray;
    UITableView *myTableView;
    
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
    NSMutableArray *dataList;
    
    UILabel *kongLabel;
    UIButton *kongButton;
}
@end

@implementation LPMyOrdersViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@"订单",@"待付款",@"待消费",@"待评价",@"待返利",@"待退款"];
    arrayButton = [NSMutableArray array];
    [self initHeader];
    
    perCount = 10;
    dataList = [NSMutableArray array];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 90) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self changeTableViewAtIndex:_orderIndex];
    [self getData];
}

- (void)getData{
    __weak LPMyOrdersViewController *weakSelf = self;
    myTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getOrderWithDic:nowDic];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)myTableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    myTableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getOrderWithDicMore:nowDic];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)myTableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)initHeader{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [effectView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    effectView.layer.shadowColor = [RGBA(0, 0, 0, 1)CGColor];
    effectView.layer.shadowOffset = CGSizeMake(0, 0.5);
    effectView.layer.shadowOpacity = 0.3;
    effectView.layer.shadowRadius = 1;
    [self.view addSubview:effectView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 31, SCREEN_WIDTH - 200, 22)];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setText:@"订单中心"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [effectView addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 25, 60, 34)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    [effectView addSubview:button];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 26)];
    [scrollView setContentSize:CGSizeMake(420, 36)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [effectView addSubview:scrollView];
    
    for (int i = 0 ; i < 6 ; i ++) {
        LPOrderButton *button = [[LPOrderButton alloc]initWithFrame:CGRectMake(i * 70, 0, 70, 26)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        button.tag = i ;
        [button addTarget:self action:@selector(changeTableViewAtButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [scrollView addSubview:button];
        [arrayButton addObject:button];
    }
}

- (void)changeTableViewAtButton:(LPOrderButton *)button{
    _orderIndex = (int)button.tag;
    [self changeTableViewAtIndex:_orderIndex];
}

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
                          @"orderStatus":@"7,8,9"};
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
        [dataList removeAllObjects];
        [dataList addObjectsFromArray:result];
        if (dataList.count > 0 ) {
            [weakSelf hideKongView];
            pageCount ++;
            [myTableView.mj_footer endRefreshing];
            ///////////////////
            [myTableView reloadData];
        }else{
            [weakSelf addKongView];
            [myTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [myTableView.mj_header endRefreshing];
    
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
}

- (void)addKongView{
    [myTableView setHidden:YES];
    if (!kongLabel) {
        kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 50, 200, 20)];
        [kongLabel setBackgroundColor:[UIColor clearColor]];
        [kongLabel setTextColor:RGBA(127, 127, 127, 1)];
        [kongLabel setTextAlignment:NSTextAlignmentCenter];
        [kongLabel setFont:[UIFont systemFontOfSize:12]];
        kongLabel.tag = 501;
        [self.view addSubview:kongLabel];
    }
    if (!kongButton) {
        kongButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT / 2 - 30, 120, 35)];
        [kongButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        [kongButton setTitle:@"约约去" forState:UIControlStateNormal];
        [kongButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        kongButton.layer.cornerRadius = 4;
        kongButton.tag = 502;
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

- (void)backForward{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 102;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
