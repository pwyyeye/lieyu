//
//  LYWineBarCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWineBarCell.h"
#import "JiuBaModel.h"
#define LINEHEIGHT 0.5


@implementation LYWineBarCell

- (void)awakeFromNib {
    // Initialization code
    _viewLineTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, LINEHEIGHT+1);
    _viewLineBottom.frame = CGRectMake(0, 200, SCREEN_WIDTH, 0.5);
    _viewLineBottom.backgroundColor = [UIColor redColor];
    _viewLineBottom.hidden = YES;
    _viewLineTop.hidden = YES;
    
    _btn_star.layer.cornerRadius = 2;
    _btn_zang.layer.cornerRadius = 2;
    _btn_zang.layer.masksToBounds = YES;
    _btn_star.layer.masksToBounds = YES;
    _btn_star.layer.borderWidth = 0.5;
    _btn_star.layer.borderColor = RGBACOLOR(255, 255, 255, 0.5).CGColor;
}

- (void)setJiuBaModel:(JiuBaModel *)jiuBaModel{
    _jiuBaModel = jiuBaModel;
    [_imageView_header sd_setImageWithURL:[NSURL URLWithString:jiuBaModel.baricon] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _imageView_header.layer.cornerRadius = _imageView_header.frame.size.width/2.0;
    _imageView_header.layer.masksToBounds = YES;
    [_label_jiuba setText:jiuBaModel.barname];
    if (jiuBaModel.banners.count) {
        [_imageView_content sd_setImageWithURL:[NSURL URLWithString:jiuBaModel.banners[0]] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    }
    [_label_descr setText:jiuBaModel.subtitle];
    [_label_price setText:[NSString stringWithFormat:@"¥%@起",jiuBaModel.lowest_consumption]];
    [_label_point setText:jiuBaModel.address];
    if ([jiuBaModel.fav_num integerValue]) {
        [_label_star_count setText:jiuBaModel.fav_num];
    }else{
        [_label_star_count setText:@"0"];
    }
    [_label_zang_count setText:jiuBaModel.like_num];
    
    int fanli=jiuBaModel.rebate.floatValue * 100;
    
    if (!fanli) {
        _label_fanli_percent.text = @"";
        _label_fanli.hidden = YES;
        _imageView_rectangle.hidden = YES;
        return;
    }
    _imageView_rectangle.hidden = NO;
    _label_fanli.hidden = NO;
    
    NSString *perscent = [NSString stringWithFormat:@"%d%@",fanli,@"%"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:perscent];
    NSInteger location;
    NSLog(@"--------%d---%ld----%@",fanli,perscent.integerValue,perscent);
    if (perscent.integerValue < 10) {
        location = 1;
    }else{
        location = 2;
    }
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(location, 1)];
    _label_fanli_percent.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
