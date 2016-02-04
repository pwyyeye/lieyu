//
//  HotMenuButton.m
//  lieyu
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HotMenuButton.h"

@implementation HotMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsMenuSelected:(BOOL)isMenuSelected{
    _isMenuSelected = isMenuSelected;
    if (isMenuSelected) {
        [self setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
//        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }else{
        [self setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setIsHomePageMenuViewSelected:(BOOL)isHomePageMenuViewSelected{
    _isHomePageMenuViewSelected = isHomePageMenuViewSelected;
    if (isHomePageMenuViewSelected) {
        [self setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }else{
        [self setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setIsFriendsMenuViewSelected:(BOOL)isFriendsMenuViewSelected{
    _isFriendsMenuViewSelected = isFriendsMenuViewSelected;
    if (isFriendsMenuViewSelected) {
        [self setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }else{
        [self setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
//        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

@end
