//
//  MyChooseZSCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyChooseZSCell.h"

@implementation MyChooseZSCell

- (void)awakeFromNib {
    self.userImageView.layer.masksToBounds =YES;
    
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
