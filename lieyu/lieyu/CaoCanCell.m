//
//  CaoCanCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CaoCanCell.h"

@implementation CaoCanCell
- (void)drawRect:(CGRect)rect{
    
    self.taoCanImageView.layer.masksToBounds =YES;
    
    self.taoCanImageView.layer.cornerRadius =self.taoCanImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
