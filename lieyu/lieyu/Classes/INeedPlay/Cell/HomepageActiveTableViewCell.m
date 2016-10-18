//
//  HomepageActiveTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomepageActiveTableViewCell.h"

@implementation HomepageActiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_topicImage setContentMode:UIViewContentModeScaleAspectFill];
    _topicImage.layer.masksToBounds = YES;
    
    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.contentView.layer.shadowOpacity = 0.3;
    
    _topicName.hidden = YES;
    _maskImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopicModel:(RecommendedTopic *)topicModel{
    _topicModel = topicModel;
    [_topicImage sd_setImageWithURL:[NSURL URLWithString:topicModel.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
//    [_topicName setText:_topicModel.name];
}

@end
