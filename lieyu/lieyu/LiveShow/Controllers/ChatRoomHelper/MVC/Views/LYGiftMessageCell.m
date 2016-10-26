//
//  LYGiftMessageCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGiftMessageCell.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import "LYGiftMessage.h"
#import "RCIM.h"

@implementation LYGiftMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [[UILabel alloc]init];
        //        self.tipMessageLabel.delegate = self;
        self.messageLabel.userInteractionEnabled = YES;
        self.giftImageView = [[UIImageView alloc]init];
        [self.messageContentView addSubview:self.giftImageView];
        [self.messageContentView addSubview:self.messageLabel];
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
    
    LYGiftMessage *_likeMessage = (LYGiftMessage *)self.model.content;
    NSString *tiptext = _likeMessage.content;
    if (_likeMessage) {
        if(_likeMessage.senderUserInfo){
            if ([_likeMessage.senderUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                self.messageLabel.text = [NSString stringWithFormat:@"%@：%@",_likeMessage.senderUserInfo.name, tiptext];
            } else {
                self.messageLabel.text = [NSString stringWithFormat:@"%@：%@",_likeMessage.senderUserInfo.name,tiptext];
            }
            if (_likeMessage.type.integerValue == 2) {//赞
                [self.messageLabel setTextColor:RGB(37, 235, 255)];
                self.messageLabel.shadowColor = RGBA(150, 150, 150, .5);
                self.messageLabel.shadowOffset =CGSizeMake(.5,.5);
                NSString *dianzanStr = [NSString stringWithFormat:@"%@：给你点赞",_likeMessage.senderUserInfo.name];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:dianzanStr];
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(227, 207, 87) range:NSMakeRange(0, self.model.content.senderUserInfo.name.length + 1)];
                self.messageLabel.attributedText = AttributedStr;
            } else {
                [self.messageLabel setTextColor:RGB(240, 26, 105)];
                self.messageLabel.shadowColor = RGBA(150, 150, 150, .5);
                self.messageLabel.shadowOffset =CGSizeMake(.5,.5);
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.messageLabel.text];
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(227, 207, 87) range:NSMakeRange(0, self.model.content.senderUserInfo.name.length + 1)];
                self.messageLabel.attributedText = AttributedStr;
            }
        }else{
            self.messageLabel.text = [NSString stringWithFormat:@"神秘人赠送了一个%@", tiptext];
            
            //what are you thinking?
        }
    }
    CGSize __textSize = [LYGiftMessageCell getMessageCellSize:self.messageLabel.text  withWidth:self.baseContentView.bounds.size.width];
    
//    if (self.model.content.senderUserInfo) {
//        CGSize __nameSize = [LYGiftMessageCell getContentSize:self.model.content.senderUserInfo.name withFrontSize:16 withWidth:self.baseContentView.bounds.size.width];
//        __nameSize.width = __nameSize.width + 5;
//        if (__nameSize.width > __textSize.width) {
//            __textSize.width = __nameSize.width;
//        }
//        CGRect nameLabelRect = self.nicknameLabel.frame;
//        nameLabelRect.size.width = __nameSize.width;
//        nameLabelRect.size.height = __nameSize.height;
//        self.nicknameLabel.frame = nameLabelRect;
//    }
    [self.nicknameLabel  removeFromSuperview];
    self.nicknameLabel = nil;
    
    CGFloat __textHeight = __textSize.height;
    CGFloat __textWidth = __textSize.width + 20 < 50 ? 50 : (__textSize.width + 20);
    
    CGFloat __bubbleHeight = __textHeight < 35 ? 35: (__textHeight);
    CGFloat __bubbleWidth = __textWidth < 50 ? 50 : (__textWidth);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth - 6, __bubbleHeight);
    CGRect messageContentViewRect = self.messageContentView.frame;
    messageContentViewRect.size.width = __textSize.width;
    messageContentViewRect.size.height = __textSize.height;
    self.messageContentView.frame = messageContentViewRect;
    self.bubbleBackgroundView.frame = CGRectMake(6, 0, __bubbleSize.width, __bubbleSize.height);
    self.messageLabel.frame = CGRectMake(0,0, __textSize.width, __textSize.height);
    self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
    self.bubbleBackgroundView.layer.cornerRadius = 4;
}

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    float maxWidth = width-(10+[RCIM sharedRCIM].globalMessagePortraitSize.width+8);
    textSize = [LYGiftMessageCell getContentSize:content withFrontSize:16 withWidth:maxWidth];
    textSize.width = textSize.width + 24 ;//加上礼物的宽度
    textSize.height = textSize.height + 1;
    return textSize;
}

@end
