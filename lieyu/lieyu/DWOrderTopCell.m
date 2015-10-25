//
//  DWOrderTopCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWOrderTopCell.h"
#import "TaoCanModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation DWOrderTopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(TaoCanModel*)model
{
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.linkUrl ;
    [_taoCanImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _nameLal.text=model.title;
    _delLal.text=[NSString stringWithFormat:@"[适合%d-%d人]",model.minnum,model.maxnum];
    _zhekouLal.text=[NSString stringWithFormat:@"￥%.2f",model.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
    _moneyLal.attributedText=attribtStr;
    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.rebate*100];
    [_yjBtn setTitle:flTem forState:0];
    
    
}
@end
