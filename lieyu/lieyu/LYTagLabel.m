//
//  LYTagLabel.m
//  lieyu
//
//  Created by 狼族 on 15/12/23.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagLabel.h"

@implementation LYTagLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(int)selected{
    _selected = selected;
    if (_selected) {
        self.backgroundColor = COMMON_PURPLE;
        self.textColor = RGBA(255,255,255, 1);
    }else{
        self.backgroundColor = RGBA(255, 255, 255, 1);
        self.textColor = RGBA(102,102,102, 1);
    }
}

@end
