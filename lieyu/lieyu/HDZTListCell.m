//
//  HDZTListCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDZTListCell.h"

@implementation HDZTListCell

- (void)awakeFromNib {
    _back_view.layer.cornerRadius = 2;
    _back_view.layer.masksToBounds = YES;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_action_page.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = _action_page.bounds;
    layer.path = path.CGPath;
    _action_page.layer.mask = layer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
