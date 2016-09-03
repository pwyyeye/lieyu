//
//  HomePageCollectionViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomePageCollectionViewCell.h"

@implementation HomePageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_barImage setContentMode:UIViewContentModeScaleAspectFill];
    _barImage.layer.masksToBounds = YES;
}


- (void)setModel:(JiuBaModel *)model{
    _model = model;
    [_barImage sd_setImageWithURL:[NSURL URLWithString:model.baricon] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_barNameLabel setText:model.barname];
    [_barDescLabel setText:model.subtitle];
    [_barAddressLabel setText:model.address];
}

@end
