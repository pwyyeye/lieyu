//
//  FreeOrderTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/6/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FreeOrderTableViewCell.h"

@implementation FreeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //两条虚线
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.bounds = _firstShapeLine.bounds;
    [shapeLayer1 setPosition:_firstShapeLine.center];
    [shapeLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer1 setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer1 setLineWidth:0.5];
    [shapeLayer1 setLineJoin:kCALineJoinRound];
    [shapeLayer1 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.bounds = _firstShapeLine.bounds;
    [shapeLayer2 setPosition:_firstShapeLine.center];
    [shapeLayer2 setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer2 setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer2 setLineWidth:0.5];
    [shapeLayer2 setLineJoin:kCALineJoinRound];
    [shapeLayer2 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, _firstShapeLine.frame.size.width, 0);
    [shapeLayer1 setPath:path];
    [shapeLayer2 setPath:path];
    CGPathRelease(path);
    [[_firstShapeLine layer]addSublayer:shapeLayer1];
    [[_firstShapeLine layer]addSublayer:shapeLayer2];
    
    //
    _bgView.layer.cornerRadius = 4;
    
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
