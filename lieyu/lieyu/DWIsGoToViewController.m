//
//  DWIsGoToViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWIsGoToViewController.h"

@interface DWIsGoToViewController ()

@end

@implementation DWIsGoToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)checkAct:(UIButton *)sender {
    if(sender.tag==0){
        _goBtn.selected=YES;
        _noGoBtn.selected=false;
    }else{
        _goBtn.selected=false;
        _noGoBtn.selected=YES;
    }
}

- (IBAction)sureAct:(UIButton *)sender {
    NSString *ss=@"0";
    if(_goBtn.selected){
        ss=@"1";
    }
    [self.delegate changeType:ss];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
