//
//  LoadingView.m
//  lieyu
//
//  Created by 狼族 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation LoadingView


- (void)drawRect:(CGRect)rect {
    
}

- (instancetype)initWith:(UIView *)view{
    self = [super init];
    if (self) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [view addSubview:_backgroundView];
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading60.png"]];
        imgV.tag = 10086;
        imgV.userInteractionEnabled = NO;
        imgV.frame = CGRectMake(0, 0, 100, 100);
        imgV.contentMode = UIViewContentModeCenter;
        
        NSMutableArray *imgNameArr = [[NSMutableArray alloc]initWithCapacity:90];
        for(int i = 1; i < 61; i ++){
            [imgNameArr addObject:[NSString stringWithFormat:@"loading%d.png",i]];
        }
        NSMutableArray *imgArr = [[NSMutableArray alloc]init];
        for(int i = 0; i < imgNameArr.count; i ++){
            UIImage *img =[UIImage imageNamed:imgNameArr[i]];
            [imgArr addObject:(__bridge UIImage*)img.CGImage];
        }
        
        CAKeyframeAnimation *keyA = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        keyA.duration = 3;
        keyA.delegate = self;
        keyA.values = imgArr;
        keyA.repeatCount = 99;
            [imgV.layer addAnimation:keyA forKey:nil];
        
//        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _contentView = imgV;
        _contentView.center = _backgroundView.center;
//        _contentView.backgroundColor = [UIColor blueColor];
        [_backgroundView addSubview:_contentView];
    }
    return self;
}

- (void)hideAnimation:(BOOL)animation afterDelay:(NSInteger)delay{
    [UIView animateWithDuration:.5 delay:delay options:UIViewAnimationOptionTransitionNone  animations:^{
        _backgroundView.alpha = 0.f;
        _contentView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [_contentView removeFromSuperview];
    }];
}

@end
