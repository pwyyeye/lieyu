//
//  LPBuyPriceCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyPriceCell.h"

@implementation LPBuyPriceCell

- (void)awakeFromNib {
    // Initialization code
    self.payBtn.enabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureWithPay:(NSString *)pay andProfit:(CGFloat)profit{
    if([pay isEqualToString:@"-1.00"]){
        self.LPMoney.text = @"点击填写";
    }else{
        self.payBtn.enabled = NO;
        self.LPMoney.text = [NSString stringWithFormat:@"$%@",pay];
    }
    [self.LPProfit setTitle:[NSString stringWithFormat:@"返利¥%.2f",profit] forState:UIControlStateNormal];
}

@end