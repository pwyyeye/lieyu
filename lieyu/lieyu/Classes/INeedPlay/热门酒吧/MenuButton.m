//
//  MenuButton.m
//  lieyu
//
//  Created by 狼族 on 15/12/5.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected{
    if (selected) {
        [self setTitleColor:RGBA(255, 255,225  , 1) forState:UIControlStateNormal];
        self.backgroundColor = COMMON_PURPLE;
    }else{
        self.backgroundColor = RGBA(255, 255, 255, 1);
        [self setTitleColor:RGBA(26, 26, 26, 1) forState:UIControlStateNormal];
    }

}

@end
