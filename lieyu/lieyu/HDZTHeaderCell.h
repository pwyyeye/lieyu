//
//  HDZTHeaderCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarTopicInfo.h"
@interface HDZTHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *action_image;
@property (weak, nonatomic) IBOutlet UILabel *action_discript;
@property (weak, nonatomic) IBOutlet UIButton *action_button;

@property (nonatomic, strong) BarTopicInfo *topicInfo;

@end
