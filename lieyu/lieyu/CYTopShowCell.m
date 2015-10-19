//
//  CYTopShowCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CYTopShowCell.h"
#import "PinKeModel.h"
@implementation CYTopShowCell

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
    [_jiubaImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _jiubaNameLal.text=model.barinfo.barname;
    _titleLal.text=model.title;
    _priceLal.text=model.price;
    _typeLal.text=@"";
    
}
@end
