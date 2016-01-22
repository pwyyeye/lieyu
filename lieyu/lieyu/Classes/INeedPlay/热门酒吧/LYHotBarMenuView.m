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
//    self.backgroundColor = [UIColor redColor];
    self.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    NSArray *titleArray = @[@"所有地区",title,@"离我最近"];
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        MenuButton *menuBtn = [[MenuButton alloc]init];
        menuBtn.frame = CGRectMake(i % 3 * (SCREEN_WIDTH / 3), 0, SCREEN_WIDTH / 3, 40);
        [menuBtn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 69, 0, 13);
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 37);
        [menuBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menuBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [menuBtn setAdjustsImageWhenHighlighted:NO];
        menuBtn.tag = i+1;
        menuBtn.section = i + 1;
        [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        [_btnArray addObject:menuBtn];
    }
    for(int i = 1; i < 3; i ++){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i%3 * (SCREEN_WIDTH / 3), 13, 0.5, 14)];
        lineView.backgroundColor = RGBA(204, 204, 204, 1);
        [self addSubview:lineView];
    }
    _itemArray = itemArray;
    _title = title;
    
}

- (void)dropClick:(MenuButton *)button{
    if ([_delegate respondsToSelector:@selector(didClickHotBarMenuDropWithButton:dropButton:)]) {
        MenuButton *menuBtn = (MenuButton *)[self viewWithTag:4];
        if (menuBtn) {
            for (MenuButton *btn in _dropMenuView.btnArray) {
                btn.selected = NO;
                if ([btn.currentTitle isEqual:button.currentTitle]) {
                    btn.selected = YES;
                    
                }
            }
            [_delegate didClickHotBarMenuDropWithButton:menuBtn dropButton:button];
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
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 1;
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        }
        music_btn.tag = 2;
        aroundMe_btn.tag = 3;
        [music_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
    }else if(button.section == 3){
        if (button.tag == 3) {
            [self showWithSmallArray:_itemArray[2]];
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 3;
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
            [self hideWithReset:NO];
        }
        allPlace_btn.tag = 1;
        music_btn.tag = 2;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        [music_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
    }else{
        if (button.tag == 2) {
            [self showWithSmallArray:_itemArray[1]];
            [button setImage:[UIImage imageNamed:@"arrow drop up"] forState:UIControlStateNormal];
            button.tag = 4;
        }else {
            button.tag = 2;
            [button setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        }
        allPlace_btn.tag = 1;
        aroundMe_btn.tag = 3;
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
    }

}

- (void)showWithSmallArray:(NSArray *)smallArray{
    NSInteger dropHeight = (smallArray.count)/3 * 50 + 24;
    if (smallArray.count%3) {
        dropHeight =  dropHeight + 50;
    }

    self.frame = CGRectMake(0, 64, SCREEN_WIDTH, dropHeight + self.frame.size.height);
    _dropMenuView = [[LYHotBarMenuDropView alloc]init];
    _dropMenuView.backgroundColor = [UIColor whiteColor];
//    _dropMenuView.backgroundColor = [UIColor cyanColor];
    _dropMenuView.frame = CGRectMake(0, 40,SCREEN_WIDTH, dropHeight );
    [_dropMenuView deployWithItemArrayWith:smallArray];
    for (MenuButton *dropBtn in _dropMenuView.btnArray) {
        [dropBtn addTarget:self action:@selector(dropClick:) forControlEvents:UIControlEventTouchUpInside];
         if([dropBtn.currentTitle isEqualToString:_selectTitle]){
            dropBtn.selected = YES;
        }
    }
    [self addSubview:_dropMenuView];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = RGBA(230, 230, 230, 1);
    lineLabel.tag = 100;
    [self addSubview:lineLabel];
}

- (void)hideWithReset:(BOOL)reset{
    self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    UILabel *lineLabel = [self viewWithTag:100];
    if (lineLabel) {
        [lineLabel removeFromSuperview];
    }
    [_dropMenuView removeFromSuperview];
    if (reset) {
        UIButton *allPlace_btn = _btnArray[0];
        UIButton *music_btn = _btnArray[1];
        UIButton *aroundMe_btn = _btnArray[2];
        [allPlace_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        [music_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        [aroundMe_btn setImage:[UIImage imageNamed:@"arrow drop down"] forState:UIControlStateNormal];
        allPlace_btn.tag = 1;
        music_btn.tag = 2;
        aroundMe_btn.tag = 3;
    }
}


@end
