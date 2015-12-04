//
//  TimePickerView.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TimePickerView.h"

@implementation TimePickerView

- (void)awakeFromNib{
    self.timePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.timePicker.minimumDate = [NSDate date];
    self.timePicker.tintColor = [UIColor purpleColor];
}

- (void)showTimeWithDate:(NSDate *)date{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yy年MM月dd日 EEEE HH:mm"];
//    NSDate *date = [formatter dateFromString:string];
//    self.timePicker.date = date;
    [self.timePicker setDate:date animated:YES];
}

@end
