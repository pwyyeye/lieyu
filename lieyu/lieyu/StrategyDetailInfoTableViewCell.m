//
//  StrategyDetailInfoTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategyDetailInfoTableViewCell.h"

@implementation StrategyDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setStrategyModel:(StrategryModel *)strategyModel{
    _strategyModel = strategyModel;
    [_titleLabel setText:strategyModel.title];
    [_subtitleLabel setText:strategyModel.subtitle];
}

@end
