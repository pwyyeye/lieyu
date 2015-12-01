//
//  TaocanTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TaocanTableViewCell.h"

@implementation TaocanTableViewCell

- (void)awakeFromNib {
    self.TaocanInfo.text = self.dict[@"taocanInfo"];
    self.priceLbl.text = [NSString stringWithFormat:@"¥%@/卡",self.dict[@"price"]];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",self.dict[@"marketPrice"]] attributes:attribtDic];
    self.marketPrice.attributedText = attribtStr;
    self.profit.text = [NSString stringWithFormat:@"返利%@",self.dict[@"profit"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
