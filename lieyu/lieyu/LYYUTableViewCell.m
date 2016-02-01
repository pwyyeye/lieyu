//
//  LYYUTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUTableViewCell.h"
#import "UIButton+WebCache.h"
#import "YUOrderShareModel.h"
#import "YUOrderInfo.h"

@implementation LYYUTableViewCell

- (void)awakeFromNib {
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(60, 171, SCREEN_WIDTH - 60 - 16, 0.5)];
    lineView.backgroundColor = RGBA(204, 204, 204, 1);
    [self.view_cell addSubview:lineView];
    
    _label_constell.layer.cornerRadius = CGRectGetHeight(_label_constell.frame)/2.f;
    _label_constell.layer.masksToBounds = YES;
    _label_constell.layer.borderColor = RGBA(217, 217, 217, 1).CGColor;
    _label_constell.layer.borderWidth = 0.5;
    
    UIButton *_btn_more = [[UIButton alloc]init];
    _btn_more.frame = ((UIButton *)_btnArray[4]).frame;
    _btn_more.backgroundColor = RGBA(186, 20, 227, 0.5);
    [self.view_cell addSubview:_btn_more];
}

- (void)setOrderModel:(YUOrderShareModel *)orderModel{
    _orderModel = orderModel;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:orderModel.orderInfo.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lieyuIcon"]];
//    _label_age.text = [NSString stringWithFormat:@"%d",orderModel.orderInfo.]
    _label_name.text = orderModel.orderInfo.username;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
