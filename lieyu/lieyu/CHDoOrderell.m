//
//  CHDoOrderell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHDoOrderell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation CHDoOrderell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(CarModel*)model
{
    carModel=model;
    [_goodImageView  setImageWithURL:[NSURL URLWithString:model.product.image] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _goodNameLbl.text=model.product.fullname;
    _numLbl.text=[NSString stringWithFormat:@"x%@(%@)",model.quantity,model.product.unit];
    _priceLbl.text=[NSString stringWithFormat:@"¥%@",model.product.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.product.marketprice] attributes:attribtDic];
    _marketPriceLbl.attributedText=attribtStr;
    
    _presentLbl.text = [NSString stringWithFormat:@"%.f%%",model.product.rebate.doubleValue*100];
}
@end
