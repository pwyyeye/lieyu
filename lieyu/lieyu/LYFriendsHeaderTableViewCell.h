//
//  LYFriendsHeaderTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_headerImg;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property (weak, nonatomic) IBOutlet UIButton *btn_comment;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
