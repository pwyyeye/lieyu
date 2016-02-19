//
//  HDDetailImageCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDDetailImageCell.h"

@implementation HDDetailImageCell

- (void)awakeFromNib {
    _image.layer.cornerRadius = 2;
    _image.layer.masksToBounds = YES;
//    _image.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureImageView:(NSString *)imageUrl{
//    [_image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
//    _image.image = [UIImage imageNamed:@"zhanwei"];
    _image.image = [UIImage imageNamed:@"zhanwei2"];
    float height = CGRectGetHeight(_image.frame);
    float width = CGRectGetWidth(_image.frame);
    float bili = height / width ;
    _image.frame = CGRectMake(12, _image.frame.origin.y, SCREEN_WIDTH - 24, (SCREEN_WIDTH - 24) * bili);
//    NSLog(@"%@",NSStringFromCGRect(_image.frame));
}

@end
