//
//  LYGroupPeopleTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface LYGroupPeopleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet UILabel *workTypeLabel;

@property (strong, nonatomic) IBOutlet UIButton *chatButton;


@property (strong, nonatomic) UserModel *usermodel;

@property (assign, nonatomic) BOOL isAdmin;



@end
