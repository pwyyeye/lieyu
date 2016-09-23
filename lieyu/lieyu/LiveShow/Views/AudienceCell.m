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
    [self setCornerRadiusView:self.iconButton With:self.iconButton.frame.size.height/2 and:YES];
    self.iconButton.layer.borderColor = RGB(187, 47, 217).CGColor;
    self.iconButton.layer.borderWidth = 1.f;
}


-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

@end
