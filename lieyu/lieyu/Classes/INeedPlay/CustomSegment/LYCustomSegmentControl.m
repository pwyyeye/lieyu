//
//  LYCustomSegmentControl.m
//  lieyu
//
//  Created by newfly on 9/27/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCustomSegmentControl.h"
#import "PFImage.h"

@interface LYCustomSegmentControl ()

@property(nonatomic,strong)NSMutableArray * aryList;

@end

@implementation LYCustomSegmentControl

- (LYCustomSegmentControl *)initWithTitleItems:(NSArray *)ary frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat w = frame.size.width / ary.count;
        _aryList = [NSMutableArray new];
        for (int i = 0;i< ary.count;i++)
        {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(i*w, 0, w, frame.size.height);
            btn.tag = i;
            [btn setTitle:ary[i] forState:UIControlStateNormal];
            [btn setTitle:ary[i] forState:UIControlStateSelected];
            [_aryList addObject:btn];
            [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    for (UIButton * item in _aryList) {
        UIImage * image = [PFImage imageWithColor:selectedColor size:item.bounds.size];
        [item setBackgroundImage:image forState:UIControlStateSelected];

    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    for (UIButton * item in _aryList) {
        [item setTitleColor:titleColor forState:UIControlStateNormal];
        [item setTitleColor:titleColor forState:UIControlStateSelected];
    }
}

- (void)setFont:(UIFont *)font
{
    for (UIButton * item in _aryList) {
        item.titleLabel.font = font;
    }
}

- (void)updateBtnStatus:(UIButton *)curButton
{
    for (UIButton * item in self.aryList) {
        if (item != curButton) {
            item.selected = NO;
        }
    }
    curButton.selected = YES;
}

- (void)selectedItem:(UIButton *)btn
{
    _selectedIndex = btn.tag;
    [self updateBtnStatus:btn];
    if (self.selectedItem) {
        _selectedItem(btn.tag);
    }
}

- (UIButton *)itemOfIndex:(NSInteger )index
{
    for (UIButton * item in self.aryList) {
        if (item.tag == index) {
            return item;
        }
    }
    return nil;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    UIButton * item = [self itemOfIndex:selectedIndex];
    [self updateBtnStatus:item];
}

- (NSString *)selectedItemTitle
{
    UIButton * btn = [self itemOfIndex:_selectedIndex];
    return btn.titleLabel.text;
}

- (void)dealloc
{
    self.selectedItem = nil;
}

@end



