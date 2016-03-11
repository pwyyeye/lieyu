//
//  LPUserLoginViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPUserLoginViewController.h"
#import "LYUserLoginViewController.h"
#import "LYRegistrationViewController.h"

@interface LPUserLoginViewController ()

@end

@implementation LPUserLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rambleBtn.hidden = YES;
    if ([[MyUtil deviceString] isEqualToString:@"iPhone 5"] ||
        [[MyUtil deviceString] isEqualToString:@"iPhone 5S"] ||
        [[MyUtil deviceString] isEqualToString:@"iPhone 5C"]) {
        _CartoonTop.constant = 60;
    }else if(SCREEN_WIDTH == 375){
        _CartoonTop.constant = 80;
    }else if (SCREEN_WIDTH == 414){
        _CartoonTop.constant = 80;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginClick:(UIButton *)sender {
    LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]initWithNibName:@"LYUserLoginViewController" bundle:nil];
//    [self presentViewController:loginVC animated:YES completion:^{
//    }];
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)registerClick:(UIButton *)sender {
    LYRegistrationViewController *registerVC = [[LYRegistrationViewController alloc]initWithNibName:@"LYRegistrationViewController" bundle:nil];
//    [self presentViewController:registerVC animated:YES completion:^{
//    }];
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)rambleClick:(UIButton *)sender {
}
@end
