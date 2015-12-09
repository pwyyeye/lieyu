//
//  LYBarTitleTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarTitleTableViewCell.h"

@implementation LYBarTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _label_line.bounds = CGRectMake(0, 0, 60, 0.5);
    
    self.imageView_header.layer.cornerRadius = 2;
    self.imageView_header.layer.masksToBounds = YES;
    _barStar.enabled=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
