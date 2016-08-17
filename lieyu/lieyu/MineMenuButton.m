//
//  MineMenuButton.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineMenuButton.h"

#define buttonWidth self.bounds.size.width
#define buttonHeight self.bounds.size.height

@implementation MineMenuButton


-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(buttonWidth / 2 - 13, 15, 26, 26)];
//    _iconImage.backgroundColor = [UIColor redColor];
    [_iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_iconImage];
    [_iconImage setImage:[UIImage imageNamed:_imageUrl]];
}

- (void)setMenuName:(NSString *)menuName{
    NSLog(@"%f ----- %f",buttonWidth,buttonHeight);
    _menuName = menuName;
    _menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 56, buttonWidth, 19)];
    [_menuLabel setTextAlignment:NSTextAlignmentCenter];
    [_menuLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_menuLabel];
    [_menuLabel setText:_menuName];
}

@end
