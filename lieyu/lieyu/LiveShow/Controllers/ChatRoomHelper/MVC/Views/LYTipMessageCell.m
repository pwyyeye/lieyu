//
//  LYTipMessageCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTipMessageCell.h"
#import "RCTipLabel.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import "LYTextMessageCell.h"
#import "RCIM.h"


@interface LYTipMessageCell ()<RCAttributedLabelDelegate>
@end
@implementation LYTipMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [[UILabel alloc] init];
        [self.baseContentView addSubview:self.tipMessageLabel];
//        self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
    }
    return self;
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    RCMessageContent *content = model.content;
    if ([content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)content;
        NSString *localizedMessage = [RCKitUtility formatMessage:notification];
        [self.tipMessageLabel setTextColor:RGB(0, 199, 140)];
        self.tipMessageLabel.shadowColor = [UIColor darkGrayColor];
        self.tipMessageLabel.shadowOffset =CGSizeMake(1,1);
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:localizedMessage];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(227, 207, 87) range:NSMakeRange(0, self.model.content.senderUserInfo.name.length + 1)];
        self.tipMessageLabel.attributedText = AttributedStr;
    }
    
    NSString *__text = self.tipMessageLabel.text;
    CGSize __labelSize = [LYTipMessageCell getTipMessageCellSize:__text];
        self.tipMessageLabel.frame = CGRectMake(6,0, __labelSize.width, __labelSize.height);
        self.tipMessageLabel.backgroundColor = [UIColor clearColor];
}

//- (void)attributedLabel:(RCAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
//{
//    NSString *urlString=[url absoluteString];
//    if (![urlString hasPrefix:@"http"]) {
//        urlString = [@"http://" stringByAppendingString:urlString];
//    }
//    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
//        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
//        return;
//    }
//}

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
//- (void)attributedLabel:(RCAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
//{
//    
//}

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
//- (void)attributedLabel:(RCAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
//{
//    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
//    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
//        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
//        return;
//    }
//}

//-(void)attributedLabel:(RCAttributedLabel *)label didTapLabel:(NSString *)content
//{
//    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
//        [self.delegate didTapMessageCell:self.model];
//    }
//}

+ (CGSize)getTipMessageCellSize:(NSString *)content{
    CGFloat maxMessageLabelWidth = [UIScreen mainScreen].bounds.size.width - 30 * 2;
    CGSize __textSize = CGSizeZero;
    if (IOS_FSystenVersion < 7.0) {
        __textSize = RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:16], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    } else {
        __textSize = RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:16], CGSizeMake(maxMessageLabelWidth, MAXFLOAT));
    }
    __textSize = CGSizeMake(ceilf(__textSize.width) + 30, ceilf(__textSize.height));
    return __textSize;
}

@end
