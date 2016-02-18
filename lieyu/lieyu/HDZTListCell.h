//
//  HDZTListCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarActivityList.h"
@interface HDZTListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *back_view;
@property (weak, nonatomic) IBOutlet UIImageView *hot_triangle;
@property (weak, nonatomic) IBOutlet UIImageView *action_page;
@property (weak, nonatomic) IBOutlet UILabel *action_title;
@property (weak, nonatomic) IBOutlet UILabel *action_price;
@property (weak, nonatomic) IBOutlet UILabel *action_barName;
@property (weak, nonatomic) IBOutlet UILabel *action_address;
@property (weak, nonatomic) IBOutlet UILabel *action_distance;
@property (weak, nonatomic) IBOutlet UILabel *action_time;
@property (weak, nonatomic) IBOutlet UILabel *action_likeNum;

@property (weak, nonatomic) IBOutlet UIButton *action_likeBtn;
@property (nonatomic, strong) BarActivityList *barActivity;
@end
