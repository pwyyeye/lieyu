//
//  LYPeopleNumberButton.m
//  lieyu
//
//  Created by 狼族 on 16/6/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPeopleNumberButton.h"

@implementation LYPeopleNumberButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected{
    _choosed = selected;
    if (selected == YES) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:RGBA(186, 40, 227, 1)];
        self.layer.borderWidth = 0;
    }else if (selected == NO){
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [RGBA(186, 40, 227, 1)CGColor];
    }
}

@end
