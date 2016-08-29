//
//  LYBlackListViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBlackListViewController.h"
#import "LYAddFriendTableViewCell.h"

@interface LYBlackListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation LYBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LYAddFriendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LYAddFriendTableViewCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYAddFriendTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LYAddFriendTableViewCell" forIndexPath:indexPath];
    [cell.statusButton setTitle:@"取消" forState:UIControlStateNormal];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
