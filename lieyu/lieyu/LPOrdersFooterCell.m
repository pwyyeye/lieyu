//
//  LPOrdersFooterCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersFooterCell.h"

@implementation LPOrdersFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = self.shaperLbl.bounds;
    [shapeLayer setPosition:_shaperLbl.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 9, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shapeLayer];
    
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 102) byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 102);
    layer.path = bezierPath.CGPath;
    _backGround.layer.mask = layer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
