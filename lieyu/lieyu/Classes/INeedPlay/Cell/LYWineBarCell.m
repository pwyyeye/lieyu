//
//  LYWineBarCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWineBarCell.h"
#import "JiuBaModel.h"


@implementation LYWineBarCell

- (void)awakeFromNib {
    // Initialization code
    _label_line_bottom.bounds = CGRectMake(0, 0, 320, 0.5);
    _labl_line_top.bounds = CGRectMake(0, 0, 320, 0.5);
    
    _btn_star.layer.cornerRadius = 2;
    _btn_zang.layer.cornerRadius = 2;
    _btn_zang.layer.masksToBounds = YES;
    _btn_star.layer.masksToBounds = YES;
    _btn_star.layer.borderWidth = 0.5;
    _btn_star.layer.borderColor = RGBACOLOR(255, 255, 255, 0.5).CGColor;
    
    NSString *perscent = [NSString stringWithFormat:@"30%@",@"%"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:perscent];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(2, 1.99)];
    _label_fanli_percent.attributedText = attributedStr;
}

- (void)setJiuBaModel:(JiuBaModel *)jiuBaModel{
    _jiuBaModel = jiuBaModel;
    [_imageView_header sd_setImageWithURL:[NSURL URLWithString:jiuBaModel.baricon] placeholderImage:nil];
    _imageView_header.layer.cornerRadius = _imageView_header.frame.size.width/2.0;
    _imageView_header.layer.masksToBounds = YES;
    [_label_jiuba setText:jiuBaModel.barname];
    [_imageView_content sd_setImageWithURL:[NSURL URLWithString:jiuBaModel.banners[0]] placeholderImage:nil];
    [_label_descr setText:jiuBaModel.subtitle];
    [_label_price setText:[NSString stringWithFormat:@"¥%@起",jiuBaModel.lowest_consumption]];
    [_label_point setText:jiuBaModel.address];
    [_label_star_count setText:jiuBaModel.star_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
