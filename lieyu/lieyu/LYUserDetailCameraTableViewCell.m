//
//  LYUserDetailCameraTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/6.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserDetailCameraTableViewCell.h"

@implementation LYUserDetailCameraTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *str = @"精彩从头像开始";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(3, 2.99)];
    self.label_title.attributedText = attributedStr;
    
    self.btn_userImage.layer.cornerRadius = 61/2.0;
    self.btn_userImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
