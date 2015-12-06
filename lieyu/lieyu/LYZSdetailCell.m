//
//  LYZSdetailCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYZSdetailCell.h"
#import "UIImageView+WebCache.h"

@implementation LYZSdetailCell

- (void)awakeFromNib {
    _imagesArray = @[_iconStar1,_iconStar2,_iconStar3,_iconStar4,_iconStar5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigure:(ZSDetailModel *)ZSModel{
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:ZSModel.avatar_img] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLal.text = ZSModel.usernick;
    self.biaoqianLal.text = ZSModel.introduction;
    for (UIImageView *image in _imagesArray) {
        [image setImage:[UIImage imageNamed:@"icon_star"]];
    }
}

@end
