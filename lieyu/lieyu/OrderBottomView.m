//
//  OrderBottomView.m
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "OrderBottomView.h"

@implementation OrderBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _btn_not.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _btn_not.layer.borderWidth = 0.5f;
}




@end
