//
//  KaZuoView.m
//  lieyu
//
//  Created by SEM on 15/9/18.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "KaZuoView.h"

@implementation KaZuoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)noKaZuoAct:(UIButton *)sender {
    self.NoKaZuoBtn.selected=YES;
    self.YesKaZuoBtn.selected=NO;
    
}

- (IBAction)YesKaZuoAct:(UIButton *)sender {
    self.NoKaZuoBtn.selected=NO;
    self.YesKaZuoBtn.selected=YES;
}
@end
