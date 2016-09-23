//
//  LYSystemTextMessageCell.h
//  lieyu
//
//  Created by 狼族 on 16/9/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMessageCell.h"
#import "RCAttributedLabel.h"


#define Text_Message_Font_Size 16
@interface LYSystemTextMessageCell : LYMessageCell

/*!
 提示的Label
 */
@property(strong, nonatomic) UILabel *messageLabel;
@property(strong, nonatomic) UIImageView *giftImageView;

@property(assign, nonatomic) BOOL isFullScreenMode;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width;

@end
