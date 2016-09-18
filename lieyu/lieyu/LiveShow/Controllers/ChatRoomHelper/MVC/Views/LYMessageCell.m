//
//  LYMessageCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMessageCell.h"
#import "RCKitUtility.h"
#import "RCTipLabel.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import "RCIM.h"

@interface LYMessageCell ()
//- (void) configure;
- (void)setCellAutoLayout;

@end
@implementation LYMessageCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupMessageCellView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMessageCellView];
    }
    return self;
}
- (void)setupMessageCellView
{
    _isDisplayNickname = NO;
    self.delegate = nil;
    self.messageContentView = [[RCContentView alloc] initWithFrame:CGRectZero];
    self.statusContentView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.nicknameLabel.backgroundColor = [UIColor clearColor];
//    [self.nicknameLabel setFont:[UIFont systemFontOfSize:16]];
    //    [self.nicknameLabel setTextColor:HEXCOLOR(0xe2e2e2)];
    self.bubbleBackgroundView = [[RCContentView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView addSubview:self.messageContentView];
//    [self.baseContentView addSubview:self.statusContentView];
//    [self.bubbleBackgroundView addSubview:self.nicknameLabel];
    [self.baseContentView addSubview:self.bubbleBackgroundView];
    
//    self.statusContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    _statusContentView.backgroundColor = [UIColor clearColor];
//    [self.baseContentView addSubview:_statusContentView];
    
    __weak typeof(&*self) __blockself = self;
    [self.bubbleBackgroundView registerFrameChangedEvent:^(CGRect frame) {
        if (__blockself.model) {
            if (__blockself.model.messageDirection == MessageDirection_SEND) {
                __blockself.statusContentView.frame = CGRectMake(
                                                                 frame.size.width +10 , frame.origin.y + (frame.size.height - 25) / 2.0f, 25, 25);
            } else {
                __blockself.statusContentView.frame = CGRectZero;
            }
        }
        
    }];
    
    self.messageFailedStatusView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_messageFailedStatusView
     setImage:[RCKitUtility imageNamed:@"message_send_fail_status" ofBundle:@"RongCloud.bundle"]
     forState:UIControlStateNormal];
    [self.statusContentView addSubview:_messageFailedStatusView];
    _messageFailedStatusView.hidden = YES;
    [_messageFailedStatusView addTarget:self
                                 action:@selector(didclickMsgFailedView:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    self.messageActivityIndicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.statusContentView addSubview:_messageActivityIndicatorView];
    _messageActivityIndicatorView.hidden = YES;
    
}
//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//
//}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    self.nicknameLabel.text = @"";
    self.messageSendSuccessStatusView.hidden = YES;
    self.messageHasReadStatusView.hidden = YES;
    
    _isDisplayNickname = model.isDisplayNickname;
    if(model.content.senderUserInfo)
    {
        model.userInfo = model.content.senderUserInfo;
        //        [self.portraitImageView setImageURL:[NSURL URLWithString:model.content.senderUserInfo.portraitUri]];
        [self.nicknameLabel setText:[NSString stringWithFormat:@"%@:" ,model.content.senderUserInfo.name]];
    }
    [self setCellAutoLayout];
}
- (void)setCellAutoLayout {
    
    _messageContentViewWidth = 200;
    // receiver
    CGFloat messageContentViewY = 0;
    CGFloat messageContentViewX = 6;
    self.nicknameLabel.frame = CGRectMake(messageContentViewX ,2, 200, 17);
    self.messageContentView.frame = CGRectMake(0,messageContentViewY,0,0);
    [self updateStatusContentView:self.model];
}

- (void)updateStatusContentView:(RCMessageModel *)model {
    self.messageSendSuccessStatusView.hidden = YES;
    self.messageHasReadStatusView.hidden = YES;
    if (model.messageDirection == MessageDirection_RECEIVE) {
        self.statusContentView.hidden = YES;
        return;
    } else {
        self.statusContentView.hidden = NO;
    }
    __weak typeof(&*self) __blockSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (__blockSelf.model.sentStatus == SentStatus_SENDING) {
            __blockSelf.messageFailedStatusView.hidden = YES;
            __blockSelf.messageHasReadStatusView.hidden = YES;
            __blockSelf.messageSendSuccessStatusView.hidden = YES;
            if (__blockSelf.messageActivityIndicatorView) {
                __blockSelf.messageActivityIndicatorView.hidden = NO;
                if (__blockSelf.messageActivityIndicatorView.isAnimating == NO) {
                    [__blockSelf.messageActivityIndicatorView startAnimating];
                }
            }
            
        } else if (__blockSelf.model.sentStatus == SentStatus_FAILED) {
            __blockSelf.messageFailedStatusView.hidden = NO;
            __blockSelf.messageHasReadStatusView.hidden = YES;
            __blockSelf.messageSendSuccessStatusView.hidden = YES;
            if (__blockSelf.messageActivityIndicatorView) {
                __blockSelf.messageActivityIndicatorView.hidden = YES;
                if (__blockSelf.messageActivityIndicatorView.isAnimating == YES) {
                    [__blockSelf.messageActivityIndicatorView stopAnimating];
                }
            }
        } else if (__blockSelf.model.sentStatus == SentStatus_SENT) {
            __blockSelf.messageFailedStatusView.hidden = YES;
            if (__blockSelf.messageActivityIndicatorView) {
                __blockSelf.messageActivityIndicatorView.hidden = YES;
                if (__blockSelf.messageActivityIndicatorView.isAnimating == YES) {
                    [__blockSelf.messageActivityIndicatorView stopAnimating];
                }
            }
        }
    });
}

#pragma mark private
//- (void)tapUserPortaitEvent:(UIGestureRecognizer *)gestureRecognizer {
//    __weak typeof(&*self) weakSelf = self;
//    if ([self.delegate respondsToSelector:@selector(didTapCellPortrait:)]) {
//        [self.delegate didTapCellPortrait:weakSelf.model.senderUserId];
//    }
//}
//
//- (void)longPressUserPortaitEvent:(UIGestureRecognizer *)gestureRecognizer {
//    __weak typeof(&*self) weakSelf = self;
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        if ([self.delegate respondsToSelector:@selector(didLongPressCellPortrait:)]) {
//            [self.delegate didLongPressCellPortrait:weakSelf.model.senderUserId];
//        }
//    }
//}
//-(void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
//        [self.delegate didTapMessageCell:self.model];
//    }
//}

// resend event
//- (void)msgStatusViewTapEventHandler:(id)sender
//{
//    //DebugLog(@"%s", __FUNCTION__);
//
//    //resend the failed message.
//    if ([self.delegate respondsToSelector:@selector(didTapMsgStatusViewForResending:)]) {
//        [self.delegate didTapMsgStatusViewForResending:self.model];
//    }
//
//}
- (void)imageMessageSendProgressing:(NSInteger)progress {
}
- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification {
    
    RCMessageCellNotificationModel *notifyModel = notification.object;
    
    if (self.model.messageId == notifyModel.messageId) {
        DebugLog(@"messageCellUpdateSendingStatusEvent >%@ ", notifyModel.actionName);
        if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_BEGIN]) {
            self.model.sentStatus = SentStatus_SENDING;
            [self updateStatusContentView:self.model];
            
        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_FAILED]) {
            self.model.sentStatus = SentStatus_FAILED;
            [self updateStatusContentView:self.model];
        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_SUCCESS]) {
            if (self.model.sentStatus != SentStatus_READ) {
                self.model.sentStatus = SentStatus_SENT;
                [self updateStatusContentView:self.model];
            }
        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_PROGRESS]) {
            [self imageMessageSendProgressing:notifyModel.progress];
        }
        //        else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_HASREAD] && [RCIM sharedRCIM].enableReadReceipt) {
        //            self.model.sentStatus = SentStatus_READ;
        //            [self updateStatusContentView:self.model];
        //        }
        
    }
}

- (void)didclickMsgFailedView:(UIButton *)button {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didTapmessageFailedStatusViewForResend:)]) {
            [self.delegate didTapmessageFailedStatusViewForResend:self.model];
        }
    }
}

+ (CGSize)getContentSize:(NSString *)content withFrontSize:(int)fontSize withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    CGSize maxSize = CGSizeMake(width, 8000);
    if (IOS_FSystenVersion < 7.0) {
        textSize = RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:fontSize],maxSize , NSLineBreakByTruncatingTail);
    }else{
        textSize = RC_MULTILINE_TEXTSIZE_GEIOS7(content,[UIFont systemFontOfSize:fontSize], maxSize);
    }
    textSize = CGSizeMake(ceilf(textSize.width), ceil(textSize.height));
    return textSize;
}

@end
