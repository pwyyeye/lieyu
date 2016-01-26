//
//  ChooseTime.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseTime.h"

@implementation ChooseTime

- (void)awakeFromNib{
    self.timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.timePicker.tintColor = [UIColor purpleColor];
    
}

- (void)showTimeWithTime:(NSDate *)date{
    [self.timePicker setDate:date animated:YES];
}

- (void)configure{
//    self.timePicker.minimumDate = self.minDate;
//    self.timePicker.maximumDate = self.maxDate;
}
@end
