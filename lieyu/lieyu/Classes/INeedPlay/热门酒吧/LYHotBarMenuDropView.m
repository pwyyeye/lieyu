//
//  LYHotBarMenuDropView.m
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarMenuDropView.h"
#import "MenuButton.h"

@implementation LYHotBarMenuDropView

- (void)deployWithItemArrayWith:(NSArray *)itemArray{
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0 ; i < itemArray.count; i ++) {
        MenuButton *dropBtn = [[MenuButton alloc]init];
        dropBtn.frame = CGRectMake(i%3 * ((SCREEN_WIDTH - 50) / 3 + 18) + 7, i/3 * 50 + 20, (SCREEN_WIDTH - 50) / 3, 34);
        dropBtn.layer.borderWidth = 0.5;
        dropBtn.layer.borderColor = RGBA(151, 151, 151, 1).CGColor;
        dropBtn.layer.cornerRadius = 2;
        dropBtn.layer.masksToBounds = YES;
        dropBtn.tag = i;
        [dropBtn setTitle:itemArray[i] forState:UIControlStateNormal];
        dropBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [dropBtn setTitleColor:RGBA(26, 26, 26, 1) forState:UIControlStateNormal];
        [self addSubview:dropBtn];
        [_btnArray addObject:dropBtn];
    }
}

- (void)deployWithItemArrayWith:(NSArray *)itemArray withTitle:(NSString *)title{
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0 ; i < itemArray.count; i ++) {
        MenuButton *dropBtn = [[MenuButton alloc]init];
        dropBtn.frame = CGRectMake(i%3 * ((SCREEN_WIDTH - 50) / 3 + 18) + 7, i/3 * 50 + 20, (SCREEN_WIDTH - 50) / 3, 34);
        dropBtn.layer.borderWidth = 0.5;
        dropBtn.layer.borderColor = RGBA(151, 151, 151, 1).CGColor;
        dropBtn.layer.cornerRadius = 2;
        dropBtn.layer.masksToBounds = YES;
        dropBtn.tag = i;
        [dropBtn setTitle:itemArray[i] forState:UIControlStateNormal];
        [dropBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        dropBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [dropBtn setTitleColor:RGBA(26, 26, 26, 1) forState:UIControlStateNormal];
        [self addSubview:dropBtn];
        [_btnArray addObject:dropBtn];
    }
    
    for (MenuButton *dropBtn in _btnArray) {
        if ([dropBtn.currentTitle isEqualToString:title]) {
            dropBtn.selected = YES;
        }
    }
}

/*
 */
- (void)menuClick:(MenuButton *)button{
    for (MenuButton *btn in _btnArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    if ([_delegate respondsToSelector:@selector(lyHotBarMenuButton:withIndex:)]) {
        [_delegate lyHotBarMenuButton:button withIndex:button.tag];
    }
}


@end
