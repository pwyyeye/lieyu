//
//  LYPlayTogetherCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPlayTogetherCell.h"
#import "PinKeModel.h"
#import "JiuBaModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation LYPlayTogetherCell

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
    [_pkIconImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _barnameLal.text=model.barinfo.barname;
    _introductionLal.text=model.title;
    _addressLal.text=model.barinfo.address;
    _scLal.text=model.barinfo.fav_num;
    
}
@end
