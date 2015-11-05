//
//  AlertBlock.m
//  lieyu
//
//  Created by 薛斯岐 on 15/11/5.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AlertBlock.h"

@implementation AlertBlock
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles block:(TouchBlock)block{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];//注意这里初始化父类的
    if (self) {
        self.block = block;
    }
    return self;
}

//#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //这里调用函数指针_block(要传进来的参数);
    _block(buttonIndex);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
