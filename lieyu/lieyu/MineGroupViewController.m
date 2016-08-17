//
//  MineGroupViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineGroupViewController.h"
#import "MineGroupCodeViewController.h"
#import "MineGroupIntroViewController.h"

@interface MineGroupViewController ()

@end

@implementation MineGroupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initRightItemsButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的娱客帮";
}

- (void)initRightItemsButton{
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setImage:[UIImage imageNamed:@"userSetting"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    UIButton *codeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [codeButton setImage:[UIImage imageNamed:@"userSuHeMa"] forState:UIControlStateNormal];
    [codeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [codeButton addTarget:self action:@selector(codeGroup:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *codeItem = [[UIBarButtonItem alloc]initWithCustomView:codeButton];
    
    self.navigationItem.rightBarButtonItems = @[addItem,codeItem];
    
    self.introButton.layer.cornerRadius = 5;
    [self.introButton addTarget:self action:@selector(introButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGroup:(UIButton *)sender{
    
}

- (void)codeGroup:(UIButton *)sender{
    MineGroupCodeViewController *mineGroupCodeVC = [[MineGroupCodeViewController alloc]initWithNibName:@"MineGroupCodeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:mineGroupCodeVC animated:YES];
}

- (void)introButtonClick:(UIButton *)sender{
    MineGroupIntroViewController *mineGroupIntroVC = [[MineGroupIntroViewController alloc]initWithNibName:@"MineGroupIntroViewController" bundle:nil];
    [self.navigationController pushViewController:mineGroupIntroVC animated:YES];
}

@end
