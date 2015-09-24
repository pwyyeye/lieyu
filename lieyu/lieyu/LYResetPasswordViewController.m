//
//  LYResetPasswordViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYResetPasswordViewController.h"
#import "LYSurePassWordViewController.h"
@interface LYResetPasswordViewController ()

@end

@implementation LYResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)nextAct:(UIButton *)sender {
    
    LYSurePassWordViewController *surePassWordViewController=[[LYSurePassWordViewController alloc]initWithNibName:@"LYSurePassWordViewController" bundle:nil];
    surePassWordViewController.title=@"确定密码";
    [self.navigationController pushViewController:surePassWordViewController animated:YES];
}

- (IBAction)getYZMAct:(UIButton *)sender {
}
@end
