//
//  LYtimeChooseTimeController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/18.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYtimeChooseTimeController.h"

@interface LYtimeChooseTimeController ()

@end

@implementation LYtimeChooseTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_type==1){
        [_datePicker setDatePickerMode:UIDatePickerModeTime];
    }
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
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

- (IBAction)sureAct:(id)sender {
    NSDate *dateTemp =self.datePicker.date;
    NSString *dateStr= [dateFormatter stringFromDate:dateTemp];
    [self.delegate changeDate:dateStr];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
