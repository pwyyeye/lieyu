//
//  ChooseTime.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTime : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

- (void)configure;
@end