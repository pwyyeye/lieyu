//
//  ZSManageCustomerViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSManageCustomerViewController.h"
#import "ZSMyClientsViewController.h"
#import "ZSBirthdayManagerViewController.h"

@interface ZSManageCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ZSManageCustomerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"客户管理";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];}

- (void)initMainView{
    [self.view setBackgroundColor:RGB(242, 242, 242)];
    
    _titleArray = @[@"我的客户",@"生日管家"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 * _titleArray.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ManagerCustomerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ManagerCustomerCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ZSMyClientsViewController *myClientViewController=[[ZSMyClientsViewController alloc]initWithNibName:@"ZSMyClientsViewController" bundle:nil];
        [self.navigationController pushViewController:myClientViewController animated:YES];
    }else if (indexPath.row == 1){
        ZSBirthdayManagerViewController *birthdayManagerVC = [[ZSBirthdayManagerViewController alloc]initWithNibName:@"ZSBirthdayManagerViewController" bundle:nil];
        [self.navigationController pushViewController:birthdayManagerVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


@end
