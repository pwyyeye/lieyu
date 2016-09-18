//
//  MineBalanceViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineBalanceViewController.h"
#import "LYWithdrawTypeViewController.h"
#import "ChoosePayController.h"
#import "LYUserHttpTool.h"
#import "MineBoundAccountViewController.h"

@interface MineBalanceViewController ()<UIAlertViewDelegate>

@end

@implementation MineBalanceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"余额";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rechargeButton.layer.cornerRadius = 19;
    [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawButton.layer.cornerRadius = 19;
    [_withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_balanceLabel setText:[NSString stringWithFormat:@"¥%@",_balance.balances]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (void)rechargeButtonClick:(UIButton *)sender{
    //充值
    UIAlertView *rechargeAlertView = [[UIAlertView alloc]initWithTitle:@"请输入充值金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    rechargeAlertView.tag = 1;
    [rechargeAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *rechargeField = [rechargeAlertView textFieldAtIndex:0];
    rechargeField.textAlignment = NSTextAlignmentCenter;
    rechargeField.keyboardType = UIKeyboardTypeNumberPad;
    rechargeField.text = @"100";
    [rechargeAlertView show];
}

- (void)withdrawButtonClick:(UIButton *)sender{
    __weak __typeof(self) weakSelf = self;
    //需要参数
    //
    if ([_balance.balances doubleValue] <= 0){
        [MyUtil showPlaceMessage:@"余额不足，无法提现！"];
    }else if ([MyUtil isEmptyString:_balance.accountName] || [MyUtil isEmptyString:_balance.accountType]) {
    //
        [[[AlertBlock alloc]initWithTitle:nil message:@"您还未绑定提现账户，请先绑定！" cancelButtonTitle:@"下次吧" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1){
                MineBoundAccountViewController *mineBoundAccountVC = [[MineBoundAccountViewController alloc]initWithNibName:@"MineBoundAccountViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:mineBoundAccountVC animated:YES];
            }
        }]show];
        //
    }else{
        LYWithdrawTypeViewController *lyWithdrawTypeVC = [[LYWithdrawTypeViewController alloc]initWithNibName:@"LYWithdrawTypeViewController" bundle:[NSBundle mainBundle]];
        lyWithdrawTypeVC.type = _balance.accountType;
        lyWithdrawTypeVC.account = _balance.accountName;
        lyWithdrawTypeVC.balance = _balance.balances;
        [self.navigationController pushViewController:lyWithdrawTypeVC animated:YES];
    }
        //
}

#pragma mark - alertview的代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (alertView.tag == 1) {
        //充值
        if (buttonIndex == 1) {
            NSDictionary *dict = @{@"amount":textField.text};
            [LYUserHttpTool rechargeMoneyBagWithParams:dict complete:^(NSString *result) {
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                detailViewController.payAmount=[textField.text doubleValue];
                detailViewController.productName=@"钱包余额充值";
                detailViewController.productDescription=@"暂无";
                [self.navigationController pushViewController:detailViewController animated:YES];
            }];
        }else{
            //cancel
        }
    }
}


@end
