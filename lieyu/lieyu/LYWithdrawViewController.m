//
//  LYWithdrawViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/28.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWithdrawViewController.h"

@interface LYWithdrawViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation LYWithdrawViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"选择提现方式";
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    _data=@[
            @{@"payname":@"支付宝提现",@"paydetail":@"推荐有支付宝帐户的用户使用",@"payicon":@"AlipayIcon"},
            @{@"payname":@"微信提现",@"paydetail":@"推荐有微信帐户的用户使用",@"payicon":@"TenpayIcon"}
            ];
}

#pragma mark - tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"withdrawCell"];
        cell.textLabel.text = @"帐户可提现余额:";
        cell.detailTextLabel.text = _balance;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *payCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
        if (!payCell) {
            payCell = [tableView dequeueReusableCellWithIdentifier:@"withdrayPayCell"];
        }
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        payCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic = [_data objectAtIndex:indexPath.row];
        payCell.textLabel.text = [dic objectForKey:@"payname"];
        payCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        payCell.textLabel.textColor = RGB(26, 26, 26);
        
        payCell.detailTextLabel.text = [dic objectForKey:@"paydetail"];
        payCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        payCell.detailTextLabel.textColor=RGB(102, 101, 102);
        payCell.imageView.image=[UIImage imageNamed:[dic objectForKey:@"payicon"]];
        return payCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 48;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LYWithdrawWithTypeViewController *WithdrawWithTypeVC = [[LYWithdrawWithTypeViewController alloc]initWithNibName:@"LYWithdrawWithTypeViewController" bundle:nil];
//    WithdrawWithTypeVC.type = [NSString stringWithFormat:@"%ld",indexPath.row];
//    WithdrawWithTypeVC.account = self.account;
//    WithdrawWithTypeVC.balance = self.balance;
//    [self.navigationController pushViewController:WithdrawWithTypeVC animated:YES];
}

@end
