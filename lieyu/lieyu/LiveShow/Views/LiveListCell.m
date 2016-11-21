//
//  LiveListCell.m
//  lieyu
//
//  Created by 狼族 on 2016/11/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveListCell.h"
#import "roomHostUser.h"
@class RoomHostUserModel;
@implementation LiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _deleteButton.hidden = YES;
    
}


- (void)drawRect:(CGRect)rect{
    [self setCornerRadiusView:self.firstTagLabel With:self.firstTagLabel.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.secondTagLabel With:self.secondTagLabel.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.iconImageView With:self.iconImageView.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.liveTypeLabel With:self.liveTypeLabel.frame.size.height/2 and:YES];
    
    [_liveImageView setContentMode:UIViewContentModeScaleAspectFill];
    _liveImageView.layer.masksToBounds = YES;
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setListModel:(LYLiveShowListModel *)listModel
{
    _listModel = listModel;
    [_liveImageView sd_setImageWithURL:[NSURL URLWithString:listModel.roomImg] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    NSString *imgStr = [NSString stringWithFormat:@"%@",((roomHostUser *)listModel.roomHostUser).avatar_img];
    if (imgStr.length < 50) {
        imgStr = [MyUtil getQiniuUrl:((roomHostUser *)listModel.roomHostUser).avatar_img width:0 andHeight:0];
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_nameLabel setText:((roomHostUser *)listModel.roomHostUser).usernick];
    [_lookNumLabel setText:[NSString stringWithFormat:@"%d",listModel.joinNum]];
    _titleLabel.text = [NSString stringWithFormat:@"%@", listModel.roomName];
    _likeNumLabel.text = [NSString stringWithFormat:@"%d",listModel.likeNum];
    NSString *astro = [MyUtil getAstroWithBirthday:((roomHostUser *)listModel.roomHostUser).birthday];
    NSString *tagStr = ((roomHostUser *)listModel.roomHostUser).userTag[0];
    if ([astro isEqualToString:@""] && [tagStr isEqualToString:@""]) {
        _firstTagLabel.hidden = YES;
        _secondTagLabel.hidden = YES;
    } else if (![astro isEqualToString:@""] && [tagStr isEqualToString:@""]) {
        _firstTagLabel.hidden = NO;
        _secondTagLabel.hidden = YES;
        _firstTagLabel.text = astro;
    } else if ([astro isEqualToString:@""] && ![tagStr isEqualToString:@""]) {
        _firstTagLabel.hidden = NO;
        _secondTagLabel.hidden = YES;
        _firstTagLabel.text = tagStr;
    } else {
        _firstTagLabel.hidden = NO;
        _secondTagLabel.hidden = NO;
        _firstTagLabel.text = astro;
        _secondTagLabel.text = tagStr;
    }
    
    _liveTypeLabel.textAlignment = kCTCenterTextAlignment;
    
    if ([listModel.roomType isEqualToString:@"live"]) {//直播
        _liveTypeLabel.text = @"直播中";
        _liveTypeLabel.backgroundColor = RGB(119, 119, 119);
        _liveTypeLabel.textColor = [UIColor whiteColor];
    } else {
        _liveTypeLabel.text = @"回放";
        _liveTypeLabel.backgroundColor = [UIColor clearColor];
        _liveTypeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _liveTypeLabel.layer.borderWidth = 1.f;
    }
}

@end
