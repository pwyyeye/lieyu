//
//  LYNewMessageTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNewMessageTableViewCell.h"
#import "FriendsNewsModel.h"

@implementation LYNewMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setFriendsNesM:(FriendsNewsModel *)friendsNesM{
    _friendsNesM = friendsNesM;
    [_btn_name setTitle:friendsNesM.usernick forState:UIControlStateNormal];
    _label_message.text = friendsNesM.comment;
    _label_myMessage.text = friendsNesM.message;
    _label_time.text = friendsNesM.date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
