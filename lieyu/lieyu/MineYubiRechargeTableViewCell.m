//
//  MineYubiRechargeTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineYubiRechargeTableViewCell.h"

#define yubiArray @{@[@"yubi":@"800",@"money":@"8"],@[@"yubi":@"3800",@"money":@"38"],@[@"yubi":@"8800",@"money":@"88"]}

@implementation MineYubiRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _rechargeButton.layer.borderColor = [COMMON_PURPLE CGColor];
    _rechargeButton.layer.borderWidth = 1;
    _rechargeButton.layer.cornerRadius = 6;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIndex:(NSInteger)index{
    _rechargeButton.tag = index;
    NSString *yubi;
    NSString *money;
    if (index == 0) {
        yubi = @"800";
        money = @"¥ 8";
    }else if (index == 1){
        yubi = @"3800";
        money = @"¥ 38";
    }else if (index == 2){
        yubi = @"8800";
        money = @"¥ 88";
    }
    [_yubiLabel setText:yubi];
    [_rechargeButton setTitle:money forState:UIControlStateNormal];
}

@end
