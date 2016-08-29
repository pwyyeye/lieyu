//
//  LiveShowListCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveShowListCell.h"
@class RoomHostUserModel;
@implementation LiveShowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    self.liveTypeView.layer.borderWidth = 1.f;
    self.liveTypeView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.liveTypeView.backgroundColor = [UIColor clearColor];
    
    [self setCornerRadiusView:self.firstView With:self.firstView.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.secondView With:self.secondView.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.liveTypeView With:8.f and:YES];
    [self setCornerRadiusView:self.iconImageView With:self.iconImageView.frame.size.height / 2 and:YES];
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
