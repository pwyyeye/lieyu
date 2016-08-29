//
//  InputTextFieldView.m
//  lieyu
//
//  Created by 狼族 on 16/8/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "InputTextFieldView.h"

@implementation InputTextFieldView


-(void)layoutSubviews{
    self.inputTextField = [[UITextField alloc] initWithFrame:(CGRectMake(20, 3, self.frame.size.width - 40, self.frame.size.height - 6))];
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
    [self addSubview:_inputTextField];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
