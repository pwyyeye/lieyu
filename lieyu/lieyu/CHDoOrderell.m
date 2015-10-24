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
    self.danPinImageView.layer.masksToBounds =YES;
    
    self.danPinImageView.layer.cornerRadius =self.danPinImageView.frame.size.width/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(CarModel*)model
{
    carModel=model;
    [_danPinImageView  setImageWithURL:[NSURL URLWithString:model.product.image]];
    _nameLal.text=model.product.fullname;
    _delLal.text=[NSString stringWithFormat:@"x%@(%@)",model.product.num,model.product.unit];
    _zhekouLal.text=model.product.price;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.product.marketprice] attributes:attribtDic];
    _moneyLal.attributedText=attribtStr;
    
    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.product.rebate.doubleValue*100];
    [_yjBtn setTitle:flTem forState:0];
}
@end
