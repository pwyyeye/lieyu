//
//  OrderBottomForLWView.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHandleButton.h"
@interface OrderBottomForLWView : UIView
@property (weak, nonatomic) IBOutlet OrderHandleButton *kazuoBtn;
@property (weak, nonatomic) IBOutlet OrderHandleButton *siliaoBtn;
@property (weak, nonatomic) IBOutlet OrderHandleButton *dianhuaBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLal;
@end
