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
#import "ZSTiXianRecordViewController.h"

@interface MineBalanceViewController ()<UIAlertViewDelegate,MineBoundAccountDelegate,LYWithdrawDelegate,RechargeDelegate>

@end

@implementation MineBalanceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"余额";
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getData];
    [self initRightItem];
    
    _rechargeButton.layer.cornerRadius = 19;
    [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawButton.layer.cornerRadius = 19;
    [_withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getData{
    [LYUserHttpTool getMyMoneyBagBalanceAndCoinWithParams:nil complete:^(ZSBalance *balance) {
        _balance = balance;
        [_balanceLabel setText:[NSString stringWithFormat:@"¥%@",_balance.balances]];
    }];
}

- (void)initRightItem{
    UIButton *listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [listButton setTitle:@"明细" forState:UIControlStateNormal];
    [listButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [listButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [listButton setTitleColor:NAVIGATIONBARTITLECOLOR forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(withdrawListClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件

- (void)withdrawListClick:(UIButton *)button{
    //    MineWithdrawListViewController *mineWithdrawListVC = [[MineWithdrawListViewController alloc]init];
    ZSTiXianRecordViewController *mineWithdrawListVC = [[ZSTiXianRecordViewController alloc]init];
    mineWithdrawListVC.subTitle = @"明细";
    [self.navigationController pushViewController:mineWithdrawListVC animated:YES];
}


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
    if ([MyUtil isEmptyString:_balance.accountName] || [MyUtil isEmptyString:_balance.accountType]) {
        [[[AlertBlock alloc]initWithTitle:nil message:@"您还未绑定提现账户，请先绑定！" cancelButtonTitle:@"下次吧" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1){
                MineBoundAccountViewController *mineBoundAccountVC = [[MineBoundAccountViewController alloc]initWithNibName:@"MineBoundAccountViewController" bundle:nil];
                mineBoundAccountVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:mineBoundAccountVC animated:YES];
            }
        }]show];
    }else if ([_balance.balances doubleValue] <= 0){
        [MyUtil showPlaceMessage:@"余额不足，无法提现！"];
    }else{
        LYWithdrawTypeViewController *lyWithdrawTypeVC = [[LYWithdrawTypeViewController alloc]initWithNibName:@"LYWithdrawTypeViewController" bundle:[NSBundle mainBundle]];
        lyWithdrawTypeVC.type = _balance.accountType;
        lyWithdrawTypeVC.account = _balance.accountName;
        lyWithdrawTypeVC.balance = _balance.balances;
        lyWithdrawTypeVC.delegate = self;
        [self.navigationController pushViewController:lyWithdrawTypeVC animated:YES];
    }
}

#pragma mark - 提现的代理方法
- (void)lyWithdrawDataRefresh{
    [self refreshBalanceViewControllerData];
}

#pragma mark - 绑定账户的代理方法
- (void)mineBoundAccountWithType:(NSString *)type Account:(NSString *)account{
//    [self getData];
}

#pragma mark - alertview的代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (alertView.tag == 1) {
        //充值
        if (buttonIndex == 1) {
            if ([textField.text doubleValue] <= 0.0){
                [MyUtil showPlaceMessage:@"充值金额不可为0或更小！"];
                return;
            }
            NSDictionary *dict = @{@"amount":textField.text,
                                   @"isToCoin":@"0"};
            __weak __typeof(self)weakSelf = self;
            [LYUserHttpTool rechargeMoneyBagWithParams:dict complete:^(NSString *result) {
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                detailViewController.delegate = weakSelf;
                detailViewController.payAmount=[textField.text doubleValue];
                detailViewController.productName=@"余额充值";
                detailViewController.productDescription=@"暂无";
                detailViewController.isRechargeBalance = YES;
                [weakSelf.navigationController pushViewController:detailViewController animated:YES];
            }];
        }else{
            //cancel
        }
    }
}

#pragma mark - 充值后的代理方法
- (void)rechargeDelegateRefreshData{
//    [self getData];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(MineBalanceDelegateRefreshData)]) {
//        [self.delegate MineBalanceDelegateRefreshData];
//    }
}

#pragma mark - 刷新数据
- (void)refreshBalanceViewControllerData{
//    [self getData];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(MineBalanceDelegateRefreshData)]) {
//        [self.delegate MineBalanceDelegateRefreshData];
//    }
}

@end
