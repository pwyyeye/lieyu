//
//  TimeButton.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TimeButton.h"

@implementation TimeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.titleLal.textColor=RGB(114, 5, 147);
        self.weekLal.textColor=RGB(114, 5, 147);
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.titleLal.textColor=RGB(255, 255, 255);
        self.weekLal.textColor=RGB(255, 255, 255);
        self.backgroundColor = RGB(114, 5, 147);
    }
}
@end
