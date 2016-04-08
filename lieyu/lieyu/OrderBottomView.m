//
//  OrderBottomView.m
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "OrderBottomView.h"

@implementation OrderBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.bounds = _shaperLbl.bounds;
    [shaperLayer setPosition:_shaperLbl.center];
    [shaperLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shaperLayer setStrokeColor:[RGBA(0, 0, 0, 0.2) CGColor]];
    [shaperLayer setLineWidth:0.5];
    [shaperLayer setLineJoin:kCALineJoinRound];
    [shaperLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 12, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 12, 0);
    [shaperLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shaperLayer];
}




@end
