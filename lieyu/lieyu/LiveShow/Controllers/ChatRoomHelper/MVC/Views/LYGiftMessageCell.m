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
    
    NSString *tiptext = @"";
    switch (_likeMessage.type.integerValue) {
        case 0:
            tiptext = @"赞";
            break;
        case 1:
            tiptext = @"赞";
            break;
        case 2:
            tiptext = @"赞";
            break;
        case 3:
            tiptext = @"赞";
            break;
        case 4:
            tiptext = @"赞";
            break;
        case 5:
            tiptext = @"赞";
            break;
        default:
            break;
    }
    if (_likeMessage) {
        if(_likeMessage.senderUserInfo){
            if ([_likeMessage.senderUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                self.messageLabel.text = [NSString stringWithFormat:@"你送出一个%@", tiptext];
            }else{
                self.messageLabel.text = [NSString stringWithFormat:@"%@送出一个%@",_likeMessage.senderUserInfo.name,tiptext];
            }
        }else{
            self.nicknameLabel.text = @"神秘人";
            self.messageLabel.text = [NSString stringWithFormat:@"神秘人送出一个%@", tiptext];
        }
    }
    CGSize __textSize = [LYGiftMessageCell getMessageCellSize:self.messageLabel.text  withWidth:self.baseContentView.bounds.size.width];
    
    if (self.model.content.senderUserInfo) {
        CGSize __nameSize = [LYGiftMessageCell getContentSize:self.model.content.senderUserInfo.name withFrontSize:16 withWidth:self.baseContentView.bounds.size.width];
        __nameSize.width = __nameSize.width + 5;
        if (__nameSize.width > __textSize.width) {
            __textSize.width = __nameSize.width;
        }
        CGRect nameLabelRect = self.nicknameLabel.frame;
        nameLabelRect.size.width = __nameSize.width;
        nameLabelRect.size.height = __nameSize.height;
        self.nicknameLabel.frame = nameLabelRect;
    }
    
    CGFloat __textHeight = __textSize.height;
    CGFloat __textWidth = __textSize.width + 20 < 50 ? 50 : (__textSize.width + 20);
    
    CGFloat __bubbleHeight = __textHeight < 35 ? 35: (__textHeight);
    CGFloat __bubbleWidth = __textWidth < 50 ? 50 : (__textWidth);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth - 6, __bubbleHeight + 10);
    CGRect messageContentViewRect = self.messageContentView.frame;
    messageContentViewRect.size.width = __textSize.width;
    messageContentViewRect.size.height = __textSize.height;
    self.messageContentView.frame = messageContentViewRect;
    self.bubbleBackgroundView.frame = CGRectMake(6, 0, __bubbleSize.width, __bubbleSize.height);
    self.messageLabel.frame = CGRectMake(10,10, __textSize.width, __textSize.height);
    self.bubbleBackgroundView.backgroundColor = HEXCOLOR(0x61a1ff);
    [self.messageLabel setTextColor:HEXCOLOR(0xffffff)];
    
//    if (!_isFullScreenMode) {
//        self.bubbleBackgroundView.alpha = 1;
//        self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
//        [self.messageLabel setTextColor:[UIColor blackColor]];
//        if (self.messageDirection == MessageDirection_RECEIVE) {
//            [self.nicknameLabel setTextColor:HEXCOLOR(0x999999)];
//        }else{
//            [self.nicknameLabel setTextColor:HEXCOLOR(0x62e0ff)];
//        }
//        
//    }else{
//        self.bubbleBackgroundView.alpha = 0.7;
//        self.bubbleBackgroundView.backgroundColor = HEXCOLOR(0x61a1ff);
    self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
        [self.messageLabel setTextColor:[UIColor whiteColor]];
        if (MessageDirection_RECEIVE == self.messageDirection) {
            [self.nicknameLabel setTextColor:HEXCOLOR(0xe2e2e2)];
        }else{
            [self.nicknameLabel setTextColor:HEXCOLOR(0x62e0ff)];
        }
        
//    }
    
//    self.giftImageView.frame = CGRectMake(self.messageLabel.frame.size.width - 4,20, 20, 20);
//    if ([_likeMessage.type isEqualToString:@"0"]) {
//        self.giftImageView.image = [UIImage imageNamed:@"flower"];
//    }else{
//        self.giftImageView.image = [UIImage imageNamed:@"clap"];
//    }
    self.bubbleBackgroundView.layer.cornerRadius = 4;
}

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    float maxWidth = width-(10+[RCIM sharedRCIM].globalMessagePortraitSize.width+8)*2-28;
    textSize = [LYGiftMessageCell getContentSize:content withFrontSize:16 withWidth:maxWidth];
    textSize.width = textSize.width + 24 ;//加上礼物的宽度
    textSize.height = textSize.height + 17;
    return textSize;
}

@end
