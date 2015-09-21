//
//  TimeChooseTwoViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TimeChooseTwoViewController.h"

@interface TimeChooseTwoViewController ()

@end

@implementation TimeChooseTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.fromTimeLal.text=dateStr;
    self.toTimeLal.text=dateStr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)DateValChange:(UIDatePicker *)sender {
    NSString *dateStr= [dateFormatter stringFromDate:sender.date];
    if(sender.tag==1){
        self.fromTimeLal.text=dateStr;
    }else{
        self.toTimeLal.text=dateStr;
    }
}

- (IBAction)sureAct:(UIButton *)sender {
    NSDictionary *dic=@{@"fromTime":self.fromTimeLal.text,@"toTime":self.toTimeLal.text};
    [self.delegate changetime:dic];
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
