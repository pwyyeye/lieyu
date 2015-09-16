//
//  CustomerCell.m
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell

- (void)awakeFromNib {
    // Initialization code
    self.smallImageView.layer.masksToBounds =YES;
    
    self.smallImageView.layer.cornerRadius =self.smallImageView.frame.size.width/2;
    self.cusImageView.layer.masksToBounds =YES;
    
    self.cusImageView.layer.cornerRadius =self.cusImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
