//
//  MineMoneyBagCollectionViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineMoneyBagCollectionViewCell.h"

@implementation MineMoneyBagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.image = nil;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.text = @"";
    //重置之前的layer
    if (self.layer.sublayers.count > 1) {
        CALayer *restLayer = self.layer.sublayers.lastObject;
        [restLayer removeFromSuperlayer];
    }
    CGFloat layerShdowWidth = SCREEN_WIDTH / 3.f;
    _layerShadowRight = [[CALayer alloc]init];
    _layerShadowRight.frame = CGRectMake(layerShdowWidth - 0.5, 0, 0.5, 89);
    _layerShadowRight.borderColor = [RGBA(230, 230, 230, 1) CGColor];
    _layerShadowRight.borderWidth = 0.5;
    [self.layer addSublayer:_layerShadowRight];
    [self bringSubviewToFront:self];
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [_iconImage setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
    [_titleLabel setText:[dict objectForKey:@"title"]];
    [_titleLabel setTextColor:[dict objectForKey:@"color"]];
}

@end
