//
//  LYUserTagButton.m
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserTagButton.h"

@implementation LYUserTagButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_usertag!=NULL) {
        [self setTitle:_usertag.name forState:UIControlStateNormal];
    }
}


@end
