//
//  PayButton.m
//  lieyu
//
//  Created by 狼族 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PayButton.h"

@implementation PayButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        [self setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected.png"] forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"CustomBtn_unSelected.png"] forState:UIControlStateNormal];
    }
}

@end
