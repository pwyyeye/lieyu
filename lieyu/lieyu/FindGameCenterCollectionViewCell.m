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
    UIView *lineView = [[UIView alloc]init];
    CGFloat viewWidth = SCREEN_WIDTH/3.f;
        CGFloat viewHeight = SCREEN_WIDTH/3.f * 155 /125.f;
    lineView.frame = CGRectMake(viewWidth - 1, 0, 1, viewHeight);
    lineView.backgroundColor = RGBA(237, 237, 237, 1);
    [self addSubview:lineView];
}

@end
