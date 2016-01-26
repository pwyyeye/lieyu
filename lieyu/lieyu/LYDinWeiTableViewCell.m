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
    self.backView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.8;
    self.backView.layer.shadowRadius = 2;
}

- (void)setModel:(RecommendPackageModel *)model{
    _model = model;
    self.label_name.text = model.title;
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
