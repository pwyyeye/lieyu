//
//  PTTaoCanDetailCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTTaoCanDetailCell.h"
#import "PinKeModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation PTTaoCanDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(PinKeModel*)model
{
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.barinfo.baricon ;
    [_jiuBaImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _jiubaLal.text=model.barinfo.barname;
    _titleLal.text=model.title;
    _moneyLal.text=[NSString stringWithFormat:@"￥%@",model.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
    _marketprice.attributedText=attribtStr;
}
@end
