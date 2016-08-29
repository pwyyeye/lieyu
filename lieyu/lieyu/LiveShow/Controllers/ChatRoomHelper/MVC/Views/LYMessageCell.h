//
//  LYMessageCell.h
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "RCMessageBaseCell.h"
#import "RCMessageCellNotificationModel.h"
#import "RCMessageCellDelegate.h"
#import "RCContentView.h"
//#define PORTRAIT_WIDTH 45
//#define PORTRAIT_HEIGHT 45

@class RCloudImageView;

@interface LYMessageCell : RCMessageBaseCell

/*!
 消息发送者的用户名称
 */
@property(nonatomic, strong) UILabel *nicknameLabel;

/*!
 消息内容的View
 */
@property(nonatomic, strong) RCContentView *messageContentView;

/*!
 消息的背景View
 */
@property(nonatomic, strong) RCContentView *bubbleBackgroundView;
/*!
 显示发送状态的View
 
 @discussion 其中包含messageFailedStatusView子View。
 */
@property(nonatomic, strong) UIView *statusContentView;

/*!
 显示发送失败状态的View
 */
@property(nonatomic, strong) UIButton *messageFailedStatusView;

/*!
 消息发送指示View
 */
@property(nonatomic, strong) UIActivityIndicatorView *messageActivityIndicatorView;

/*!
 消息内容的View的宽度
 */
@property(nonatomic, readonly) CGFloat messageContentViewWidth;

/*!
 是否显示用户名称
 */
@property(nonatomic, readonly) BOOL isDisplayNickname;

/*!
 显示消息已阅读状态的View
 */
@property(nonatomic, strong) UIView *messageHasReadStatusView;

/*!
 显示消息发送成功状态的View
 */
@property(nonatomic, strong) UIView *messageSendSuccessStatusView;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

/*!
 更新消息发送状态
 
 @param model 消息Cell的数据模型
 */
- (void)updateStatusContentView:(RCMessageModel *)model;

/*!
 获取文本的尺寸
 
 @param content             文本内容
 @param fontSize            字体大小
 @param width               最大宽度
 @return                    占用的大小
 */
+ (CGSize)getContentSize:(NSString *)content withFrontSize:(int)fontSize withWidth:(CGFloat)width;

@end
