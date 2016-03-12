//
//  qidongye.h
//
//  Code generated using QuartzCode 1.38.4 on 16/3/11.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface qidongye : UIView

@property (nonatomic, strong) UIColor *  color_one;
@property (nonatomic, strong) UIColor *  color_two;

- (void)addUntitled1Animation;
- (void)addUntitled1AnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;

@end
