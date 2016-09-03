//
//  StrategyDetailInfoTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrategryModel.h"

@interface StrategyDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) StrategryModel *strategyModel;

@end
