//
//  LYUserCenterHeader.h
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTTL.h"
#import "MineMenuButton.h"
@interface LYUserCenterHeader : UICollectionReusableView<CAAnimationDelegate>
//顶部带背景view
@property (nonatomic, assign) int badgeNum;
@property (nonatomic, strong) NSMutableArray *badgesArray;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Heght;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatar_img;
@property (weak, nonatomic) IBOutlet UIButton *avatar_btn;
@property (weak, nonatomic) IBOutlet UIButton *xingzuo;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *userNick;
//年龄
@property (weak, nonatomic) IBOutlet UIButton *age;
//标签
@property (weak, nonatomic) IBOutlet UIButton *tags;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_ageConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_tagConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_xingzuoConstrant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnChange_cons_width;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;

@property (weak, nonatomic) IBOutlet UIButton *label_waitPay_badge;
/**五个订单状态按钮*/

@property (weak, nonatomic) IBOutlet UIButton *waitPay;

@property (weak, nonatomic) IBOutlet UIButton *waitConsumption;

@property (weak, nonatomic) IBOutlet UIButton *waitRebate;

@property (weak, nonatomic) IBOutlet UIButton *waitEvaluation;

@property (weak, nonatomic) IBOutlet UIButton *waitPayBack;


@property (weak, nonatomic) IBOutlet UIImageView *img_bg;
@property (weak, nonatomic) IBOutlet UIImageView *img_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_sex;
@property (weak, nonatomic) IBOutlet UILabel *label_constellation;
@property (weak, nonatomic) IBOutlet UILabel *label_work;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property (weak, nonatomic) IBOutlet UILabel *beCareNumber;
@property (weak, nonatomic) IBOutlet UIImageView *careTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *TypeName;

@property (weak, nonatomic) IBOutlet UIImageView *beCareType_ly_Image;

@property (weak, nonatomic) IBOutlet UILabel *beCareType_ly_Name;

@property (weak, nonatomic) IBOutlet UILabel *beCare_ly_Number;

@property (weak, nonatomic) IBOutlet UIButton *beCare_ly_button;
@property (weak, nonatomic) IBOutlet UIButton *caresButton;
@property (weak, nonatomic) IBOutlet UIButton *businessButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttomHeight;
- (IBAction)checkFansOrCares:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet MineMenuButton *firstMenuButton;
@property (weak, nonatomic) IBOutlet MineMenuButton *secondMenuButton;
@property (weak, nonatomic) IBOutlet MineMenuButton *thirdMenuButton;
@property (weak, nonatomic) IBOutlet MineMenuButton *forthMenuButton;

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

//load角标
-(void)loadBadge:(OrderTTL *)orderTTL;

#pragma mark - 按钮事件
- (IBAction)notificationCenterClick:(UIButton *)sender;
- (IBAction)businessCenterClick:(UIButton *)sender;
- (IBAction)QRCodeClick:(MineMenuButton *)sender;
- (IBAction)MineMoneyBagClick:(MineMenuButton *)sender;
- (IBAction)MineGroupClick:(MineMenuButton *)sender;
- (IBAction)MineApplyClick:(MineMenuButton *)sender;


@end
