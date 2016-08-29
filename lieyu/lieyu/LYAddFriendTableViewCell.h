//
//  LYAddFriendTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface LYAddFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (nonatomic, strong) AddressBookModel *addressBook;

@end
