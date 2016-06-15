//
//  LYMyFreeOrdersViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/6/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFreeOrdersViewController.h"
#import "FreeOrderTableViewCell.h"
#import "LPOrderButton.h"
#import "LYUserHttpTool.h"

#define LIMIT 10

@interface LYMyFreeOrdersViewController ()
{
    int _start;
    NSString *_type;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_searchDict;
}
@end

@implementation LYMyFreeOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    if ([self.userModel.usertype isEqualToString:@"2"]|| [self.userModel.usertype isEqualToString:@"3"]) {
        _type = @"1";
    }else{
        _type = @"0";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCells{
    [myTableView registerNib:[UINib nibWithNibName:@"FreeOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"FreeOrderTableViewCell"];
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
            [self getDaiQueRen];
            break;
        case 2:
            [self getDaiPingJia];
            break;
        case 3:
            [self getYiPingJia];
            break;
        default:
            break;
    }
}

- (void)getAllOrder{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT]};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getDaiQueRen{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"1"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getDaiPingJia{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"2"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getYiPingJia{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"3"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getOrderWithDic:(NSDictionary *)dict{
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyFreeOrdersWithParams:dict block:^(NSArray *dataArray) {
        if (_start == 0) {
            [_dataArray removeAllObjects];
            [myTableView.mj_header endRefreshing];
        }
        _start = _start + LIMIT;
        [_dataArray addObjectsFromArray:dataArray];
        if (dataArray.count) {
            [myTableView.mj_footer endRefreshing];
        }else{
            [myTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_dataArray.count) {
            [weakSelf hideKongView];
        }else{
            [weakSelf addKongView];
        }
        myTableView.contentOffset = CGPointMake(0, -90);
        [myTableView reloadData];
    }];
}

#pragma mark - 刷新数据
- (void)refreshData{
    _start = 0 ;
    [_searchDict removeObjectForKey:@"start"];
    [_searchDict setObject:[NSNumber numberWithInt:_start] forKey:@"start"];
    [self getOrderWithDic:_searchDict];
}

- (void)loadMoreData{
    [_searchDict removeObjectForKey:@"start"];
    [_searchDict setObject:[NSNumber numberWithInt:_start] forKey:@"start"];
    [self getOrderWithDic:_searchDict];
}

#pragma mark - tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreeOrderTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"FreeOrderTableViewCell" owner:nil options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}








@end
