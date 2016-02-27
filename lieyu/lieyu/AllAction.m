//
//  AllAction.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AllAction.h"
#import "HDZTHeaderCell.h"
#import "LYHomePageHttpTool.h"
#import "ActionPage.h"

@interface AllAction ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataList;
    int start ;
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
    dataList = [NSMutableArray array];
    self.title = @"所有专题";
    [self registerTableViewCell];
    [self addRefreshAction];
    [self getData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    NSDictionary *dict = @{@"start":[NSString stringWithFormat:@"%d",start],
                           @"limit":@"10"};
    [LYHomePageHttpTool getActionList:dict complete:^(NSMutableArray *result) {
        if (result.count > 0) {
            [dataList addObjectsFromArray:result];
            [self.tableView reloadData];
            if (self.tableView.contentSize.height < SCREEN_HEIGHT - 64) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
        }
    }];
}

- (void)addRefreshAction{
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [dataList removeAllObjects];
        [weakSelf getData];
        [_tableView.mj_header endRefreshing];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)_tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
        [_tableView.mj_footer endRefreshing];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)registerTableViewCell{
    [_tableView registerNib:[UINib nibWithNibName:@"HDZTHeaderCell" bundle:nil] forCellReuseIdentifier:@"HDZTHeaderCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataList.count;
//    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDZTHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDZTHeaderCell" forIndexPath:indexPath];
    cell.action_image.backgroundColor = [UIColor grayColor];
    if (dataList.count > 0) {
        cell.topicInfo = (BarTopicInfo *)[dataList objectAtIndex:indexPath.section];
    }
    cell.action_discript.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionPage *actionPage = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    actionPage.topicid = ((BarTopicInfo *)[dataList objectAtIndex:indexPath.section]).id;
    
    NSDictionary *dict = @{@"actionName":@"跳转",
                           @"pageName":@"所有专题",
                           @"titleName":@"活动专题",
                           @"value":actionPage.topicid};
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:dict];
    
    [self.navigationController popToViewController:actionPage animated:YES];
}

@end
