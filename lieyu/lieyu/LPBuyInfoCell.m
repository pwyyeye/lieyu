//
//  LPBuyInfoCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyInfoCell.h"

@implementation LPBuyInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureWithName:(NSString *)name Address:(NSString *)address Time:(NSString *)time Number:(NSString *)number{
    self.LPBarName.text = name;
    self.LPAddress.text = address;
    self.LPTime.text = time;
    self.LPNumber.text = [NSString stringWithFormat:@"拼客%@人",number];
}

@end
