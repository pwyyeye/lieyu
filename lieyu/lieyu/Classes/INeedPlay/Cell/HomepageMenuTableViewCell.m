//
//  HomepageMenuTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomepageMenuTableViewCell.h"

@implementation HomepageMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _strategyButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    _strategyButton.layer.shadowOffset = CGSizeMake(0, 1);
    _strategyButton.layer.shadowOpacity = 0.3;
    
    _hotButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    _hotButton.layer.shadowOffset = CGSizeMake(0, 1);
    _hotButton.layer.shadowOpacity = 0.3;
    
    _recentButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    _recentButton.layer.shadowOffset = CGSizeMake(0, 1);
    _recentButton.layer.shadowOpacity = 0.3;
    
    for (UIImageView *imageView in _filterArray) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.masksToBounds = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagesArray:(NSArray *)imagesArray{
    int i = 0 ;
    for (UIImageView *imageView in _filterArray) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imagesArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        i ++ ;
    }
}

@end
