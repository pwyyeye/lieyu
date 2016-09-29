//
//  AudienceCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/6.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AudienceCell.h"

@implementation AudienceCell

-(void)layoutSubviews
{
    _iconButton = [[UIImageView alloc] init];
    _iconButton.frame = self.bounds;
    _iconButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconButton];
    [self setCornerRadiusView:self.iconButton With:self.iconButton.frame.size.height / 2  and:YES];
    self.iconButton.layer.borderColor = COMMON_PURPLE.CGColor;
    self.iconButton.layer.borderWidth = 1.f;
    self.iconButton.userInteractionEnabled = NO;
    
    self.detailButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.detailButton.backgroundColor = [UIColor clearColor];
    self.detailButton.frame = self.bounds;
    [self addSubview:self.detailButton];
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

@end
