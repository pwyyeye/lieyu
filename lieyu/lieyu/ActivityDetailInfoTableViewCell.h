//
//  ActivityDetailInfoTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarActivityList.h"

@interface ActivityDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
@property (weak, nonatomic) IBOutlet UILabel *activityPhone;

@property (weak, nonatomic) IBOutlet UIButton *activityAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *activityPhoneButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant;

@property (nonatomic, strong) BarActivityList *barActivity;

@end
