//
//  YaoSettingViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/30.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "YaoSettingViewController.h"
#import "YaoHisListViewController.h"
@interface YaoSettingViewController ()

@end

@implementation YaoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *isSound=[USER_DEFAULT objectForKey:@"yaoSound"];

    if([MyUtil isEmptyString:isSound]){
        [_soundSwitch setOn:YES];
    }else{
        if([isSound isEqualToString:@"YES"]){
            [_soundSwitch setOn:YES];
        }else{
            [_soundSwitch setOn:false];
        }
    }

    
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

- (IBAction)settingAct:(UISwitch *)sender {
    if(_soundSwitch.on){
        [USER_DEFAULT setObject:@"YES" forKey:@"yaoSound"];
    }else{
        [USER_DEFAULT setObject:@"NO" forKey:@"yaoSound"];
    }
    
}
- (IBAction)hisAct:(UIButton *)sender {
    YaoHisListViewController *hisListViewController=[[YaoHisListViewController alloc]initWithNibName:@"YaoHisListViewController" bundle:nil];
    hisListViewController.title=@"摇到的历史";

    [self.navigationController pushViewController:hisListViewController animated:YES];
}
@end
