//
//  AllAction.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AllAction.h"
#import "HDZTHeaderCell.h"
@interface AllAction ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataList;
}
@end

@implementation AllAction

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    self.title = @"所有专题";
    [self registerTableViewCell];
    [self addRefreshAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    
}

- (void)addRefreshAction{
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)_tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)registerTableViewCell{
    [_tableView registerNib:[UINib nibWithNibName:@"HDZTHeaderCell" bundle:nil] forCellReuseIdentifier:@"HDZTHeaderCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return dataList.count;
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDZTHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDZTHeaderCell" forIndexPath:indexPath];
    cell.action_image.backgroundColor = [UIColor grayColor];
    cell.action_discript.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH - 6) / 16 * 9;
}

@end
