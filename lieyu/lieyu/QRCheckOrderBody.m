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
    // Initialization code
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
