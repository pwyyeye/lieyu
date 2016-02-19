//
//  HDZTHeaderCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDZTHeaderCell.h"
#import "UIImageView+WebCache.h"
@implementation HDZTHeaderCell

- (void)awakeFromNib {
    _action_image.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTopicInfo:(BarTopicInfo *)topicInfo{
    [_action_image sd_setImageWithURL:[NSURL URLWithString:topicInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    _action_discript.text = topicInfo.name;
}

@end
