//
//  EmojisView.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol emojiClickDelegate<NSObject>
- (void)likeFriendsClickEmoji:(NSString *)likeType;
@end

@interface EmojisView : UIView
@property (nonatomic, strong) UIVisualEffectView *emojiEffectView;
@property (nonatomic, strong) UIButton *emoji_angry;
@property (nonatomic, strong) UIButton *emoji_sad;
@property (nonatomic, strong) UIButton *emoji_wow;
@property (nonatomic, strong) UIButton *emoji_kawayi;
@property (nonatomic, strong) UIButton *emoji_happy;
@property (nonatomic, strong) UIButton *emoji_zan;

@property (nonatomic, assign) id<emojiClickDelegate> delegate;

@property (nonatomic, strong) UIWindow *mainWindow;

+ (instancetype)shareInstanse;
- (NSDictionary *)getEmojisView;
- (void)clickEmojiBtn:(UIButton *)btn;
- (void)windowShowEmoji:(NSString *)emojiName And:(int)emojiNumber;
- (void)hideEmojiEffectView;
- (void)windowShowEmoji:(NSDictionary *)dict;
@end
