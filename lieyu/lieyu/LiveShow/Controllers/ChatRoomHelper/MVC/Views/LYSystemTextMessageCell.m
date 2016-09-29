//
//  LYSystemTextMessageCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYSystemTextMessageCell.h"
#import "RCKitUtility.h"
#import "RCIM.h"
#import "RCKitCommonDefine.h"
#import "LYStystemMessage.h"

@interface LYSystemTextMessageCell ()

- (void)initialize;

@end

@implementation LYSystemTextMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [[UILabel alloc]init];
        //        self.tipMessageLabel.delegate = self;
//        self.messageLabel.userInteractionEnabled = YES;
        self.giftImageView = [[UIImageView alloc]init];
        [self.messageContentView addSubview:self.giftImageView];
        [self.messageContentView addSubview:self.messageLabel];
        self.messageLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self updateUI];
}

/**
 *  更新UI
 */
- (void)updateUI {
    [self.messageLabel setTextColor:RGB(147, 112, 219)];
    NSString *tiptext = @"直播消息：我们提倡绿色直播，封面和直播内容含吸烟、低俗、诱导、违规等内容都将会被封停帐号，网警24小时在线巡查呦。";
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:tiptext];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:18.0]
                          range:NSMakeRange(0, 4)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:RGB(227, 207, 87)
                          range:NSMakeRange(0, 4)];
    self.messageLabel.attributedText = attributedStr;
    CGSize __textSize = [LYSystemTextMessageCell getMessageCellSize:self.messageLabel.text  withWidth:300];
    
//    CGFloat __textHeight = __textSize.height;
//    CGFloat __textWidth = __textSize.width + 20 < 50 ? 50 : (__textSize.width + 20);
//    
//    CGFloat __bubbleHeight = __textHeight < 35 ? 35: (__textHeight);
//    CGFloat __bubbleWidth = __textWidth < 50 ? 50 : (__textWidth);
//    CGSize __bubbleSize = CGSizeMake(__bubbleWidth - 6, __bubbleHeight + 10);
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    messageContentViewRect.size.width = __textSize.width;
    messageContentViewRect.size.height = __textSize.height;
    self.messageContentView.frame = messageContentViewRect;
//    self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
    self.messageLabel.frame = CGRectMake(6,0, __textSize.width, __textSize.height);
    self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
//    [self.nicknameLabel setTextColor:COMMON_PURPLE];
    self.bubbleBackgroundView.layer.cornerRadius = 4;
}

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    float maxWidth = width-(10+[RCIM sharedRCIM].globalMessagePortraitSize.width+8);
    textSize = [LYSystemTextMessageCell getContentSize:content withFrontSize:16 withWidth:maxWidth];
    textSize.width = textSize.width + 20;
    textSize.height = textSize.height  + 15;
    return textSize;
}


@end
