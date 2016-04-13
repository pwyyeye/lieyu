//
//  LPOrdersFooterCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
@protocol LPOrdersFootDelegate<NSObject>
- (void)shareZujuOrder:(UIButton *)button;//立即组局
- (void)deleteOrder:(UIButton *)button;//删除订单［我的订单］
- (void)payForOrder:(UIButton *)button;//立即支付，立即付款
- (void)checkForDetail:(UIButton *)button;//查看详情
- (void)cancelOrder:(UIButton *)button;//取消组局、取消订单
- (void)JudgeForOrder:(UIButton *)button;//立即评价
- (void)deleteSelfOrder:(UIButton *)button;//删除［他人］
@end

@interface LPOrdersFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backGround;
@property (weak, nonatomic) IBOutlet UILabel *shaperLbl;
@property (weak, nonatomic) IBOutlet UILabel *acturePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitLbl;
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (weak, nonatomic) IBOutlet UILabel *oliverLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (nonatomic, assign) id<LPOrdersFootDelegate> delegate;

@property (nonatomic, strong) OrderInfoModel *model;
@property (nonatomic, assign) BOOL detail;

@end
