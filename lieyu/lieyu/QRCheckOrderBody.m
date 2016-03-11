//
//  QRCheckOrderBody.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "QRCheckOrderBody.h"
#import "UIImageView+WebCache.h"
@implementation QRCheckOrderBody

- (void)awakeFromNib {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = _lineImage.bounds;
    [shapeLayer setPosition:_lineImage.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[RGBA(0, 0, 0, 0.2) CGColor]];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:1],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 12, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 18,0);
    // Setup the path CGMutablePathRef path = CGPathCreateMutable(); // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y CGPathMoveToPoint(path, NULL, 0, 10);
//    CGPathAddLineToPoint(path, NULL, 320,10);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_lineImage layer] addSublayer:shapeLayer];
//    _OrderImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _OrderImage.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ShopDetailmodel *)model{
    [_OrderImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@""]];
    _OrderName.text = model.name;
    _OrderPrice.text = [NSString stringWithFormat:@"单价:%@",model.youfeiPrice];
    _OrderNumber.text = [NSString stringWithFormat:@"X%@",model.count];
}

@end
