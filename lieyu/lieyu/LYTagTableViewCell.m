//
//  LYTagTableViewCell.m
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagTableViewCell.h"

@implementation LYTagTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.btn_custom setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    self.btn_custom.layer.masksToBounds=YES;
    self.btn_custom.layer.cornerRadius=2;
    self.btn_custom.layer.borderWidth=0.5;
    self.btn_custom.layer.borderColor=RGB(233, 233, 233).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
