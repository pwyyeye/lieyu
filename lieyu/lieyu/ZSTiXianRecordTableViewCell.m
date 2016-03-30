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
    NSArray *strArray = [tiXianR.create_date componentsSeparatedByString:@" "];
    if (strArray.count == 2) {
        NSArray *strArray1 = [strArray.firstObject componentsSeparatedByString:@"-"];
        NSArray *strArray2 = [strArray[1] componentsSeparatedByString:@":"];
        if (strArray1.count > 2 && strArray2.count > 2) {
            _label_time.text = [NSString stringWithFormat:@"%@月%@日 %@:%@",strArray1[1],strArray1[2],strArray2[0],strArray2[1]];
        }
    }
    
    switch (tiXianR.checkMark.integerValue) {
        case 0:
            switch (tiXianR.wtype.integerValue) {
                case 1:
                    
                    _label_type.text =  @"提现成功，本次使用支付宝提现";
                    break;
                case 2:
                    _label_type.text =  @"提现成功，本次使用银联提现";
                    break;
                case 3:
                    _label_type.text =  @"提现成功，本次使用微信提现";
                    break;
            }
            break;
            
        case 1:
            switch (tiXianR.wtype.integerValue) {
                case 1:
                    
                    _label_type.text =  @"提现中，本次使用支付宝提现";
                    break;
                case 2:
                    _label_type.text =  @"提现中，本次使用银联提现";
                    break;
                case 3:
                    _label_type.text =  @"提现中，本次使用微信提现";
                    break;
            }
            break;
    }
    
    
    _label_money.text = [NSString stringWithFormat:@"%.2f",tiXianR.amount.floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end