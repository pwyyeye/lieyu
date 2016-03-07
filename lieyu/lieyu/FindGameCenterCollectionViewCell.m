//
//  FindGameCenterCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindGameCenterCollectionViewCell.h"

@implementation FindGameCenterCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *_lineView_right = [[UIView alloc]init];
    CGFloat viewWidth = SCREEN_WIDTH/3.f;
        CGFloat viewHeight = SCREEN_WIDTH/3.f * 155 /125.f;
    _lineView_right.frame = CGRectMake(viewWidth - 1, 0, 1, viewHeight);
    _lineView_right.backgroundColor = RGBA(237, 237, 237, 1);
    [self addSubview:_lineView_right];
    
    UIView *_lineView_bottom = [[UIView alloc]init];
    _lineView_bottom.frame = CGRectMake(0, viewHeight - 1, viewWidth, 1);
    _lineView_bottom.backgroundColor = RGBA(237, 237, 237, 1);
    [self addSubview:_lineView_bottom];
}

@end
