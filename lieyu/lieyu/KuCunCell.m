//
//  KuCunCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "KuCunCell.h"

@implementation KuCunCell

- (void)drawRect:(CGRect)rect{
    
    self.kuCunImageView.layer.masksToBounds =YES;
    
    self.kuCunImageView.layer.cornerRadius =self.kuCunImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
