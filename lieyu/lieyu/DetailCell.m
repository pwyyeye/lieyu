//
//  DetailCell.m
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (void)awakeFromNib {
    self.detImageView.layer.masksToBounds =YES;
    
    self.detImageView.layer.cornerRadius =self.detImageView.frame.size.width/2;
    
//    self.lineLal.height=0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
