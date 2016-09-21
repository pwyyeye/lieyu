//
//  CheHeCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CheHeCell.h"

@implementation CheHeCell

- (void)drawRect:(CGRect)rect{
    
    self.cheHeImageView.layer.masksToBounds =YES;
    
    self.cheHeImageView.layer.cornerRadius =self.cheHeImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
