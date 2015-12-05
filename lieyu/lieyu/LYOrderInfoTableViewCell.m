//
//  LYOrderInfoTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYOrderInfoTableViewCell.h"
#import "TaoCanModel.h"

@implementation LYOrderInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTaocanModel:(TaoCanModel *)taocanModel{
    _taocanModel = taocanModel;
    self.label_orderInfo.text = taocanModel.barinfo.barname;
    self.label_orderAddress.text = taocanModel.barinfo.address;
}

@end
