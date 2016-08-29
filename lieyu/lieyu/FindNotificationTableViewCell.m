//
//  FindNotificationTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationTableViewCell.h"

@implementation FindNotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _label_badge.layer.cornerRadius = CGRectGetHeight(_label_badge.frame)/2.f;
    _label_badge.layer.masksToBounds = YES;
    _imgView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
