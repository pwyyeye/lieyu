//
//  LYFriendsChangeImageMenuView.m
//  lieyu
//
//  Created by 狼族 on 15/12/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsChangeImageMenuView.h"

@implementation LYFriendsChangeImageMenuView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [UIView animateWithDuration:1 animations:^{
        self.menuViewConstraint.constant = 0;
    }];
}

- (void)updateConstraints{
    [super updateConstraints];
}

@end
