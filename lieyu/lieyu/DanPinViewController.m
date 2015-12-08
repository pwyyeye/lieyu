//
//  DanPinViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DanPinViewController.h"

@interface DanPinViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DanPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBA(246, 246, 246, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if
    return 0;
}

@end
