//
//  ZSTiXianRecordTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSTiXianRecordTableViewCell.h"
#import "ZSTiXianRecord.h"
@implementation ZSTiXianRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTiXianR:(ZSTiXianRecord *)tiXianR{
    _tiXianR = tiXianR;
    _label_time.text = tiXianR.create_date;
    _label_type.text = tiXianR.wtype;
    _label_money.text = [NSString stringWithFormat:@"%.2f",tiXianR.amount.floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
