//
//  HeaderTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    _avatar_image.layer.cornerRadius = _avatar_button.frame.size.width / 2;
    _avatar_image.layer.masksToBounds = YES;
//    self.backView.layer.cornerRadius = 2;
//    self.backView.layer.masksToBounds = YES;
    self.backView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
