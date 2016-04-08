//
//  LPOrdersHeaderCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersHeaderCell.h"

@implementation LPOrdersHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = self.shaperLbl.bounds;
    [shapeLayer setPosition:_shaperLbl.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:RGBA(0, 0, 0, 0.2).CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 12, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shapeLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OrderInfoModel *)model{
    _model = model;
    self.placeLbl.text = model.barinfo.barname;
    self.orderStatusLbl.text = [MyUtil getOrderStatus:model.orderStatus];
    self.orderNumberLbl.text = [NSString stringWithFormat:@"%d",model.id];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"时间：%@",[model.createDate substringToIndex:model.createDate.length - 2]];
}

@end
