//
//  TimePickerView.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

- (void)showTimeWithDate:(NSDate *)date;

@end
