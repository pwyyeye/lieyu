//
//  AudienceCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/6.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AudienceCell.h"

@implementation AudienceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconButton = [[UIImageView alloc] init];
        _iconButton.frame = self.bounds;
        _iconButton.backgroundColor = [UIColor clearColor];
        self.iconButton.userInteractionEnabled = NO;
        [self addSubview:_iconButton];
        self.detailButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.detailButton.backgroundColor = [UIColor clearColor];
        self.detailButton.frame = self.bounds;
        [self.contentView addSubview:self.detailButton];
    }
    return self;
}


-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
  
    [self setCornerRadiusView:self.iconButton With:self.iconButton.frame.size.height / 2  and:YES];
    [_iconButton sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

@end
