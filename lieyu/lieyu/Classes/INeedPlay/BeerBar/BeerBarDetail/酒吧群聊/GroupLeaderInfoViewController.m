//
//  GroupLeaderInfoViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "GroupLeaderInfoViewController.h"
#import "GroupLeaderRegisterViewController.h"

@interface GroupLeaderInfoViewController ()

@end

@implementation GroupLeaderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_registerAdminButton addTarget:self action:@selector(registerAdmin) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)registerAdmin{
    GroupLeaderRegisterViewController *registerVC = [[GroupLeaderRegisterViewController alloc] init];
    registerVC.navigationItem.leftBarButtonItem = [self getItem];
    registerVC.title = @"申请原因";
    registerVC.groupId = _groupId;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(BaseGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}

-(void)BaseGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
