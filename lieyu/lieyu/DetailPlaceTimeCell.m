//
//  DetailPlaceTimeCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailPlaceTimeCell.h"
#import "JiuBaModel.h"
@implementation DetailPlaceTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderInfoModel:(OrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    [_placeLbl setText:((JiuBaModel *)orderInfoModel.barinfo).address];
    [_TimeLbl setText:[orderInfoModel.reachtime substringToIndex:orderInfoModel.reachtime.length - 3]];
}

@end
