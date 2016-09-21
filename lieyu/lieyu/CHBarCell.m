//
//  CHBarCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHBarCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "JiuBaModel.h"
@implementation CHBarCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(JiuBaModel*)model
{
    _barNameLal.text=model.barname;
    _addressLal.text=model.address;
    [_barImageView setImageWithURL:[NSURL URLWithString:model.baricon]];
}
@end
