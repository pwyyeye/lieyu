//
//  SignIconTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SignIconTableViewCell.h"

@implementation SignIconTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.shouldRasterize = YES;
    CGFloat btnWidth = (SCREEN_WIDTH - 64 - 12 - 4 * 19) / 5.f;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
    }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews{
    
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = COMMON_PURPLE;
    [color set];
    UIBezierPath *cPath = [UIBezierPath bezierPathWithRect:CGRectMake(30, -1, 4, 200)];
    [cPath fill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
