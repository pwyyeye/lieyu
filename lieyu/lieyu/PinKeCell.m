//
//  PinKeCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PinKeCell.h"

@implementation PinKeCell

- (void)drawRect:(CGRect)rect{
    
    self.pinkeImageView.layer.masksToBounds =YES;
    
    self.pinkeImageView.layer.cornerRadius =self.pinkeImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
