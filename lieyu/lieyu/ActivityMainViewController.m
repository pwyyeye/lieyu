//
//  ActivityMainViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityMainViewController.h"
#import "EScrollerView.h"
#import "ActivityListTableViewCell.h"
#import "ActivityTypeTableViewCell.h"
#import "BarActivityList.h"
#import "HomepageBannerModel.h"
#import "BeerNewBarViewController.h"
#import "HuoDongLinkViewController.h"
#import "HuoDongViewController.h"
#import "DWTaoCanXQViewController.h"
#import "LYPlayTogetherMainViewController.h"
#import "ActionPage.h"
#import "ActionDetailViewController.h"
#import "ChiHeViewController.h"
#import "ZujuViewController.h"
#import "LYHomePageHttpTool.h"
#import "ActivityModel.h"
#import "ActivityDetailViewController.h"

#define LIMIT 10

@interface ActivityMainViewController ()<UITableViewDelegate,UITableViewDataSource,EScrollerViewDelegate>
{
    EScrollerView *_eScrollView;
    NSInteger _start;
    NSInteger _filterType;//1是演出派对，2是酒吧活动
    
    ActivityTypeTableViewCell *_activityTypeCell;
    
    UIActivityIndicatorView *_refreshingView;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation ActivityMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"活动派对";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filterType = 1;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUptableViewCells];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setupRefreshing];
    
    _refreshingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 30, 30)];
    _refreshingView.center = CGPointMake(SCREEN_WIDTH - 35, 25);
    _refreshingView.hidesWhenStopped = YES;
    _refreshingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:_refreshingView];
    [self.view bringSubviewToFront:_refreshingView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.width / 16 * 9)];
    _tableView.tableHeaderView = headerView;
    _eScrollView = [[EScrollerView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    _eScrollView.delegate = self;
    [headerView addSubview:_eScrollView];
    
    [self getData];
}

- (void)setUptableViewCells{
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityTypeTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityListTableViewCell"];
}

- (void)setupRefreshing{
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        //刷新，加载更多数据
        _start = _start + LIMIT;
        [weakSelf getData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

#pragma mark - 获取数据
- (void)getData{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dict = @{@"start":[NSString stringWithFormat:@"%d",_start],
                           @"limit":[NSString stringWithFormat:@"%d",LIMIT],
                           @"topicid":[MyUtil isEmptyString:_topicid] ? @"1" : _topicid,
                           @"activityType":[NSString stringWithFormat:@"%ld",_filterType]};
    [LYHomePageHttpTool getNewActivityListWithParam:dict complete:^(NSDictionary *result) {
        if (_start == 0) {
            _bannerArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"bannerList"]];
            _dataList = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"activityList"]];
            if (_dataList.count <= 0) {
                //空界面
            }else{
                //非空界面
            }
            [weakSelf setTableviewHeader];
            [_refreshingView stopAnimating];
            [_tableView.mj_footer endRefreshing];
        }else{
            if (((NSArray *)[result objectForKey:@"activityList"]).count <= 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_dataList addObjectsFromArray:[result objectForKey:@"activityList"]];
                [_tableView.mj_footer endRefreshing];
            }
        }
        [_tableView reloadData];
    }];
}

#pragma mark - 设置表头
- (void)setTableviewHeader{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (HomepageBannerModel *model in _bannerArray) {
        [imageArray addObject:model.img_url];
    }
    //    [eScrollView configureImagesArray:[self imagesArray]];
    [_eScrollView configureImagesArray:imageArray];
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataList.count) {
        return _dataList.count + 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        _activityTypeCell = [_tableView dequeueReusableCellWithIdentifier:@"ActivityTypeTableViewCell" forIndexPath:indexPath];
        if (_activityTypeCell.barActivityButton.tag == _filterType) {
            _activityTypeCell.partyLabel.hidden = YES;
            _activityTypeCell.barActivityLabel.hidden = NO;
            [_activityTypeCell.barText setTextColor:COMMON_PURPLE];
            [_activityTypeCell.partyText setTextColor:[UIColor blackColor]];
        }else{
            _activityTypeCell.partyLabel.hidden = NO;
            _activityTypeCell.barActivityLabel.hidden = YES;
            [_activityTypeCell.barText setTextColor:[UIColor blackColor]];
            [_activityTypeCell.partyText setTextColor:COMMON_PURPLE];
        }
        [_activityTypeCell.partyButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_activityTypeCell.barActivityButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return _activityTypeCell;
    }else{
        ActivityListTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ActivityListTableViewCell" forIndexPath:indexPath];
        BarActivityList *barActivity = [_dataList objectAtIndex:(indexPath.section - 1)];
        cell.barActivity = barActivity;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 81;
    }else{
        return SCREEN_WIDTH / 25 * 12 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.000000001;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0 && indexPath.section <= _dataList.count) {
        if (_filterType == 1) {
            BarActivityList *barActivity = [_dataList objectAtIndex:indexPath.section - 1];
            ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            activityDetailVC.activityID = barActivity.id;
            [self.navigationController pushViewController:activityDetailVC animated:YES];
        }else{
            BarActivityList *barActivity = [_dataList objectAtIndex:indexPath.section - 1];
            ActionDetailViewController *activityDetailVC = [[ActionDetailViewController alloc]initWithNibName:@"ActionDetailViewController" bundle:nil];
            activityDetailVC.actionID = barActivity.id;
            [self.navigationController pushViewController:activityDetailVC animated:YES];
        }
    }
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        _eScrollView.isDragVertical = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat imageHeight = _tableView.tableHeaderView.frame.size.height;
    CGFloat imageWidth = _tableView.tableHeaderView.frame.size.width;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat bili = totalOffset / imageHeight * 1.0;
        _eScrollView.isDragVertical = YES;
        [_eScrollView setScrollViewFrame:CGRectMake((imageWidth - imageWidth * bili) / 2, imageOffsetY, SCREEN_WIDTH * bili, totalOffset)];
    }
    NSLog(@"%f",imageOffsetY);
    if (imageOffsetY < -150) {
        //刷新数据
        _start = 0 ;
        [_refreshingView startAnimating];
        [self getData];
    }
}

#pragma mark - EScrollerViewDelegate
-(void)EScrollerViewDidClicked:(NSUInteger)index{
    HomepageBannerModel *bannerModel = [_bannerArray objectAtIndex:index];
    NSInteger ad_type = [bannerModel.ad_type integerValue];
    NSInteger linkid = [bannerModel.linkid integerValue];
    //    "ad_type": 1,//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客 5：专题 6:专题活动
    //    "linkid": 1 //对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
    if(ad_type ==1){
        //酒吧
        BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
        controller.beerBarId = [[NSNumber alloc]initWithInteger:linkid];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图酒吧ID%ld",linkid];
        [self.navigationController pushViewController:controller animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:str]];
    }else if(ad_type ==2){
        //有活动内容才跳转
        if(![MyUtil isEmptyString:bannerModel.linkurl]){
            HuoDongLinkViewController *huodong2=[[HuoDongLinkViewController alloc] init];
            huodong2.linkUrl=bannerModel.linkurl;
            huodong2.title = bannerModel.title == nil ? @"活动详情" : bannerModel.title;
            [self.navigationController pushViewController:huodong2 animated:YES];
            
        }else if (bannerModel.content) {
            HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
            huodong.content = bannerModel.content;
            huodong.title = bannerModel.title == nil ? @"活动详情" : bannerModel.title;
            [self.navigationController pushViewController:huodong animated:YES];
        }
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:@"活动"]];
    }else if (ad_type ==3){
        //    套餐/3
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[dateFormatter stringFromDate:[NSDate new]];
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
        taoCanXQViewController.title=@"套餐详情";
        taoCanXQViewController.smid = (int)linkid ;
        taoCanXQViewController.dateStr = dateStr;
        [self.navigationController pushViewController:taoCanXQViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图套餐详情ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:str]];
    }else if (ad_type ==4){
        //    4：拼客
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        LYPlayTogetherMainViewController *playTogetherMainViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
        playTogetherMainViewController.title=@"我要拼客";
        playTogetherMainViewController.smid = (int)linkid;
        [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图我要拼客ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:str]];
    }else if (ad_type ==5){//专题
        if (!linkid) {
            return;
        }
        //进入本页面
//        ActionPage *actionPage=[[ActionPage alloc] initWithNibName:@"ActionPage" bundle:nil];
//        actionPage.topicid=[NSString stringWithFormat:@"%ld",linkid];
//        [self.navigationController pushViewController:actionPage animated:YES];
    }else if (ad_type ==6){//专题活动
        if (!linkid) {
            return;
        }
        ActionDetailViewController *activityDetailVC = [[ActionDetailViewController alloc]initWithNibName:@"ActionDetailViewController" bundle:nil];
        activityDetailVC.actionID = [NSString stringWithFormat:@"%ld",linkid];
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }else if (ad_type ==7){//单品
        ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
        CHDetailVC.title=@"吃喝专场";
        CHDetailVC.barid=(int)linkid;
        CHDetailVC.barName=bannerModel.title==nil?[NSString stringWithFormat:@"酒吧%ld",linkid]:bannerModel.title;
        [self.navigationController pushViewController:CHDetailVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图吃喝专场ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:str]];
    }else if (ad_type ==8){//组局
        ZujuViewController *zujuVC = [[ZujuViewController alloc]initWithNibName:@"ZujuViewController" bundle:nil];
        zujuVC.title = @"组局";
        zujuVC.barid = (int)linkid;
        [self.navigationController pushViewController:zujuVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图组局ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动列表" titleName:str]];
    }else if (ad_type == 10){//演出派对
        if (!linkid) {
            return;
        }
        ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
        activityDetailVC.activityID = [NSString stringWithFormat:@"%ld",linkid];
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }
}

#pragma mark - 按钮事件
- (void)filterButtonClick:(UIButton *)button{
    if (button.tag != _filterType) {
        if (button.tag == 1) {
            _activityTypeCell.barActivityLabel.hidden = YES;
            _activityTypeCell.partyLabel.hidden = NO;
            [_activityTypeCell.barText setTextColor:[UIColor blackColor]];
            [_activityTypeCell.partyText setTextColor:COMMON_PURPLE];
        }else if (button.tag == 2){
            _activityTypeCell.barActivityLabel.hidden = NO;
            _activityTypeCell.partyLabel.hidden = YES;
            [_activityTypeCell.barText setTextColor:COMMON_PURPLE];
            [_activityTypeCell.partyText setTextColor:[UIColor blackColor]];
        }
        _filterType = button.tag;
        _start = 0 ;
        [self getData];
    }
}

@end
