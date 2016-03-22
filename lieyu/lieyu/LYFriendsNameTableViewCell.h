//
//  LYFriendsNameTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_headerImg;
@property (weak, nonatomic) IBOutlet UIButton *btn_name;
@property (weak, nonatomic) IBOutlet UILabel *label_constellation;
@property (weak, nonatomic) IBOutlet UILabel *label_work;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_constellation_constraint_width;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_work_contraint_width;
@property (weak, nonatomic) IBOutlet UIButton *btn_topic;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
