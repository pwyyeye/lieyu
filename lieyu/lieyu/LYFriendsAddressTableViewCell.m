//
//  LYFriendsAddressTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsAddressTableViewCell.h"
#import "FriendsRecentModel.h"

@implementation LYFriendsAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)layoutSubviews{
    [_dianpingButton addTarget:self action:@selector(isHiddenOrNot) forControlEvents:(UIControlEventTouchUpInside)];
    _moreView.hidden = YES;
    _moreView.layer.cornerRadius = 5.f;
    _moreView.layer.masksToBounds = YES;
}

-(void)isHiddenOrNot{
    if (_moreView.hidden) {
        _moreView.hidden = NO;
    } else {
        _moreView.hidden = YES;
    }
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    _label_address.text = recentM.location;
    if(_label_address.text.length == 0) _imgView_location.hidden = YES;
    else _imgView_location.hidden = NO;
    if (recentM.lyMomentRewardCount) {
        if ([recentM.lyMomentRewardCount isEqualToString:@"0"]) {
            _dashangImageView.hidden = YES;
            _dashangLabel.hidden = YES;
        } else {
            _dashangLabel.hidden = NO;
            _dashangImageView.hidden = NO;
            [_dashangLabel setText:[NSString stringWithFormat:@"%@娱币",recentM.lyMomentRewardCount]];
        }
    } else {
        _dashangImageView.hidden = YES;
        _dashangLabel.hidden = YES;
    }
    if([MyUtil isEmptyString:recentM.id]){
        self.btn_comment.enabled = NO;
        self.btn_like.enabled = NO;
        self.btn_dashang.enabled = NO;
    }else {
        self.btn_comment.enabled = YES;
        self.btn_like.enabled = YES;
        self.btn_dashang.enabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
