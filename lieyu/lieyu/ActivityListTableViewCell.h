//
//  ActivityListTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarActivityList.h"

@interface ActivityListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPlaceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityPriceLabelHeight;

@property (nonatomic, strong) BarActivityList *barActivity;

@end
