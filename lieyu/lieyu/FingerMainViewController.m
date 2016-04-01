//
//  FingerMainViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FingerMainViewController.h"
#import "FingerPlayViewController.h"
#import "FingerAnalyseViewController.h"

@interface FingerMainViewController ()

@end

@implementation FingerMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToPlay:(id)sender {
    FingerPlayViewController *fingerPlayVC = [[FingerPlayViewController alloc]init];
    [self.navigationController pushViewController:fingerPlayVC animated:YES];
}
- (IBAction)goBack:(id)sender {
    
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
