//
//  LPOrderButton.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrderButton.h"

@implementation LPOrderButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, self.frame.size.height - 2, self.frame.size.width - 28, 2)];
        [_lineLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lineLabel];
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 6, 6, 6)];
        [_pointLabel setBackgroundColor:RGBA(240, 55, 118, 1)];
        _pointLabel.layer.cornerRadius = 3;
        _pointLabel.layer.masksToBounds = YES;
        _pointLabel.hidden = YES;
        [self addSubview:_pointLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        [self setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
        [_lineLabel setBackgroundColor:COMMON_PURPLE];
    }else{
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_lineLabel setBackgroundColor:[UIColor clearColor]];
    }
}

@end
