//
//  TodayTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/11/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) NSDictionary *jiubaModel;
@property (nonatomic, strong) NSDictionary *strategyModel;
@property (nonatomic, strong) NSDictionary *liveshowModel;

@end
