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
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shaperLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shaperLayer];
    
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
