//
//  QRCheckOrderHeader.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "QRCheckOrderHeader.h"
#import "UIImageView+WebCache.h"
@implementation QRCheckOrderHeader

- (void)awakeFromNib {
    _user_avater.layer.cornerRadius = CGRectGetHeight(_user_avater.frame) / 2;
    _user_avater.layer.masksToBounds = YES;
    _IsSelected.selected = NO;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 82) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4) ];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 6, 82);
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderinfo:(OrderInfoModel *)orderinfo{
    [_user_avater sd_setImageWithURL:[NSURL URLWithString:orderinfo.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _OrderNumber.text = [NSString stringWithFormat:@"%d",orderinfo.id];
    NSString *dateString = [orderinfo.createDate substringWithRange:NSMakeRange(2, 8)];
    _OrderTime.text = dateString;
    _user_name.text = orderinfo.username;
}

@end
