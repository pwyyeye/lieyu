//
//  LYYUTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUTableViewCell.h"

@implementation LYYUTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(60, 171, SCREEN_WIDTH - 60 - 16, 0.5)];
    lineView.backgroundColor = RGBA(204, 204, 204, 1);
    [self.view_cell addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
