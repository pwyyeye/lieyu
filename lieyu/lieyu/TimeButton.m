//
//  TimeButton.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TimeButton.h"

@implementation TimeButton
- (void)awakeFromNib{
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.titleLal.textColor=COMMON_PURPLE;
        self.weekLal.textColor=COMMON_PURPLE;
        self.backgroundColor = [UIColor whiteColor];
        _lineView.backgroundColor = COMMON_PURPLE;
    }else{
        self.titleLal.textColor=RGB(102, 102, 102);
        self.weekLal.textColor=RGB(102, 102, 102);
        self.backgroundColor = [UIColor whiteColor];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
}
@end
