//
//  BirthdayPickerView.m
//  lieyu
//
//  Created by 狼族 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BirthdayPickerView.h"

@implementation BirthdayPickerView
- (void)awakeFromNib{
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.tintColor = [UIColor purpleColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
