//
//  LYHomeSearcherViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeSearcherViewController.h"

@interface LYHomeSearcherViewController ()

@end

@implementation LYHomeSearcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHistoryBtn];//设置历史按钮
}
- (void)setHistoryBtn{
    for (UIButton *button in _btnHistoryArray) {
        button.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
        button.layer.cornerRadius = 1.8;
        button.layer.masksToBounds = YES;
        [button setTitle:@"某某酒吧" forState:UIControlStateNormal];
    }
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
