//
//  AudienceCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/6.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AudienceCell.h"

@implementation AudienceCell

-(void)layoutSubviews
{ 
    _iconButton = [[UIImageView alloc] init];
    _iconButton.frame = self.bounds;
    _iconButton.backgroundColor = [UIColor clearColor];
    [_iconButton setImage:[UIImage imageNamed:@"lieyu_default_head"]];
    [self.contentView addSubview:_iconButton];
    [self setCornerRadiusView:self.iconButton With:self.iconButton.frame.size.height / 2  and:YES];
    self.iconButton.userInteractionEnabled = NO;
    
    self.detailButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.detailButton.backgroundColor = [UIColor clearColor];
    self.detailButton.frame = self.bounds;
    [self.contentView addSubview:self.detailButton];
    
}

//-(void)setImageUrl:(NSString *)imageUrl
//{
//    if (!_imageUrl) {
//        _imageUrl = imageUrl;
//        [_iconButton sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//    }
//}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

@end
