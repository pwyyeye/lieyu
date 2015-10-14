//
//  ZSMyShopsManageViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "WQCalendarLogic.h"
#import "WQDraggableCalendarView.h"
#import "WQScrollCalendarWrapperView.h"
#import "NeedHideNavigationBar.h"
@interface ZSMyShopsManageViewController : LYBaseViewController<NeedHideNavigationBar>{
    UIView  *_bgView;
    UIView  *monView;
    NSDateFormatter * dateFormatter;
    UIButton *surebutton;
    NSMutableArray *dataList;
    NSMutableArray *serchDataList;
    NSString *totolCount;
    int userId;
}
- (IBAction)backAct:(UIButton *)sender;
- (IBAction)titelChangeAct:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *titleSeq;
- (IBAction)addSomeAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;
@property (nonatomic, strong) WQDraggableCalendarView *calendarView;
@property (nonatomic, strong) WQCalendarLogic *calendarLogic;
- (IBAction)timeChooseAct:(UIButton *)sender;
@property (nonatomic, strong) UILabel *monthLabel;
@end
