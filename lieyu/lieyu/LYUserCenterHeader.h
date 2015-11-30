//
//  LYUserCenterHeader.h
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYUserCenterHeader : UICollectionReusableView
//顶部带背景view
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Heght;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatar_img;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *userNick;
//年龄
@property (weak, nonatomic) IBOutlet UIButton *age;
//标签
@property (weak, nonatomic) IBOutlet UIButton *tags;

//设置
- (IBAction)gotoSetting:(id)sender;
//消息中心
- (IBAction)gotoMessageList:(id)sender;
//查看全部订单
- (IBAction)gotoOrderList:(id)sender;
//待付款
- (IBAction)gotoWaitPayOrderList:(id)sender;
//待消费
- (IBAction)gotoWaitConsumptionOrderList:(id)sender;
//待返利
- (IBAction)gotoWaitRebateOrderList:(id)sender;
//待评价
- (IBAction)gotoWaitEvaluationOrderList:(id)sender;
//待退款
- (IBAction)gotoWaitPayBackOrderList:(id)sender;


@end
