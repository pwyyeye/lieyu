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
    
    self.titleLabel.font=[UIFont systemFontOfSize:13];
    [self setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=13;
    self.layer.borderWidth=0.5;
    self.layer.borderColor=RGB(179, 179, 179).CGColor;
    
    [self setBackgroundImage:[MyUtil getImageFromColor:RGB(247, 138, 79)] forState:UIControlStateSelected];
    [self setBackgroundImage:[MyUtil getImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectedClick:(UIButton *)button{
    if (self.selected==YES) {
        self.selected=NO;
        
    }else{
        self.selected=YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseButton:andSelected:)]) {
        [self.delegate chooseButton:self andSelected:self.selected];
    }
    
}
@end
