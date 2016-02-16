//
//  LYBarIconTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarIconTableViewCell.h"

@implementation LYBarIconTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat btnWidth = (SCREEN_WIDTH - 16 - (_btnArray.count - 1) * 7)/_btnArray.count;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
    }
    
    UIButton *lastBtn = [_btnArray lastObject];
    _moreBtn = [[UIButton alloc]initWithFrame:lastBtn.frame];
    _moreBtn.backgroundColor = RGBA(186, 40,227, 1);
    [self addSubview:_moreBtn];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
