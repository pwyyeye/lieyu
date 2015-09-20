//
//  PacketBarCell.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PacketBarCell.h"

@implementation PacketBarCell

- (void)awakeFromNib {
    // Initialization code
    _labFanli.layer.cornerRadius = 10.0f;
    _labFanli.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
