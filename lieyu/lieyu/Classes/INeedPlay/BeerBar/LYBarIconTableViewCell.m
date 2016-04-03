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
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen]scale];
    CGFloat btnWidth = (SCREEN_WIDTH - 14 - (_btnArray.count - 1) * 7)/_btnArray.count;
    for (UIButton *btn in _btnArray) {
        btn.hidden = YES;
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = RGBA(243, 243, 243, 1).CGColor;
        btn.layer.borderWidth = 0.5;
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
    
    if(iconArray.count < 7) _moreBtn.hidden = YES;
    for (int i = 0; i < iconArray.count; i ++) {
        if(i >= 7) return;
        UIButton *btn = _btnArray[i];
        CustomerModel *customerM = iconArray[i];
        btn.hidden = NO;
        if ([customerM.userInfo.avatar_img isEqualToString:@""]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"CommonIcon"] forState:UIControlStateNormal];
        }else{
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:customerM.userInfo.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
            
        }
    }
}

- (void)setSignCount:(NSInteger )signCount{
    _signCount = signCount;
    [_moreBtn setTitle:[NSString stringWithFormat:@"%ld",signCount] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
