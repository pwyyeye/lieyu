//
//  ActionPage.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
//一张图片与多个活动列表的页面,有上拉下拉刷新

#import "ActionPage.h"
#import "HDZTHeaderCell.h"
#import "HDZTListCell.h"
#import "ActionDetailViewController.h"
#import "AllAction.h"
#import "LYUserLocation.h"
#import "LYHomePageHttpTool.h"
@interface ActionPage ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *actionList;
    HDZTHeaderCell *headerCell;
    HDZTListCell *listCell;
    int page ;
    float contentOffsetY;
    int rows;
    UIButton *button;
    
    int start;
}
@end

@implementation ActionPage

- (void)viewDidLoad {
    [super viewDidLoad];
//    _tableView.backgroundColor = [UIColor whiteColor];
    contentOffsetY = MAXFLOAT;
    page = 1;
    actionList = [NSMutableArray array];
    self.tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self ConfigureRightItem];
    [self registerTableViewCell];
    [self getData];
    [self addRefreshAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"滑动了多少：%f",scrollView.contentOffset.y);
//    NSLog(@"最多为多少：%f",contentOffsetY);
    if (scrollView.contentOffset.y <= 10) {
        self.tableView.bounces = YES;
    }
    if (scrollView.contentOffset.y >= contentOffsetY) {
        self.tableView.bounces = NO;
    }
}

#pragma mark - 更多专题按钮
- (void)ConfigureRightItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"更多专题" style:UIBarButtonItemStylePlain target:self action:@selector(MoreTopic)];
    rightItem.tintColor = [UIColor blackColor];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)MoreTopic{
    AllAction *allActionVC = [[AllAction alloc]init];
    [self.navigationController pushViewController:allActionVC animated:YES];
}

#pragma mark - 当刷新到最底部时
- (void)StopBottomBounds:(BOOL) isIn{
    if (isIn) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        button = [[UIButton alloc]initWithFrame:CGRectMake(10, self.tableView.contentSize.height + 10, SCREEN_WIDTH - 20, 44)];
        //    NSLog(@"tableView的总长度：%f",self.tableView.contentOffset.y);
        contentOffsetY = self.tableView.contentOffset.y;
    }
    else{
        button = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 118, SCREEN_WIDTH - 20, 44)];
        self.tableView.bounces = NO;
    }
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(MoreTopic) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:button];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 上拉刷新一切重置
- (void)initAllPropertites{
    page = 1;
    start = 0;
    [button removeFromSuperview];
    [actionList removeAllObjects];
    self.tableView.mj_footer.hidden = NO;
    contentOffsetY = MAXFLOAT;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)getData{
    //获取数据
    NSDictionary *dic = @{@"start":[NSString stringWithFormat:@"%d",start],
                          @"limit":@"10",
                          @"topicid":@"1"};
    [LYHomePageHttpTool getActivityListWithPara:dic compelte:^(NSMutableArray *result) {
        if (result.count > 0) {
            [actionList addObjectsFromArray:result];
            [self.tableView reloadData];
            if(self.tableView.contentSize.height < SCREEN_HEIGHT - 64){
                [self StopBottomBounds:NO];
            }
        }else{
            //没有更多数据了
            [self StopBottomBounds:YES];
        }
    }];
}

- (void)registerTableViewCell{
    [_tableView registerNib:[UINib nibWithNibName:@"HDZTHeaderCell" bundle:nil] forCellReuseIdentifier:@"HDZTHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HDZTListCell" bundle:nil] forCellReuseIdentifier:@"HDZTListCell"];
}

- (void)addRefreshAction{
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self initAllPropertites];
        [weakSelf getData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        page ++;
        start += 10;
        [weakSelf getData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (actionList.count > 0) {
        return actionList.count + 1;
    }else{
        return 0;
    }
//    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HDZTHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDZTHeaderCell" forIndexPath:indexPath];
        cell.action_image.backgroundColor = [UIColor grayColor];
        cell.topicInfo = ((BarActivityList *)[actionList objectAtIndex:indexPath.section]).topicInfo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HDZTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDZTListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        actionList objectAtIndex:indexPath
        cell.barActivity = [actionList objectAtIndex:indexPath.section - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (SCREEN_WIDTH - 6) / 16 * 9 + 64;
    }else{
        return 192;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionDetailViewController *actionDetailVC = [[ActionDetailViewController alloc]initWithNibName:@"ActionDetailViewController" bundle:nil];
    actionDetailVC.title = @"活动详情";
    [self.navigationController pushViewController:actionDetailVC animated:YES];
}

@end
