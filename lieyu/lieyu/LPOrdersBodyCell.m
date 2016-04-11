//
//  LPOrdersBodyCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersBodyCell.h"
#import "SetMealVOModel.h"

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
    NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    if (model.ordertype == 0) {//套餐订单
        [_orderImage sd_setImageWithURL:[NSURL URLWithString:model.setMealInfo.setMealVO.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_orderNameLbl setText:model.setMealInfo.setMealVO.smname];
        [_orderNumberLbl setText:[NSString stringWithFormat:@"X%@",model.allnum]];
        [_orderPriceLbl setText:[NSString stringWithFormat:@"¥%@",model.setMealInfo.setMealVO.price]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:model.setMealInfo.setMealVO.marketprice attributes:attributeDic];
        [_orderMarketPriceLbl setAttributedText:attributeStr];
    }else if (model.ordertype == 2){//吃喝专场
        NSDictionary *dict = [model.goodslist objectAtIndex:self.tag];
        [_orderImage sd_setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"productVO"] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_orderNameLbl setText:[dict objectForKey:@"fullName"]];
        [_orderNumberLbl setText:[NSString stringWithFormat:@"X%@",[dict objectForKey:@"quantity"]]];
        [_orderPriceLbl setText:[NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",[[dict objectForKey:@"productVO"] objectForKey:@"marketprice"]] attributes:attributeDic];
        [_orderMarketPriceLbl setAttributedText:attributeStr];
    }else if(model.ordertype == 1){
        SetMealVOModel *setmealVOModel = model.pinkerinfo;
        [_orderImage sd_setImageWithURL:[NSURL URLWithString:setmealVOModel.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_orderNameLbl setText:setmealVOModel.smname];
        [_orderNumberLbl setText:[NSString stringWithFormat:@"%d",model.pinkerNum]];
        [_orderPriceLbl setText:setmealVOModel.price];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:setmealVOModel.marketprice attributes:attributeDic];
        [_orderMarketPriceLbl setAttributedText:attributeStr];
    }
}

@end
