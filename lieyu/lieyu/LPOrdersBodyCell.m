//
//  LPOrdersBodyCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersBodyCell.h"

@implementation LPOrdersBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OrderInfoModel *)model{
    _model = model;
    if (model.ordertype == 0) {//套餐订单
        [_orderImage sd_setImageWithURL:[NSURL URLWithString:model.setMealInfo.setMealVO.linkUrl] placeholderImage:[UIImage imageNamed:@""]];
        [_orderNameLbl setText:model.setMealInfo.setMealVO.smname];
        [_orderNumberLbl setText:model.allnum];
        [_orderPriceLbl setText:[NSString stringWithFormat:@"¥%@",model.setMealInfo.setMealVO.price]];
    }
}

@end
