//
//  OrderBottomView.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHandleButton.h"
@interface OrderBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *shaperLbl;
@property (weak, nonatomic) IBOutlet OrderHandleButton *duimaBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLal;
@property (weak, nonatomic) IBOutlet UILabel *timeOrCount;
@property (weak, nonatomic) IBOutlet UILabel *label_timeOrCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *label_zuju;
@property (weak, nonatomic) IBOutlet OrderHandleButton *btn_not;
@property (weak, nonatomic) IBOutlet UIView *viewBG;

@end
