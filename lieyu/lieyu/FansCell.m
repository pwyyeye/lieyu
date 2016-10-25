//
//  FansCell.m
//  lieyu
//
//  Created by 狼族 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFansModel:(FansModel *)fansModel
{
    if (!_fansModel) {
        _fansModel = fansModel;
    }
    if ([[fansModel.avatar_img substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:fansModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }else{
        NSString *imgurl = [MyUtil getQiniuUrl:fansModel.avatar_img width:0 andHeight:0];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
    self.nameLabel.text = fansModel.usernick;
    self.firstLabel.text = [MyUtil getAstroWithBirthday:fansModel.birthday];
    self.secondLabel.text = @"互联网";
    if ([fansModel.friendStatus isEqualToString:@"3"] || [fansModel.friendStatus isEqualToString:@"1"]) {//关注
        [self.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
        self.focusButton.userInteractionEnabled = NO;
    } else {//粉丝
        [self.focusButton setTitle:@"关注" forState:(UIControlStateNormal)];
    }
}



-(void)layoutSubviews
{
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.focusButton.layer.cornerRadius = 3.f;
    self.focusButton.layer.masksToBounds = YES;
    
}
@end
