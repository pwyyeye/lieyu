//
//  CityChooseButton.m
//  lieyu
//
//  Created by pwy on 15/11/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CityChooseButton.h"

@implementation CityChooseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:RGB(149, 149, 149) forState:UIControlStateNormal];
//    [self setTitleColor:COMMON_PURPLE forState:UIControlStateSelected];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 17;
    self.layer.borderWidth = 1;
    self.layer.borderColor = COMMON_GRAY.CGColor;
    
//    [self setBackgroundImage:[MyUtil getImageFromColor:RGB(35, 166, 116)] forState:UIControlStateSelected];
//    [self setBackgroundImage:[MyUtil getImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)selectedClick:(UIButton *)button{
    if (self.selected==YES) {
        self.selected=NO;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = COMMON_GRAY.CGColor;
    }else{
        self.selected=YES;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = COMMON_PURPLE.CGColor;
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseButton:andSelected:)]) {
        [self.delegate chooseButton:self andSelected:self.selected];
    }
    
}

@end
