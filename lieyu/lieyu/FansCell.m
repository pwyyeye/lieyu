//
//  FansCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFansModel:(FansModel *)fansModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:fansModel.avatar_img]];
    self.nameLabel.text = fansModel.usernick;
    self.firstLabel.text = @"狮子座";
    self.secondLabel.text = @"互联网";
    
}

-(void)layoutSubviews
{
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.focusButton.layer.cornerRadius = 3.f;
    self.focusButton.layer.masksToBounds = YES;
    
}
@end
