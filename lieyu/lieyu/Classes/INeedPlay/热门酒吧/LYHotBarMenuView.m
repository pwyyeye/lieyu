//
//  LYHotBarMenuView.m
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarMenuView.h"
#import "LYHotBarMenuDropView.h"
#import "MenuButton.h"

@interface LYHotBarMenuView()
@property (nonatomic,strong) NSArray *itemArray;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *selectTitle;
@property (nonatomic,copy) NSString *clickTitle;
@end

@implementation LYHotBarMenuView
{
    LYHotBarMenuDropView *_dropMenuView;
    NSMutableArray *_btnArray;
}

- (void)deployWithMiddleTitle:(NSString *)title ItemArray:(NSArray *)itemArray{
  //  self.backgroundColor = [UIColor redColor];
    NSArray *titleArray = @[@"所有地区",title,@"离我最近"];
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        MenuButton *menuBtn = [[MenuButton alloc]init];
        menuBtn.frame = CGRectMake(i%3 * 106.5, 0, 106, 40);
        [menuBtn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 69, 0, 13);
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 37);
        [menuBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menuBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        menuBtn.tag = i+1;
        menuBtn.section = i + 1;
        [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        [_btnArray addObject:menuBtn];
    }
    for(int i = 1; i < 3; i ++){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i%3 * 106, 13, 0.5, 14)];
        lineView.backgroundColor = RGBA(204, 204, 204, 1);
        [self addSubview:lineView];
    }
    _itemArray = itemArray;
    _title = title;
    
}

- (void)dropClick:(MenuButton *)button{
    if ([_delegate respondsToSelector:@selector(didClickHotBarMenuDropWithButtonSection:dropButtonIndex:)]) {
        MenuButton *menuBtn = (MenuButton *)[self viewWithTag:4];
        if (menuBtn) {
            for (MenuButton *btn in _dropMenuView.btnArray) {
                btn.selected = NO;
                if ([btn.currentTitle isEqual:button.currentTitle]) {
                    NSLog(@"-%@-----------%@",btn.currentTitle,button.currentTitle);
                    btn.selected = YES;
                    
                }
            }
            [_delegate didClickHotBarMenuDropWithButtonSection:menuBtn.section dropButtonIndex:button.tag];
            [menuBtn setTitle:button.currentTitle forState:UIControlStateNormal];
            _selectTitle = button.currentTitle;
            [self hideWithReset:YES];
        }
    }
}

- (void)menuClick:(MenuButton *)button{
    [self hideWithReset:NO];
        _selectTitle = button.currentTitle;
    UIButton *allPlace_btn = _btnArray[0];
    UIButton *music_btn = _btnArray[1];
    UIButton *aroundMe_btn = _btnArray[2];
    if (button.section == 1) {
        if (button.tag == 1) {
            [self showWithSmallArray:_itemArray[0]];
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
    }else if(button.section == 3){
        if (button.tag == 3) {
            [self showWithSmallArray:_itemArray[2]];
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 3;
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
            [self hideWithReset:NO];
        }
        allPlace_btn.tag = 1;
        music_btn.tag = 2;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        [music_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
    }else{
        if (button.tag == 2) {
            [self showWithSmallArray:_itemArray[1]];
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 2;
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        }
        allPlace_btn.tag = 1;
        aroundMe_btn.tag = 3;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
    }

}

- (void)showWithSmallArray:(NSArray *)smallArray{
    NSInteger dropHeight = (smallArray.count)/3 * 62;
    if (smallArray.count%3) {
        dropHeight =  dropHeight + 62;
    }

    self.frame = CGRectMake(0, 64, 320, dropHeight + 40);
    _dropMenuView = [[LYHotBarMenuDropView alloc]init];
    _dropMenuView.backgroundColor = [UIColor whiteColor];
    _dropMenuView.frame = CGRectMake(0, 40, 320,dropHeight );
    [_dropMenuView deployWithItemArrayWith:smallArray];
    for (MenuButton *dropBtn in _dropMenuView.btnArray) {
        [dropBtn addTarget:self action:@selector(dropClick:) forControlEvents:UIControlEventTouchUpInside];
         if([dropBtn.currentTitle isEqualToString:_selectTitle]){
            dropBtn.selected = YES;
        }
    }
    [self addSubview:_dropMenuView];
}

- (void)hideWithReset:(BOOL)reset{
    self.frame = CGRectMake(0, 64, 320, 40);
    [_dropMenuView removeFromSuperview];
    if (reset) {
        UIButton *allPlace_btn = _btnArray[0];
        UIButton *music_btn = _btnArray[1];
        UIButton *aroundMe_btn = _btnArray[2];
        allPlace_btn.tag = 1;
        music_btn.tag = 2;
        aroundMe_btn.tag = 3;
    }
}


@end
