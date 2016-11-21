//
//  LYMyFriendDetailViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "CustomerModel.h"
@interface LYMyFriendDetailViewController : LYBaseViewController
//header
@property (weak, nonatomic) IBOutlet UIImageView *headerBGView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *userimageBtn;

@property (weak, nonatomic) IBOutlet UIButton *commitInformation;//编辑资料

@property (weak, nonatomic) IBOutlet UIButton *checkCollectButton;
@property (weak, nonatomic) IBOutlet UIImageView *careNumberImage;

@property (weak, nonatomic) IBOutlet UILabel *namelal;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLal;
@property (weak, nonatomic) IBOutlet UILabel *xingzuo;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *fansOrCaresLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansOrCaresNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhiwuWidth;
- (IBAction)backForward:(UIButton *)sender;
- (IBAction)checkFans:(UIButton *)sender;
- (IBAction)addCareof:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//预定
@property (weak, nonatomic) IBOutlet UIView *popularityView;
@property (weak, nonatomic) IBOutlet UILabel *popularityNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *freeBookButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineBookButton;
- (IBAction)checkPopularityClick:(UIButton *)sender;
- (IBAction)freeBookClick:(UIButton *)sender;
- (IBAction)onlineBookClick:(UIButton *)sender;

//认证
@property (weak, nonatomic) IBOutlet UIView *qualificationView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *identification_buttons;

@property (weak, nonatomic) IBOutlet UILabel *barnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBarName;
@property (weak, nonatomic) IBOutlet UIButton *checkBarAddress;
@property (weak, nonatomic) IBOutlet UIImageView *bigBarImage;
@property (weak, nonatomic) IBOutlet UIImageView *bigAddressImage;

//动态

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DTViewTop;
@property (weak, nonatomic) IBOutlet UIView *DTView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *advanceImage;
- (IBAction)checkTrends:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkTrendsBtn;

//直播列表
@property (weak, nonatomic) IBOutlet UIButton *zhiboButton;

@property (weak, nonatomic) IBOutlet UIView *LIVEView;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView_2;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView_3;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView_4;
@property (weak, nonatomic) IBOutlet UIImageView *advangeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBgLabelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *setBgLabel;

//聊天
- (IBAction)sendMessageAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *chatRoomButton;


@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIView *setBG;

//关注
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
//拉黑
@property (weak, nonatomic) IBOutlet UIButton *setBlackButton;

@property (retain, nonatomic)  CustomerModel *customerModel;
@property (copy, nonatomic)  NSString *type;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *imUserId;

@property (assign, nonatomic) NSInteger isChatroom;
@end
