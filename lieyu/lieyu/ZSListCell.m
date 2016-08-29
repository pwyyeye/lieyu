//
//  ZSListCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSListCell.h"

@implementation ZSListCell

- (void)awakeFromNib {
    self.mesImageView.layer.masksToBounds =YES;
    
    self.mesImageView.layer.cornerRadius =self.mesImageView.frame.size.width/2;
    
    self.backImageView.hidden = YES;
    self.CoutentImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
