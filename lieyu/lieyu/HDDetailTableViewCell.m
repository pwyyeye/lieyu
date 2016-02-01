//
//  HDDetailTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDDetailTableViewCell.h"

@implementation HDDetailTableViewCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius = 2;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 1;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
