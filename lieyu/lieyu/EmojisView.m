//
//  EmojisView.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "EmojisView.h"
#import "LYFriendsHttpTool.h"
#import "UserModel.h"
@interface EmojisView()
{
    UIView *imageContent;
}
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
//@property (nonatomic, assign) BOOL isExists;

@end

@implementation EmojisView

static EmojisView *shareView = nil;

+ (instancetype)shareInstanse{
    if (!shareView) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareView = [[self alloc]init];
        });
    }
    return  shareView;
}

- (NSDictionary *)getEmojisView{
    if (!_emojiEffectView && !_emoji_sad && !_emoji_wow && !_emoji_zan && !_emoji_angry && !_emoji_happy && !_emoji_kawayi) {
        _mainWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _emojiEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _emojiEffectView.tag = 577;
        [_emojiEffectView setFrame:CGRectMake(-80, 0, 80, SCREEN_HEIGHT)];
        [_emojiEffectView setAlpha:1];
        _emojiEffectView.layer.shadowColor = [RGBA(0, 0, 0, 1) CGColor];
        _emojiEffectView.layer.shadowOffset = CGSizeMake(0.5, 0);
        _emojiEffectView.layer.shadowRadius = 1;
        _emojiEffectView.layer.shadowOpacity = 0.3;
        //        [self.view bringSubviewToFront:emojiEffectView];
        
        
        int margin = ( SCREEN_HEIGHT - 240 ) / 7;
        
        _emoji_angry = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin, 80, 40)];
        [_emoji_angry setImage:[UIImage imageNamed:@"angry0"] forState:UIControlStateNormal];
        [_emoji_angry.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_angry.tag = 201;
        [_emoji_angry addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _emoji_sad = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 2 + 40, 80, 40)];
        [_emoji_sad setImage:[UIImage imageNamed:@"sad0"] forState:UIControlStateNormal];
        [_emoji_sad.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_sad.tag = 202;
        [_emoji_sad addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _emoji_wow = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 3 + 80, 80, 40)];
        [_emoji_wow setImage:[UIImage imageNamed:@"wow0"] forState:UIControlStateNormal];
        [_emoji_wow.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_wow.tag = 203;
        [_emoji_wow addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _emoji_kawayi = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 4 + 120, 80, 40)];
        [_emoji_kawayi setImage:[UIImage imageNamed:@"kawayi0"] forState:UIControlStateNormal];
        [_emoji_kawayi.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_kawayi.tag = 204;
        [_emoji_kawayi addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _emoji_happy = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 5 + 160, 80, 40)];
        [_emoji_happy setImage:[UIImage imageNamed:@"happy0"] forState:UIControlStateNormal];
        [_emoji_happy.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_happy.tag = 205;
        [_emoji_happy addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _emoji_zan = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 6 + 200, 80, 40)];
        [_emoji_zan setImage:[UIImage imageNamed:@"dianzan0"] forState:UIControlStateNormal];
        [_emoji_zan.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _emoji_zan.tag = 206;
        [_emoji_zan addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mainWindow addSubview:_emojiEffectView];
        [_mainWindow addSubview:_emoji_zan];
        [_mainWindow addSubview:_emoji_happy];
        [_mainWindow addSubview:_emoji_kawayi];
        [_mainWindow addSubview:_emoji_wow];
        [_mainWindow addSubview:_emoji_angry];
        [_mainWindow addSubview:_emoji_sad];
    }
//    _isExists = YES;
    return @{@"emojiEffectView":_emojiEffectView,
             @"emojiButtons":@[_emoji_angry,_emoji_sad,_emoji_wow,_emoji_kawayi,_emoji_happy,_emoji_zan]};
}

- (void)clickEmojiBtn:(UIButton *)btn{
    NSString *emojiName ;
    int emojiNumber;
    if (btn.tag == 201) {
        emojiName = @"angry";
        emojiNumber = 34;
    }else if (btn.tag == 202){
        emojiName = @"sad";
        emojiNumber = 24;
    }else if (btn.tag == 203){
        emojiName = @"wow";
        emojiNumber = 24;
    }else if (btn.tag == 204){
        emojiName = @"kawayi";
        emojiNumber = 24;
    }else if (btn.tag == 205){
        emojiName = @"happy";
        emojiNumber = 24;
    }else if (btn.tag == 206){
        emojiName = @"dianzan";
        emojiNumber = 24;
    }
    if ([self.delegate respondsToSelector:@selector(likeFriendsClickEmoji:)]) {
        [self.delegate likeFriendsClickEmoji:[NSString stringWithFormat:@"%ld",btn.tag - 200]];
    }
    [self hideEmojiEffectView];
    [self performSelector:@selector(windowShowEmoji:) withObject:@{@"emojiName":emojiName,
                                @"emojiNumber":[NSString stringWithFormat:@"%d",emojiNumber]}afterDelay:0.5];
}

- (void)windowShowEmoji:(NSDictionary *)dict{
    NSString *emojiName = [dict objectForKey:@"emojiName"];
    int emojiNumber = [[dict objectForKey:@"emojiNumber"]intValue];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *string;
    UIImage *image;
    if(!imageContent){
        imageContent = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 41, SCREEN_HEIGHT / 2 - 41, 82, 82)];
        [imageContent setBackgroundColor:[UIColor whiteColor]];
        imageContent.layer.cornerRadius = 41;
        imageContent.layer.masksToBounds = YES;
    }
    
    UIImageView *ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0",emojiName]]];
//    ImageView.backgroundColor = [UIColor redColor];
    for (int i = 0 ; i <= emojiNumber; i ++) {
        string = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@%d",emojiName,i] ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:string];
        [array addObject:image];
    }
    [ImageView setFrame:CGRectMake(-9, -9, 100, 100)];
    [imageContent addSubview:ImageView];
    [_mainWindow addSubview:imageContent];
//    [_mainWindow addSubview:ImageView];
    ImageView.animationImages = array;
    ImageView.animationDuration = emojiNumber * 0.1;
    ImageView.animationRepeatCount = 1;
    //    [imgView removeFromSuperview];
    [ImageView startAnimating];
    //    [self performSelector:@selector(removeImageView:) withObject:ImageView afterDelay:emojiNumber * 0.1];
    //    dispatch_queue_t *queue = dispatch_get_global_queue(@"global", 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(emojiNumber * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                ImageView.alpha = 0 ;
                imageContent.alpha = 0;
            }completion:^(BOOL finished) {
//                for (UIView *view in _mainWindow.subviews) {
//                    [view removeFromSuperview];
//                }
                [ImageView removeFromSuperview];
                [imageContent removeFromSuperview];
                imageContent = nil;
                //        [NSThread currentThread]
            }];
        });
    });

}

#pragma mark - 显示动画
- (void)windowShowEmoji:(NSString *)emojiName And:(int)emojiNumber{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *string;
    UIImage *image;
//    UIView *imageContent = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 55, SCREEN_HEIGHT / 2 - 55, 110, 110)];
//    [imageContent setBackgroundColor:[UIColor redColor]];
//    imageContent.layer.cornerRadius = 55;
//    imageContent.layer.masksToBounds = YES;
    
    UIImageView *ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0",emojiName]]];
    for (int i = 0 ; i <= emojiNumber; i ++) {
        string = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@%d",emojiName,i] ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:string];
        [array addObject:image];
    }
    
    [ImageView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT / 2 - 50, 100, 100)];
    [_mainWindow addSubview:ImageView];
//    [imageContent addSubview:ImageView];
//    [_mainWindow addSubview:imageContent];
    
    ImageView.animationImages = array;
    ImageView.animationDuration = emojiNumber * 0.1;
    ImageView.animationRepeatCount = 1;
    //    [imgView removeFromSuperview];
    [ImageView startAnimating];
    //    [self performSelector:@selector(removeImageView:) withObject:ImageView afterDelay:emojiNumber * 0.1];
    //    dispatch_queue_t *queue = dispatch_get_global_queue(@"global", 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(emojiNumber * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                ImageView.alpha = 0 ;
            }completion:^(BOOL finished) {
                [ImageView removeFromSuperview];
                //        [NSThread currentThread]
            }];
        });
    });
    
    //    [self performSelector:@selector(removeImageView:) onThread:[NSThread new] withObject:ImageView waitUntilDone:YES];
}

#pragma mark - 隐藏左侧表情栏
- (void)hideEmojiEffectView{
//    if (_isExists == YES) {
//        _isExists = NO;
//    _mainWindow ges
    for (UITapGestureRecognizer *tapgesture in _mainWindow.gestureRecognizers) {
        [_mainWindow removeGestureRecognizer:tapgesture];
    }
        NSArray *emojiArr = @[_emoji_zan,_emoji_happy,_emoji_kawayi,_emoji_wow,_emoji_sad,_emoji_angry];
        [UIView animateWithDuration:.3 delay:0.4 options:(UIViewAnimationOptionTransitionNone) animations:^{
            _emojiEffectView.frame = CGRectMake(-80,0,80, _emojiEffectView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        for (int i = 0 ; i < emojiArr.count; i ++) {
            UIButton *emojiBtn = [emojiArr objectAtIndex:i];
            double y = emojiBtn.frame.origin.y;
            [UIView animateWithDuration:0.8 delay:i * 0.1 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [emojiBtn setFrame:CGRectMake(-80, y, 80, 40)];
            } completion:^(BOOL finished) {
                
            }];
        }
//    }
}

@end
