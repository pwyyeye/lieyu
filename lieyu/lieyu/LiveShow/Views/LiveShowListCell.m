//
//  LiveShowListCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveShowListCell.h"
#import "roomHostUser.h"
@class RoomHostUserModel;
@implementation LiveShowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    self.liveTypeView.backgroundColor = [UIColor clearColor];
    
    [self setCornerRadiusView:self.firstTaglabel With:self.firstTaglabel.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.secondTagLabel With:self.secondTagLabel.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.liveTypeView With:8.f and:YES];
    [self setCornerRadiusView:self.iconImageView With:self.iconImageView.frame.size.height / 2 and:YES];
    
    [_backImageView setContentMode:UIViewContentModeScaleAspectFill];
    _backImageView.layer.masksToBounds = YES;
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setListModel:(LYLiveShowListModel *)listModel{
    _listModel = listModel;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:listModel.roomImg] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:((roomHostUser *)listModel.roomHostUser).avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_nameLabel setText:((roomHostUser *)listModel.roomHostUser).usernick];
    [_lookNumLabel setText:[NSString stringWithFormat:@"%d",listModel.joinNum]];
    if ([listModel.roomType isEqualToString:@"live"]) {//直播
        _liveTypeLabel.text = @"直播";
    }else{
        _liveTypeLabel.text = @"回放";
    }
    if (((roomHostUser *)listModel.roomHostUser).usertype.integerValue == 1) {//隐藏顾问tag
        _guWenLabel.hidden = YES;
    }
    if (((roomHostUser *)listModel.roomHostUser).userTag.count >= 1) {
        _firstTaglabel.hidden = NO;
        _firstTaglabel.text = [NSString stringWithFormat:@"%@",((roomHostUser *)listModel.roomHostUser).userTag[0]];
        if (((roomHostUser *)listModel.roomHostUser).userTag.count >= 2) {
            _secondTagLabel.text = [NSString stringWithFormat:@"%@",((roomHostUser *)listModel.roomHostUser).userTag[1]];
            _firstTaglabel.center = CGPointMake(self.center.x - 30, _secondView.center.y);
            _secondTagLabel.hidden = NO;
        } else {
            _secondTagLabel.hidden = YES;
        }
    } else {
        _firstTaglabel.hidden = YES;
        _secondTagLabel.hidden = YES;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@", listModel.roomName];
    _likeNum.text = [NSString stringWithFormat:@"%d",listModel.likeNum];
}

@end