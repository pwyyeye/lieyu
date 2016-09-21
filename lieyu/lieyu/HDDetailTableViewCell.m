//
//  HDDetailTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDDetailTableViewCell.h"
#import "JiuBaModel.h"

@implementation HDDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backView.layer.cornerRadius = 2;
//    self.backView.layer.masksToBounds = YES;
    self.backView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 1;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderInfo:(YUOrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    NSArray *reachTimeArray1 = [_orderInfo.reachtime componentsSeparatedByString:@" "];
    if (reachTimeArray1.count == 2) {
        NSArray *reachTimeArray2 = [reachTimeArray1[0] componentsSeparatedByString:@"-"];
        NSArray *reachTimeArray3 = [reachTimeArray1[1] componentsSeparatedByString:@":"];
        if (reachTimeArray2.count == 3 && reachTimeArray3.count == 3) {
            NSString *timeStr = [NSString stringWithFormat:@"%@-%@ (%@) %@:%@",reachTimeArray2[1],reachTimeArray2[2],[MyUtil weekdayStringFromDate:orderInfo.reachtime],reachTimeArray3[0],reachTimeArray3[1]];
            _startTime_label.text = timeStr;
        }
    }
    _residue_label.text = [MyUtil residueTimeFromDate:orderInfo.reachtime];
    _joinedNumber_label.text = [NSString stringWithFormat:@"参加人数(%d/%d)",orderInfo.pinkerCount,[orderInfo.allnum intValue]];
    if([orderInfo.pinkerType isEqualToString:@"0"]){
        _label_priceWay.text = @"发起人请客";
    }else if ([orderInfo.pinkerType isEqualToString:@"1"]){
        _label_priceWay.text = @"AA付款";
    }else if ([orderInfo.pinkerType isEqualToString:@"2"]){
        _label_priceWay.text = @"AA付款";
    }
    _address_label.text = orderInfo.barinfo.address;
    _barName_label.text = orderInfo.barinfo.barname;
}

- (void)setYUModel:(YUOrderShareModel *)YUModel{
    _YUModel = YUModel;
    if ([YUModel.allowSex isEqualToString:@"0"]) {
        _joinedpro_label.text = @"只邀请女生";
    }else if ([_YUModel.allowSex isEqualToString:@"1"]){
        _joinedpro_label.text = @"只邀请男生";
    }else{
        _joinedpro_label.text = @"邀请所有人";
    }
}

@end
