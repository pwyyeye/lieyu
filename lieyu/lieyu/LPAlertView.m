//
//  LPAlertView.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPAlertView.h"
@interface LPAlertView()
@property (nonatomic, strong) UIView *backgroundView;


@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *buttonTitlesArray;

@end

@implementation LPAlertView
- (instancetype)init{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc]initWithFrame:self.frame];
        _backgroundView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self addSubview:_backgroundView];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LPAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ...{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitlesArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitlesArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitlesArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc]initWithFrame:self.frame];
        _backgroundView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self addSubview:_backgroundView];
//        if(!_contentView){
             [self initContentView];
//        }
       
        [self initAllButtons];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
}

- (void)initContentView{
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    
    _contentView.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20 , 250);
    
    
    
    [self addSubview:_contentView];
}

- (void)initAllButtons{
    if(_buttonTitlesArray.count > 0){
        for(NSString *buttonTitle in _buttonTitlesArray){
            NSInteger index = [_buttonTitlesArray indexOfObject:buttonTitle];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10 + 155 * index, SCREEN_HEIGHT - 60 , 145, 50)];
            button.titleLabel.font = [UIFont fontWithName:@"bold" size:16];
            button.layer.cornerRadius = 5.f;
            button.layer.masksToBounds = YES;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [self addSubview:button];
        }
    }
}

- (void)buttonWithPressed:(UIButton *)button{
    if(_delegate){
        NSInteger index = [_buttonTitlesArray indexOfObject:button.titleLabel.text];
        [_delegate LPAlertView:self clickedButtonAtIndex:index];
    }
    [self hide];
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subview = [windowViews objectAtIndex:[windowViews count] - 1];
        for (UIView *aSubview in subview.subviews) {
            [aSubview.layer removeAllAnimations];
        }
        [subview addSubview:self];
        //
        [self showAlertAnimation];
    }
}

- (void)hide{
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)showAlertAnimation{
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
    for (UIButton *button in _buttonArray) {
        [button.layer addAnimation:animation forKey:nil];
    }
}

- (void)hideAlertAnimation{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    //
    [UIView commitAnimations];
}

@end
