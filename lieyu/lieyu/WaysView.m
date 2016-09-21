//
//  waysView.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "waysView.h"

@implementation WaysView
- (void)configure{
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, 150, 14)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = RGBA(102, 102, 102, 1);
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"拼客方式";
    
    _label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 15, 100, 14)];
    _label3.textAlignment = NSTextAlignmentRight;
    _label3.backgroundColor = [UIColor clearColor];
    _label3.textColor = COMMON_PURPLE;
    _label3.font = [UIFont systemFontOfSize:12];
    _label3.text = [NSString stringWithFormat:@"(请选择)"];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 10, 24, 24)];
    [imageView setImage:[UIImage imageNamed:@"advance"]];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(14, 43.5, SCREEN_WIDTH, 0.5)];
    label4.backgroundColor = RGB(217, 217, 217);
    
    [self addSubview:label1];
    [self addSubview:imageView];
    [self addSubview:_label3];
    [self addSubview:label4];
}

@end
