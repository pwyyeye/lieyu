//
//  LYGroupPeopleTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGroupPeopleTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation LYGroupPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUsermodel:(UserModel *)usermodel
{
    
    _usermodel = usermodel;
    [_iconImag sd_setImageWithURL:[NSURL URLWithString:usermodel.avatar_img] forState:UIControlStateNormal];
    _iconImag.imageView.layer.cornerRadius = 18;
    _iconImag.imageView.layer.masksToBounds = YES;
    _nameLabel.text = usermodel.usernick;
    NSArray *strArr = [usermodel.birthday componentsSeparatedByString:@" "];
    _starLabel.text = [MyUtil getAstroWithBirthday:strArr.firstObject];
    _workTypeLabel.text = usermodel.tag;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.cornerRadius = 3;
    if (usermodel.isGrpupManage) {
        _typeLabel.text = @"管理员";
        
        _typeLabel.backgroundColor = RGB(178, 38, 217);
    } else {
        _typeLabel.text = @"玩友";
        _typeLabel.backgroundColor = RGB(130, 130, 130);
    }
}



@end
