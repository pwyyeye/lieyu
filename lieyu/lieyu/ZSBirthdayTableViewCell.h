//
//  ZSBirthdayTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "AddressBookModel.h"

@interface ZSBirthdayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UILabel *lastDayLabel;


@property (nonatomic, strong) AddressBookModel *userModel;

@property (nonatomic, strong) AddressBookModel *tempUserModel;//生日管家中通讯录导入

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableString *selectStatus;


@end
