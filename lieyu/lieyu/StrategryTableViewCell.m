//
//  StrategryTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategryTableViewCell.h"

@implementation StrategryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_strategyImage setContentMode:UIViewContentModeScaleAspectFill];
    _strategyImage.layer.masksToBounds = YES;
    
    _shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _shadowView.layer.shadowOffset = CGSizeMake(0, 1);
    _shadowView.layer.shadowOpacity = 0.3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStrategyModel:(StrategryModel *)strategyModel{
    _strategyModel = strategyModel;
    [_strategyImage sd_setImageWithURL:[NSURL URLWithString:strategyModel.strategyIconAll] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_strategyTitle setText:strategyModel.title];
    [_strategySubtitle setText:strategyModel.subtitle];
}

@end
