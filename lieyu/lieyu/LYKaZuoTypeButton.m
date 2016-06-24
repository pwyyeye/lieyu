//
//  LYKaZuoTypeButton.m
//  lieyu
//
//  Created by 狼族 on 16/5/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYKaZuoTypeButton.h"

@implementation LYKaZuoTypeButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected{
    _choosed = selected;
    if (selected == YES) {
        [self setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [RGBA(186,40,227,1)CGColor];
    }else if (selected == NO){
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }
}

@end
