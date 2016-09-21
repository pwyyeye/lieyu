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


- (void)setModel:(TaoCanModel *)model{
    _model = model;
    if (model.banner) {
        
    [_imageView_header sd_setImageWithURL:[NSURL URLWithString:model.banner[0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    }
    _label_name.text = model.title;
    NSString *priceStr = [NSString stringWithFormat:@"¥%0.f/卡",model.price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, 3)];
    if (model.price >= 999) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, 4)];
    }
    _label_price.attributedText = attributedString;
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",model.marketprice] attributes:attribtDic];
    _label_price_old.attributedText = attribtStr;
    
    [self.btn_fanli setText:[NSString stringWithFormat:@"返利%.0f%@",model.rebate * 100,@"%"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected stat.
}

- (void)cellConfigure:(CheHeModel *)chiheModel{
    _chiheModel = chiheModel;
//    _imageView_header sd_setImageWithURL:[NSURL URLWithString:_chiheModel.] placeholderImage:<#(UIImage *)#>
}






@end
