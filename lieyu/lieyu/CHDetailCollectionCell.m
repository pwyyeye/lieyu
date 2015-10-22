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
    _jiubaNameLal.text=model.barname;
    _priceLal.text=[NSString stringWithFormat:@"￥%@",model.price];
    _flLal.text=[NSString stringWithFormat:@"再返利%.f%%",model.rebate*100];
    [_goodsImageView setImageWithURL:[NSURL URLWithString:model.img_260]];
}
@end
