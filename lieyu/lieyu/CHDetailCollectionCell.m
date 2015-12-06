//
//  CHDetailCollectionCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHDetailCollectionCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation CHDetailCollectionCell
-(void)configureCell:(CheHeModel *)model{
    NSLog(@"***%@****%@",model.fullname,model.img_260);
    _nameLal.text=model.fullname;
    if(model.marketprice){
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
        _jiubaNameLal.attributedText=attribtStr;
    }
    
    _priceLal.text=[NSString stringWithFormat:@"￥%@",model.price];
    _flLal.text=[NSString stringWithFormat:@"%.f元",[model.price floatValue] * model.rebate];
    [_goodsImageView setImageWithURL:[NSURL URLWithString:model.img_260]];
}
@end
