//
//  LYBarTitleTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarTitleTableViewCell.h"
#import "BeerBarOrYzhDetailModel.h"
@implementation LYBarTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.label_name.text = @"酒吧名";
    self.imageView_header.layer.cornerRadius = 2;
    self.imageView_header.layer.masksToBounds = YES;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_btnBuy.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(_btnBuy.frame.size.height/2.f, _btnBuy.frame.size.height/2.f)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _btnBuy.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _btnBuy.layer.mask = maskLayer;
    
    _imageView_header.layer.cornerRadius = CGRectGetWidth(_imageView_header.frame)/2.f;
    _imageView_header.layer.masksToBounds = YES;
    
    _imageView_header.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    _imageView_header.layer.borderWidth = 0.5;
    
    CAShapeLayer *btn_commentLayer = [CAShapeLayer layer];
    UIBezierPath *bezierP = [UIBezierPath bezierPathWithRoundedRect:_btn_comment.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(_btn_comment.frame.size.height/2.f, _btn_comment.frame.size.height/2.f)];
    btn_commentLayer.path = bezierP.CGPath;
    _btn_comment.layer.mask = btn_commentLayer;
}

- (void)setBeerM:(BeerBarOrYzhDetailModel *)beerM{
    _beerM = beerM;
    _label_name.text = beerM.barname;
    [_imageView_header sd_setImageWithURL:[NSURL URLWithString:beerM.baricon] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _label_price.text = [NSString stringWithFormat:@"%@元／人起-返利%0.f%@",beerM.lowest_consumption,beerM.rebate * 100,@"%"];
    _label_time.text = [NSString stringWithFormat:@"营业时间:\t%@-%@",beerM.startTime,beerM.endTime];
    [_btn_comment setTitle:[NSString stringWithFormat:@"%@条评论",beerM.topicTypeMommentNum] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
