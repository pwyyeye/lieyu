//
//  PinkerShareController.h
//  lieyu
//
//  Created by pwy on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"
#import "LYChooseFriendsController.h"
#import "OrderInfoModel.h"

@interface PinkerShareController : LYBaseViewController<LYChooseFriendsControllerDelegate,UITextViewDelegate>

//ui
@property (weak, nonatomic) IBOutlet UITextView *shareContent;
@property (weak, nonatomic) IBOutlet UIImageView *pinkerImageView;
@property (weak, nonatomic) IBOutlet UILabel *pinkerTitle;
@property (weak, nonatomic) IBOutlet UILabel *pinkerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinkerAddress;

@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *shareTypeBtn;
//属性
@property(assign,nonatomic) NSInteger orderid;
@property(strong,nonatomic) NSString  *sn;

@property(strong,nonatomic) OrderInfoModel *orderModel;
@property(assign,nonatomic) NSInteger shareType;
@property(assign,nonatomic) NSInteger allowSex;
@property(strong,nonatomic) NSString *shareUsers;

@property (strong, nonatomic)  UIView *heardView;
@property(strong,nonatomic) UIButton *addbtn;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeight;

- (IBAction)chooseShareType:(id)sender;

- (IBAction)doAllowSex:(id)sender;

@end
