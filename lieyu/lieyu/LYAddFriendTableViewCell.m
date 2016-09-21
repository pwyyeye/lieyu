//
//  LYAddFriendTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAddFriendTableViewCell.h"
#import "LYAddressBook.h"

@implementation LYAddFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImage.layer.cornerRadius = 19;
    _avatarImage.layer.masksToBounds = YES;
    _statusButton.layer.borderColor = [RGB(228, 228, 228) CGColor];
    _statusButton.layer.borderWidth = 0.5;
    _statusButton.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAddressBook:(AddressBookModel *)addressBook{
    _addressBook = addressBook;
    if (addressBook.headUrl.length > 0) {
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:addressBook.headUrl] placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    }else{
        BOOL exist = false;
        //先找当前通讯录中有没有该人
        LYAddressBook *addressBookTool = [[LYAddressBook alloc]init];
        NSArray *array = [addressBookTool getAddressBook];
        for (AddressBookModel *model in array) {
            if ([model.mobile isEqualToString:addressBook.mobile]) {
                if (model.image) {
                    exist = YES;
                    [_avatarImage setImage:[UIImage imageWithData:addressBook.image]];
                    break;
                }
            }
        }
        if (!exist) {
            [_avatarImage setImage:[UIImage imageNamed:@"CommonIcon"]];
        }
    }
    [_nameLabel setText:addressBook.name];
    if(addressBook.appUserType == 0){
        //邀请
        [_statusButton setTitle:@"邀请" forState:UIControlStateNormal];
        [_statusButton setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
    }else if (addressBook.appUserType == 1){
        //添加
        [_statusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_statusButton setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    }else if (addressBook.appUserType == 2){
        //已添加
        [_statusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_statusButton setTitleColor:RGBA(0, 0, 0, 0.5) forState:UIControlStateNormal];
        _statusButton.enabled = NO;
    }else if (addressBook.appUserType == 3){
        //已邀请
        [_statusButton setTitle:@"已邀请" forState:UIControlStateNormal];
        [_statusButton setTitleColor:COMMON_PURPLE_HALF forState:UIControlStateNormal];
        _statusButton.enabled = NO;
    }
}

@end
