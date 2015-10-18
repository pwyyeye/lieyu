//
//  LYtimeChooseTimeController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/18.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol DateChooseDelegate
@optional
-(void)changeDate:(NSString *)timeStr;
@end
@interface LYtimeChooseTimeController : LYBaseViewController{
    NSDateFormatter * dateFormatter;
}
- (IBAction)sureAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,weak)id<DateChooseDelegate>delegate;
@end
