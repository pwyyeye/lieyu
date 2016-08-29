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

@interface MineBalanceViewController ()<UIAlertViewDelegate>

@end

@implementation MineBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    _rechargeButton.layer.cornerRadius = 19;
    [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawButton.layer.cornerRadius = 19;
    [_withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    //提现
//    UIAlertView *withdrawAlertView = [[UIAlertView alloc]initWithTitle:@"请输入提现金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    withdrawAlertView.tag = 2;
//    [withdrawAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    UITextField *withdrawField = [withdrawAlertView textFieldAtIndex:0];
//    withdrawField.textAlignment = NSTextAlignmentCenter;
//    withdrawField.keyboardType = UIKeyboardTypeNumberPad;
//    withdrawField.text = @"500";
//    [withdrawAlertView show];
    LYWithdrawTypeViewController *lyWithdrawTypeVC = [[LYWithdrawTypeViewController alloc]initWithNibName:@"LYWithdrawTypeViewController" bundle:[NSBundle mainBundle]];
    //需要参数
    lyWithdrawTypeVC.type = @"1";
    lyWithdrawTypeVC.account = @"we";
    lyWithdrawTypeVC.balance = @"500";
    [self.navigationController pushViewController:lyWithdrawTypeVC animated:YES];
}

#pragma mark - alertview的代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (alertView.tag == 1) {
        //充值
        if (buttonIndex == 1) {
//            NSLog(@"充值：%@",textField.text);
            ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
            //            detailViewController.orderNo=result;
            detailViewController.payAmount=[textField.text doubleValue];
            detailViewController.productName=@"钱包余额充值";
            detailViewController.productDescription=@"暂无";
            [self.navigationController pushViewController:detailViewController animated:YES];
        }else{
            NSLog(@"cancle recharge");
        }
    }else if (alertView.tag == 2){
        //提现
        if (buttonIndex == 1){
            NSLog(@"提现：%@",textField.text);
        }else{
            NSLog(@"cancle withdraw");
        }
    }
}


@end
