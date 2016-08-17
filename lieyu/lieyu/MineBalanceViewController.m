//
//  MineBalanceViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineBalanceViewController.h"

@interface MineBalanceViewController ()

@end

@implementation MineBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    _rechargeButton.layer.cornerRadius = 21;
    [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawButton.layer.cornerRadius = 21;
    [_withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rechargeButtonClick:(UIButton *)sender{
    
}

- (void)withdrawButtonClick:(UIButton *)sender{
    
}

@end
