//
//  LiveShowEndView.h
//  lieyu
//
//  Created by 狼族 on 16/8/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveShowEndView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatmonentButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;

@property (weak, nonatomic) IBOutlet UIButton *momoButton;


@property (weak, nonatomic) IBOutlet UIButton *focusButton;


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) NSString *chatRoomID;//直播间id
@property (nonatomic, strong) UIImage *shareImage;//分享的图片
@property (nonatomic, strong) NSString *shareName;


@end
