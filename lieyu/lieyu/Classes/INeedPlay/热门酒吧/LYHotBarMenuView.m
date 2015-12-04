//
//  LYHotBarMenuView.m
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarMenuView.h"
#import "LYHotBarMenuDropView.h"

@implementation LYHotBarMenuView
{
    LYHotBarMenuDropView *_dropMenuView;
    NSMutableArray *_btnArray;
}

- (void)deploy{
    NSArray *titleArray = @[@"所有地区",@"音乐清吧",@"离我最近"];
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        UIButton *menuBtn = [[UIButton alloc]init];
        menuBtn.frame = CGRectMake(i%3 * 106.5, 0, 106, 40);
        [menuBtn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 69, 0, 13);
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 37);
        [menuBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menuBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        menuBtn.tag = i+1;
        [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        [_btnArray addObject:menuBtn];
    }
    for(int i = 1; i < 3; i ++){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i%3 * 106, 13, 0.5, 14)];
        lineView.backgroundColor = RGBA(204, 204, 204, 1);
        [self addSubview:lineView];
    }
    _dropMenuView = [[LYHotBarMenuDropView alloc]init];
    _dropMenuView.backgroundColor = [UIColor whiteColor];
    _dropMenuView.frame = CGRectMake(0, 40, 320, 124);
    [_dropMenuView deploy];
    for (UIButton *dropBtn in _dropMenuView.btnArray) {
        [dropBtn addTarget:self action:@selector(dropClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)dropClick:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(didClickHotBarMenuDropWithIndex:)]) {
        [_delegate didClickHotBarMenuDropWithIndex:button.tag];
    }
}

- (void)menuClick:(UIButton *)button{
    [_dropMenuView removeFromSuperview];
    UIButton *allPlace_btn = _btnArray[0];
    UIButton *music_btn = _btnArray[1];
    UIButton *aroundMe_btn = _btnArray[2];
    if ([button.currentTitle isEqualToString:@"所有地区"]) {
        if (button.tag == 1) {
            [self addSubview:_dropMenuView];
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 1;
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        }
        music_btn.tag = 2;
        aroundMe_btn.tag = 3;
        [music_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
    }else if([button.currentTitle isEqualToString:@"音乐清吧"]){
        if (button.tag == 2) {
            [self addSubview:_dropMenuView];
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            button.tag = 5;
        }else {
            button.tag = 2;
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        }
        allPlace_btn.tag = 1;
        aroundMe_btn.tag = 3;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
    }else{
        if (button.tag == 3) {
            [self addSubview:_dropMenuView];
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            button.tag = 6;
        }else {
            button.tag = 3;
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        }
        allPlace_btn.tag = 1;
        music_btn.tag = 2;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        [music_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
    }
}


@end
