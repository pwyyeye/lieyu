//
//  TimeChooseTwoViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol TimeChooseDelegate
@optional
-(void)changetime:(NSDictionary *)timeDic;
@end
@interface TimeChooseTwoViewController : LYBaseViewController{
    NSDateFormatter * dateFormatter;
}
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLal;
@property (weak, nonatomic) IBOutlet UIDatePicker *fromDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLal;
@property (weak, nonatomic) IBOutlet UIDatePicker *toDatePicker;
@property (nonatomic,assign)id<TimeChooseDelegate>delegate;
- (IBAction)DateValChange:(UIDatePicker *)sender;
- (IBAction)sureAct:(UIButton *)sender;

@end
