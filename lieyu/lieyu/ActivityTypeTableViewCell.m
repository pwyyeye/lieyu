//
//  ActivityTypeTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityTypeTableViewCell.h"

@implementation ActivityTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _partyLabel.hidden = YES;
    _barActivityLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end