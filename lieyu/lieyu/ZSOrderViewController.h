//
//  ZSOrderViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "WQCalendarLogic.h"
#import "WQDraggableCalendarView.h"
#import "WQScrollCalendarWrapperView.h"

@interface ZSOrderViewController : LYBaseViewController{
    UIView  *_bgView;
    UIView  *monView;
    NSDateFormatter * dateFormatter;
    UIButton *surebutton;
}
@property (nonatomic, strong) WQDraggableCalendarView *calendarView;
@property (nonatomic, strong) WQCalendarLogic *calendarLogic;

@property (nonatomic, strong) WQScrollCalendarWrapperView *scrollCalendarView;
- (IBAction)backAct:(UIButton *)sender;
- (IBAction)timeChooseAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;
@property (weak, nonatomic) IBOutlet UIButton *xialaBtn;
@property (nonatomic, strong) UILabel *monthLabel;

@end
