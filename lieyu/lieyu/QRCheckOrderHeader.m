//
//  QRCheckOrderHeader.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "QRCheckOrderHeader.h"

@implementation QRCheckOrderHeader

- (void)awakeFromNib {
    _user_avater.layer.cornerRadius = CGRectGetHeight(_user_avater.frame) / 2;
    _user_avater.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
