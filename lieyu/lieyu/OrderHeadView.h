//
//  OrderHeadView.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLal;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLal;
@property (weak, nonatomic) IBOutlet UILabel *label_orderType;

@property (weak, nonatomic) IBOutlet UIImageView *orderTypeView;
@property (weak, nonatomic) IBOutlet UIImageView *userImgeView;

@property (weak, nonatomic) IBOutlet UIImageView *orderStuImageView;
@property (weak, nonatomic) IBOutlet UILabel *detLal;

@end
