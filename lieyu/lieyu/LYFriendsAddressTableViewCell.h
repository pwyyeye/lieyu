//
//  LYFriendsAddressTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_address;

@property (weak, nonatomic) IBOutlet UIImageView *imgView_location;

@property (weak, nonatomic) IBOutlet UIImageView *dashangImageView;
@property (weak, nonatomic) IBOutlet UILabel *dashangLabel;

@property (nonatomic,strong) FriendsRecentModel *recentM;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreViewWidth;

@property (weak, nonatomic) IBOutlet UIButton *dianpingButton;

@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property (weak, nonatomic) IBOutlet UIButton *btn_comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_dashang;
@property (assign, nonatomic) BOOL isShow;

@property (weak, nonatomic) IBOutlet UIView *moreView;

@end
