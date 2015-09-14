//
//  FunctionListCell.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FunctionListCell.h"

@implementation FunctionListCell

- (void)awakeFromNib {
    self.mesImageView.layer.masksToBounds =YES;
    
    self.mesImageView.layer.cornerRadius =self.mesImageView.frame.size.width/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
