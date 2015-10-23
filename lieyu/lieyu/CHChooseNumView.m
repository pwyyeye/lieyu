//
//  CHChooseNumView.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHChooseNumView.h"

@implementation CHChooseNumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)jiaAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    count++;
    self.numLal.text=[NSString stringWithFormat:@"%d",count];
    
}

- (IBAction)jianAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    if (count>1) {
        count--;
    }
    self.numLal.text=[NSString stringWithFormat:@"%d",count];
    
}

@end
