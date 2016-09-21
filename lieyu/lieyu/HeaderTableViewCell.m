//
//  HeaderTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backView.layer.cornerRadius = 2;
//    self.backView.layer.masksToBounds = YES;
    self.backView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 1;
    self.view_image.hidden = YES;
}

- (void)drawRect:(CGRect)rect{
    
    _avatar_image.layer.cornerRadius = _avatar_button.frame.size.width / 2;
    _avatar_image.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderInfo:(YUOrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    [self.avatar_image sd_setImageWithURL:[NSURL URLWithString:orderInfo.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.name_label.text = orderInfo.username;
    self.viewNumber_label.text = @"";
}

- (void)setYUShare:(YUOrderShareModel *)YUShare{
    _YUShare = YUShare;
    self.title_label.text = YUShare.shareContent;
}













@end
