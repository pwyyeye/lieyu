//
//  ZSBirthdayTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSBirthdayTableViewCell.h"
#import "LYAddressBook.h"

@implementation ZSBirthdayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImage.layer.cornerRadius = 18;
    _avatarImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserModel:(AddressBookModel *)userModel{
    _userModel = userModel;
    //生日管理页面
    _userPhoneLabel.hidden = YES;
    _chooseButton.hidden = YES;
    if (userModel.headUrl.length > 0) {
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:userModel.headUrl] placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    }else{
        BOOL exist = false;
        LYAddressBook *addressBook = [[LYAddressBook alloc]init];
        NSArray *array = [addressBook getAddressBook];
        for (AddressBookModel *model in array) {
            if ([model.mobile isEqualToString:userModel.mobile]) {
                if (model.image) {
                    exist = YES;
                    [_avatarImage setImage:[UIImage imageWithData:userModel.image]];
                    break;
                }
            }
        }
        if (!exist) {
            [_avatarImage setImage:[UIImage imageNamed:@"CommonIcon"]];
        }
    }
    [_usernameLabel setText:userModel.name];
    if (userModel.birthday.length >= 10) {
        [_userBirthLabel setText:[userModel.birthday substringWithRange:NSMakeRange(5, 5)]];
    }else if(userModel.birthday.length){
        [_userBirthLabel setText:userModel.birthday];
    }else{
        [_userBirthLabel setText:@"生日未知"];
    }
    NSMutableAttributedString *attributedString;
    if (userModel.dayFactor == 0 || userModel.dayFactor == 1000) {
        attributedString = [[NSMutableAttributedString alloc]initWithString:userModel.dayFactorStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightLight] range:NSMakeRange(0, attributedString.length)];
    }else{
        attributedString = [[NSMutableAttributedString alloc]initWithString:userModel.dayFactorStr];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightLight],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 2)];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightLight],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(attributedString.length - 1, 1)];
    }
    [_lastDayLabel setAttributedText:attributedString];
}

- (void)setTempUserModel:(AddressBookModel *)tempUserModel{
    _tempUserModel = tempUserModel;
    _lastDayLabel.hidden = YES;
    [_usernameLabel setText:tempUserModel.name];
    if (tempUserModel.birthday.length > 0) {
        _userBirthLabel.hidden = NO;
        [_userBirthLabel setText:[tempUserModel.birthday substringWithRange:NSMakeRange(5, 5)]];
    }else{
        _userBirthLabel.hidden = YES;
    }
    if (tempUserModel.image) {
        [_avatarImage setImage:[UIImage imageWithData:tempUserModel.image]];
    }else{
        [_avatarImage setImage:[UIImage imageNamed:@"CommonIcon"]];
    }
    if (tempUserModel.mobile) {
        [_userPhoneLabel setText:tempUserModel.mobile];
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [_chooseButton setSelected:_isSelected];
    if (_isSelected == YES) {
        _selectStatus = [[NSMutableString alloc]initWithString:@"1"];
    }else{
        _selectStatus = [[NSMutableString alloc]initWithString:@"2"];
    }
}

@end
