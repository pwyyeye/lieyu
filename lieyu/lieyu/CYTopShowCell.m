//
//  CYTopShowCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CYTopShowCell.h"
#import "OrderInfoModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation CYTopShowCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(OrderInfoModel*)model
{
    //0、请客 1、AA付款 2、自由付款
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.barinfo.baricon ;
    [_jiubaImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _jiubaNameLal.text=model.barinfo.barname;
    _titleLal.text=model.pinkerinfo.smname;
    _priceLal.text=[NSString stringWithFormat:@"%@ x %d(份)",model.pinkerinfo.price,model.pinkerNum] ;
    if(model.pinkerType==0){
        _typeLal.text=@"好友请客";
    }else if(model.pinkerType==1){
        _typeLal.text=@"AA付款";
    }else{
        _typeLal.text=@"AA付款";
    }
    
    
}
@end
