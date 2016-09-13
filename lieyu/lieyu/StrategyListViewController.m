//
//  StrategyListViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategyListViewController.h"
#import "StrategryTableViewCell.h"
#import "StrategryModel.h"
#import "LYHomePageHttpTool.h"
#import "StrategyDetailViewController.h"

#define LIMIT 10

@interface StrategyListViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _start;
}

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *kongLabel;

@end

@implementation StrategyListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"娱乐攻略";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"StrategryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StrategryTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setupRefreshing];
    [self getData];
}

#pragma mark - getData
- (void)setupRefreshing{
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _start = 0 ;
        [weakSelf getData];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)_tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _start = _start + LIMIT;
        [weakSelf getData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)getData{
    NSDictionary *dict = @{@"start":[NSString stringWithFormat:@"%ld",_start],
                           @"limit":[NSString stringWithFormat:@"%d",LIMIT]};
    __weak __typeof(self) weakSelf = self;
    [LYHomePageHttpTool getStrategyListWith:dict complete:^(NSArray *result) {
        if (_start == 0) {
            if (result.count == 0) {
                [weakSelf showKongLabel];
            }else{
                [weakSelf hideKongLabel];
            }
            _dataList = [[NSMutableArray alloc]initWithArray:result];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }else{
            if (result.count <= 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            [_dataList addObjectsFromArray:result];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - 空界面
- (void)showKongLabel{
    if (!_kongLabel) {
        _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH / 2 - 30, SCREEN_WIDTH, 20)];
        [_kongLabel setText:@"抱歉，暂无攻略！"];
        [_kongLabel setFont:[UIFont systemFontOfSize:14]];
        [_kongLabel setTextColor:RGBA(186, 40, 227, 1)];
        [_kongLabel setTextAlignment:NSTextAlignmentCenter];
    }
    [self.view addSubview:_kongLabel];
//    [_tableView setHidden:YES];
    [self.view bringSubviewToFront:_kongLabel];
}

- (void)hideKongLabel{
//    [_tableView setHidden:NO];
    [_kongLabel removeFromSuperview];
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataList) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataList) {
        return _dataList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StrategryTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"StrategryTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    StrategryModel *model = [_dataList objectAtIndex:indexPath.row];
    cell.strategyModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH / 25 * 16 + 59;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.001;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.0000001;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StrategyDetailViewController *strategyDetailVC = [[StrategyDetailViewController alloc]initWithNibName:@"StrategyDetailViewController" bundle:nil];
    strategyDetailVC.strategyID = ((StrategryModel *)[_dataList objectAtIndex:indexPath.row]).id;
    [self.navigationController pushViewController:strategyDetailVC animated:YES];
}

@end
