//
//  LYHotBarMenuView.m
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarMenuView.h"

@implementation LYHotBarMenuView
- (void)deploy{
    NSArray *titleArray = @[@"所有地区",@"音乐清吧",@"离我最近"];
    for (int i = 0; i < 3; i ++) {
        UIButton *menuBtn = [[UIButton alloc]init];
        menuBtn.frame = CGRectMake(i%3 * 80 +13, 11, 80, 24);
        [menuBtn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80-24, 0, 0);
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 24);
//        menuBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [menuBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menuBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        menuBtn.backgroundColor = [UIColor redColor];
        [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
    }
}

- (void)menuClick:(UIButton *)button{
    NSLog(@"00000");
}

@end
