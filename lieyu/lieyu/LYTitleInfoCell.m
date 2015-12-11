//
//  LYTitleInfoCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTitleInfoCell.h"

@implementation LYTitleInfoCell

- (void)awakeFromNib {
    // Initialization code
    _titleLal.font = [UIFont boldSystemFontOfSize:18];
    _titleLal.textColor = RGBA(51, 51, 51, 1);
    _titleLal.frame = CGRectMake(10, 8, 72, 24);

    _delLal.font = [UIFont systemFontOfSize:14];
    _delLal.textColor = RGBA(114, 5, 147, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
