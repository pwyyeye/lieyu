//
//  LYPrivateViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPrivateViewController.h"
#import "LYBlackListViewController.h"

#define CELL_ID @"privateCell"

@interface LYPrivateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *switchArray;

@end

@implementation LYPrivateViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"隐私设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self getData];
}

- (void)getData{
    _switchArray = [[NSMutableArray alloc]initWithObjects:@"1", @"0", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"允许陌生人私聊"];
    }else if (indexPath.section == 1){
        [cell.textLabel setText:@"玩友圈显示陌生人动态"];
    }else if (indexPath.section == 2){
        [cell.textLabel setText:@"黑名单"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0 || indexPath.section == 1) {
        UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 50, 35)];
        switchButton.tag = indexPath.section;
        [switchButton addTarget:self action:@selector(privateSetting:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:switchButton];
        if ([[_switchArray objectAtIndex:indexPath.section] isEqualToString:@"0"]) {
            switchButton.on = NO;
        }else{
            switchButton.on = YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //黑名单
        LYBlackListViewController *blackListVC = [[LYBlackListViewController alloc]init];
        [self.navigationController pushViewController:blackListVC animated:YES];
    }
}

- (void)privateSetting:(UISwitch *)button{
    NSLog(@"%ld",button.tag);
}


@end
