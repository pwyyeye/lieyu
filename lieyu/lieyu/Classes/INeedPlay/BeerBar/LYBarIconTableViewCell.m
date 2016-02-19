//
//  LYBarIconTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarIconTableViewCell.h"
#import "UIButton+WebCache.h"
#import "CustomerModel.h"

@implementation LYBarIconTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat btnWidth = (SCREEN_WIDTH - 16 - (_btnArray.count - 1) * 7)/_btnArray.count;
    for (UIButton *btn in _btnArray) {
        btn.hidden = YES;
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
    }
    UIButton *lastBtn = [_btnArray lastObject];
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(lastBtn.frame.origin.x, lastBtn.frame.origin.y, btnWidth, btnWidth)];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _moreBtn.backgroundColor = RGBA(186, 40,227, .5);
    [self addSubview:_moreBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
     CGFloat btnWidth = (SCREEN_WIDTH - 16 - (_btnArray.count - 1) * 7)/_btnArray.count;
    UIButton *lastBtn = [_btnArray lastObject];
    _moreBtn.frame = CGRectMake(lastBtn.frame.origin.x, lastBtn.frame.origin.y, btnWidth, btnWidth);
    _moreBtn.layer.cornerRadius = btnWidth/2.f;

}

- (void)setIconArray:(NSArray *)iconArray{
    _iconArray = iconArray;
    [_moreBtn setTitle:[NSString stringWithFormat:@"%u",iconArray.count] forState:UIControlStateNormal];
    if(iconArray.count < 7) _moreBtn.hidden = YES;
    for (int i = 0; i < iconArray.count; i ++) {
        UIButton *btn = _btnArray[i];
        CustomerModel *customerM = iconArray[i];
        btn.hidden = NO;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:customerM.userInfo.avatar_img] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
