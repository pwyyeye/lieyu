//
//  LYDinWeiTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYDinWeiTableViewCell.h"
#import "RecommendPackageModel.h"
#import "TaoCanModel.h"

@implementation LYDinWeiTableViewCell
- (void)setSelected:(BOOL)selected{
    if(selected){
        self.backView.layer.borderWidth = 2;
        self.backView.layer.borderColor = [RGB(186, 40, 227)CGColor];
        self.button_add.hidden = NO;
        self.button_less.hidden = NO;
        self.label_number.hidden = NO;
    }else{
        self.backView.layer.borderWidth = 0;
        self.button_add.hidden = YES;
        self.button_less.hidden = YES;
        self.label_number.hidden = YES;
        self.label_number.text = @"1";
        [self.button_less setImage:[UIImage imageNamed:@"gray_less_circle"] forState:UIControlStateNormal];
        [self.button_add setImage:[UIImage imageNamed:@"add_purper_circle"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    self.backView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 1;
    self.hotImage.hidden = YES;
}

- (void)setModel:(RecommendPackageModel *)model{
    _model = model;
    self.label_name.text = [NSString stringWithFormat:@"%@(适合%@-%@人)",model.title,model.minnum,model.maxnum];
    self.label_price_now.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",model.marketprice] attributes:attribtDic];
    self.label_price_old.attributedText = attribtStr;
    self.label_buyCount.text = [NSString stringWithFormat:@"%@人购",model.buynum];
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:model.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    
    CGFloat rebate = [self.model.rebate floatValue];
    CGFloat profit = [model.price intValue] * rebate;
    NSString *percentStr =[NSString stringWithFormat:@"返利:%.0f元",profit];
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:percentStr];
//    NSInteger rangeIndex;
//    if(rebate == 0) rangeIndex = 1;
//    else rangeIndex = 2;
//    [attributedStr addAttribute:NSFontAttributeName
//     
//                          value:[UIFont systemFontOfSize:10]
//     
//                          range:NSMakeRange(rangeIndex, 1)];
    self.label_percent.text = percentStr;
}

- (void)setTaoCanModel:(TaoCanModel *)taoCanModel{
    _taoCanModel = taoCanModel;
    self.label_name.text = taoCanModel.title;
    self.label_price_now.text = [NSString stringWithFormat:@"¥%.0f",taoCanModel.price];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",taoCanModel.marketprice] attributes:attribtDic];
    self.label_price_old.attributedText = attribtStr;
    
    self.label_buyCount.text = [NSString stringWithFormat:@"%d人购",taoCanModel.buynum];
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:taoCanModel.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    
    CGFloat rebate = self.taoCanModel.rebate * 100;
    NSString *percentStr =[NSString stringWithFormat:@"%.0f%@",rebate,@"%"];
    NSLog(@"--------->%@",percentStr);
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:percentStr];
    if (percentStr.integerValue <10) {
        [attributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:10]
         
                              range:NSMakeRange(1, 1)];
    }else{
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(2, 1)];
    }
    self.label_percent.attributedText = attributedStr;
}

- (void)setPinkeModel:(PinKeModel *)pinkeModel{
    _pinkeModel = pinkeModel;
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:_pinkeModel.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.label_name.text = [NSString stringWithFormat:@"%@(适合%@-%@人)",_pinkeModel.title,_pinkeModel.minnum,_pinkeModel.maxnum];
    self.label_buyCount.text = [NSString stringWithFormat:@"%@人购",_pinkeModel.buynum];
    self.label_price_now.text = [NSString stringWithFormat:@"¥%@",_pinkeModel.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_pinkeModel.marketprice] attributes:attribtDic];
    self.label_price_old.attributedText = attribtStr;
    CGFloat rebate = [_pinkeModel.rebate floatValue];
    CGFloat profit = [_pinkeModel.price intValue] * rebate;
    NSString *percentStr =[NSString stringWithFormat:@"返利:%.0f元",profit];
    self.label_percent.text = percentStr;
}

- (void)setPinkeInfo:(YUPinkerinfo *)pinkeInfo{
    _pinkeInfo = pinkeInfo;
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:_pinkeInfo.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.label_name.text = [NSString stringWithFormat:@"%@(适合%@-%@人)",_pinkeInfo.smname,_pinkeInfo.minnum,_pinkeInfo.maxnum];
    self.label_buyCount.text = [NSString stringWithFormat:@"%@人购",_pinkeInfo.buynum];
    self.label_price_now.text = [NSString stringWithFormat:@"¥%@",_pinkeInfo.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_pinkeInfo.marketprice] attributes:attribtDic];
    self.label_price_old.attributedText = attribtStr;
    CGFloat rebate = [_pinkeInfo.rebate floatValue];
    CGFloat profit = [_pinkeInfo.price intValue] * rebate;
    NSString *percentStr =[NSString stringWithFormat:@"返利:%.0f元",profit];
    self.label_percent.text = percentStr;
    NSLog(@"%d",[_pinkeInfo.recommended intValue])
    self.hotImage.hidden = ![_pinkeInfo.recommended intValue];
    [self.button_add removeFromSuperview];
    [self.button_less removeFromSuperview];
    [self.label_number removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
