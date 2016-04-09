//
//  LPOrdersHeaderView.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersHeaderView.h"
#import <QuartzCore/QuartzCore.h>
@implementation LPOrdersHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = self.shaperLbl.bounds;
    [shapeLayer setPosition:_shaperLbl.center];
    [shapeLayer setFillColor:[[UIColor redColor] CGColor]];
    [shapeLayer setStrokeColor:RGBA(0, 0, 0, 1).CGColor];
    [shapeLayer setLineWidth:2];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 12, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shapeLayer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 59) byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 59);
    layer.path = bezierPath.CGPath;
    _backGround.layer.mask = layer;
}


- (void)setModel:(OrderInfoModel *)model{
    _model = model;
    self.placeLbl.text = model.barinfo.barname;
    self.orderStatusLbl.text = [MyUtil getOrderStatus:model.orderStatus];
    self.orderNumberLbl.text = [NSString stringWithFormat:@"%d",model.id];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"时间：%@",[model.createDate substringToIndex:model.createDate.length - 2]];
}

@end
