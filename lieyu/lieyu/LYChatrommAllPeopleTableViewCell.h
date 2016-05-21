//
//  LYChatrommAllPeopleTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/5/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface LYChatrommAllPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV_header;//头像
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_constellation;//星座
@property (weak, nonatomic) IBOutlet UIImageView *img_sex;//性别
@property (nonatomic,strong) UserModel *userM;
@property (nonatomic,unsafe_unretained) BOOL isQunZhu;//群主
@end
