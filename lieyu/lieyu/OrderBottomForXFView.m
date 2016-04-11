//
//  OrderBottomForXFView.m
//  lieyu
//
//  Created by SEM on 15/9/18.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "OrderBottomForXFView.h"

@implementation OrderBottomForXFView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *bezierP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, _contentView.bounds.size.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = CGRectMake(0, 0, SCREEN_WIDTH - 6, _contentView.bounds.size.height);
    shapeL.path = bezierP.CGPath;
    _contentView.layer.mask = shapeL;
}


@end
