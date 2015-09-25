//
//  LYZSApplicationViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYZSApplicationViewController.h"
#import "LyZSuploadIdCardViewController.h"
#import "LYChooseJiuBaViewController.h"
@interface LYZSApplicationViewController ()

@end

@implementation LYZSApplicationViewController

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
#pragma mark - 选择酒吧
- (IBAction)chooseJiuBaAct:(UIButton *)sender {
    LYChooseJiuBaViewController *chooseJiuBaViewController=[[LYChooseJiuBaViewController alloc]initWithNibName:@"LYChooseJiuBaViewController" bundle:nil];
    chooseJiuBaViewController.title=@"选择酒吧";
    [self.navigationController pushViewController:chooseJiuBaViewController animated:YES];
}
#pragma mark - 下一步
- (IBAction)nextAct:(UIButton *)sender {
//   [self.view makeToast:@"This is a piece of toast."];
    LyZSuploadIdCardViewController *suploadIdCardViewController=[[LyZSuploadIdCardViewController alloc]initWithNibName:@"LyZSuploadIdCardViewController" bundle:nil];
    suploadIdCardViewController.title=@"上传身份证";
    [self.navigationController pushViewController:suploadIdCardViewController animated:YES];
}
@end
