//
//  LYTaoCanHeaderTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTaoCanHeaderTableViewCell.h"
#import "TaoCanModel.h"

@implementation LYTaoCanHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(TaoCanModel *)model{
    _model = model;
    [_imageView_header sd_setImageWithURL:[NSURL URLWithString:model.linkUrl]];
    _label_name.text = model.title;
    NSString *priceStr = [NSString stringWithFormat:@"¥%0.f/卡",model.price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, 3)];
    if (model.price >= 999) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, 4)];
    }
    _label_price.attributedText = attributedString;
    _label_price_old.text = [NSString stringWithFormat:@"¥%@",model.marketprice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
