//
//  CommonShow.m
//  Walker1.0
//
//  Created by WTT on 15/10/20.
//  Copyright (c) 2015年 WPF. All rights reserved.
//

#import "CommonShow.h"

@implementation CommonShow

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = RGBA(114, 5, 147, 0.8);
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - LabelSize.width - 20)/2, CGRectGetWidth([UIScreen mainScreen].bounds) - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:3 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
