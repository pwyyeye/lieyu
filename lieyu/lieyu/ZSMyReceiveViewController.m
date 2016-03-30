//
//  ZSMyReceiveViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/28.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSMyReceiveViewController.h"
#import "ZSTiXianTableViewCell.h"
#import "ZSManageHttpTool.h"
#import "ZSTiXianRecordViewController.h"
#import "ZSBalance.h"
#import "LYWithdrawTypeViewController.h"

#define ZSTiXianTableViewCellID @"ZSTiXianTableViewCell"

@interface ZSMyReceiveViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataArray,*_titleArray,*_moneyArray;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_tiXian;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label_balance;

@end

@implementation ZSMyReceiveViewController
 - (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden  = YES;
    
    _label_balance.text = [NSString stringWithFormat:@"¥%.2f",_balance.balances.floatValue];
    _titleArray = @[@"交易中",@"提现记录"];
    _moneyArray = @[_balance.activeAmount,_balance.withdrawalsSum];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    [_tableview registerNib:[UINib nibWithNibName:ZSTiXianTableViewCellID bundle:nil] forCellReuseIdentifier:ZSTiXianTableViewCellID];
    [_btn_tiXian addTarget:self action:@selector(WithdrawCash) forControlEvents:UIControlEventTouchUpInside];
    _btn_tiXian.layer.cornerRadius = CGRectGetHeight(_btn_tiXian.frame)/2.f;
    _btn_tiXian.layer.masksToBounds = YES;
}

- (void)WithdrawCash{
        LYWithdrawTypeViewController *WithdrawTypeVC = [[LYWithdrawTypeViewController alloc]initWithNibName:@"LYWithdrawTypeViewController" bundle:nil];
    WithdrawTypeVC.type = _balance.accountType;
    WithdrawTypeVC.account = _balance.accountName;
    WithdrawTypeVC.balance = _balance.balances;
        [self.navigationController pushViewController:WithdrawTypeVC animated:YES];
}

- (IBAction)goback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_titleArray.count < _moneyArray.count) {
        return _titleArray.count;
    }else{
        return _moneyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSTiXianTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:ZSTiXianTableViewCellID forIndexPath:indexPath];
    NSString *withdrawalsSumStr =_moneyArray[indexPath.row];
    cell.label_tittle.text = _titleArray[indexPath.row];
    cell.label_money.text = [NSString stringWithFormat:@"%.2f",withdrawalsSumStr.floatValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            break;
            
        default:{
            ZSTiXianRecordViewController *zsTiXianRecordVC = [[ZSTiXianRecordViewController alloc]init];
            [self.navigationController pushViewController:zsTiXianRecordVC animated:YES];
        }
            
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
