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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(RecommendPackageModel *)model{
    _model = model;
    self.label_name.text = model.title;
    self.label_price_now.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",model.marketprice] attributes:attribtDic];
    self.label_price_old.attributedText = attribtStr;
    self.label_buyCount.text = [NSString stringWithFormat:@"%@人购",model.buynum];
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:model.linkUrl]];

    NSString *percentStr =[NSString stringWithFormat:@"%.0f%@",([self.model.rebate floatValue]) * 100,@"%"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:percentStr];
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(2, 1.9)];
    self.label_percent.attributedText = attributedStr;
}

- (void)setTaoCanModel:(TaoCanModel *)taoCanModel{
    _taoCanModel = taoCanModel;
    self.label_name.text = taoCanModel.title;
    self.label_price_now.text = [NSString stringWithFormat:@"¥%.0f",taoCanModel.price];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",taoCanModel.marketprice] attributes:attribtDic];
    NSLog(@"%@",attribtStr);
    self.label_price_old.attributedText = attribtStr;
    
    self.label_buyCount.text = [NSString stringWithFormat:@"%d人购",taoCanModel.buynum];
    [self.imageView_header sd_setImageWithURL:[NSURL URLWithString:taoCanModel.linkUrl]];
    
    
    NSString *percentStr =[NSString stringWithFormat:@"%.0f%@",(self.taoCanModel.rebate) * 100,@"%"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:percentStr];
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(2, 1.9)];
    self.label_percent.attributedText = attributedStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
