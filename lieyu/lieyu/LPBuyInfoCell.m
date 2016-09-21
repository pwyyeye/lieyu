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
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureWithName:(NSString *)name Address:(NSString *)address Time:(NSString *)time Number:(NSString *)number{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy年MM月dd日 EEE HH:mm"];
    NSString *dateString = [formatter stringFromDate:time];
    self.LPBarName.text = name;
    self.LPAddress.text = address;
    self.LPTime.text = dateString;
    self.LPNumber.text = [NSString stringWithFormat:@"拼客%@人",number];
}

@end
