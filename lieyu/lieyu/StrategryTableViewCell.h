//
//  StrategryTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrategryModel.h"

@interface StrategryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *strategyImage;
@property (weak, nonatomic) IBOutlet UILabel *strategyTitle;
@property (weak, nonatomic) IBOutlet UILabel *strategySubtitle;

@property (nonatomic, strong) StrategryModel *strategyModel;

@end
