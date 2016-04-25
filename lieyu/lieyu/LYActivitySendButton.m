//
//  LYActivitySendButton.m
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYActivitySendButton.h"

@implementation LYActivitySendButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsActivitySelect:(BOOL)isActivitySelect{
    _isActivitySelect = isActivitySelect;
    if (_isActivitySelect) {
        self.backgroundColor = RGBA(178, 38, 217, 1);
        self.layer.borderWidth = 0.f;
         [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = RGBA(144, 153, 167, 1).CGColor;
        self.layer.borderWidth = 0.5f;
         [self setTitleColor:RGBA(73, 82, 91, 1) forState:UIControlStateNormal];
    }
}

@end
