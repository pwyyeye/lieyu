//
//  LYBarScrollTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarScrollTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation LYBarScrollTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_scrollView];
    
    _activtyBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)setActivtyArray:(NSArray *)activtyArray{
    activtyArray = _activtyArray;
    CGFloat imgVWidth = 160;
    switch (activtyArray.count) {
        case 1:{
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - imgVWidth)/2.f, 8, imgVWidth, 213)];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:_activtyBtnArray.firstObject]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
            [_activtyBtnArray addObject:btn];
            [_scrollView addSubview:btn];
        }
            break;
        default:{
            for (int i = 0; i < activtyArray.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i % activtyArray.count * imgVWidth + 8 , 8, imgVWidth, 213)];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:_activtyBtnArray.firstObject]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
                [_activtyBtnArray addObject:btn];
                [_scrollView addSubview:btn];
            }
            UIButton *lastBtn = _activtyBtnArray.lastObject;
            [_scrollView setContentSize:CGSizeMake(CGRectGetMaxY(lastBtn.frame), 213 + 16)];
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
