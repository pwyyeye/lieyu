//
//  LYBarScrollTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarScrollTableViewCell.h"
#import "UIButton+WebCache.h"
#import "BarActivityList.h"
#import "BarTopicInfo.h"

@implementation LYBarScrollTableViewCell

- (void)awakeFromNib {
    // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
//    _scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_scrollView];
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    _activtyBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)setActivtyArray:(NSArray *)activtyArray{
    _activtyArray = activtyArray;
    CGFloat imgVWidth = 160;
    [_activtyBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if(obj)   [obj removeFromSuperview];
    }];
    [_activtyBtnArray removeAllObjects];
    
    switch (activtyArray.count) {
        case 1:{
            //UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - imgVWidth)/2.f, 8, imgVWidth, 213)];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,self.frame.size.height )];
            BarActivityList *activityL = _activtyArray.firstObject;
            [btn sd_setImageWithURL:[NSURL URLWithString:activityL.imageUrl]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;        [_activtyBtnArray addObject:btn];
            [_scrollView addSubview:btn];
            UIImageView *hotImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 4 - 32, 4, 32, 32)];
            hotImgV.image = [UIImage imageNamed:@"HOT"];
            hotImgV.hidden = YES;
            [btn addSubview:hotImgV];
            _scrollView.scrollEnabled = NO;
        }
            break;
        default:{
            for (int i = 0; i < activtyArray.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i % activtyArray.count * (imgVWidth + 8) +8 , 0, imgVWidth, 213)];
                BarActivityList *activityL = _activtyArray[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:activityL.imageUrl]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;         [_activtyBtnArray addObject:btn];
                [_scrollView addSubview:btn];
                UIImageView *hotImgV = [[UIImageView alloc]initWithFrame:CGRectMake(imgVWidth - 4 - 32, 4, 32, 32)];
                hotImgV.image = [UIImage imageNamed:@"HOT"];
                hotImgV.hidden = YES;
                [btn addSubview:hotImgV];
            }
            UIButton *lastBtn = _activtyBtnArray.lastObject;
            [_scrollView setContentSize:CGSizeMake(CGRectGetMaxX(lastBtn.frame), 0)];
                        _scrollView.scrollEnabled = YES;
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
