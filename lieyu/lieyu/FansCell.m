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
    NSString *imgurl = [MyUtil getQiniuUrl:fansModel.avatar_img width:0 andHeight:0];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    self.nameLabel.text = fansModel.usernick;
    self.firstLabel.text = @"狮子座";
    self.secondLabel.text = @"互联网";
    if ([fansModel.friendStatus isEqualToString:@"3"]) {//好友
        self.focusButton.titleLabel.text = @"取消关注";
    } else if([fansModel.friendStatus isEqualToString:@"2"]){//粉丝
        self.focusButton.titleLabel.text = @"关注";
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
