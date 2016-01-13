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
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    _label_address.text = recentM.location;
    if(_label_address.text.length == 0) _imgView_location.hidden = YES;
    else _imgView_location.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
