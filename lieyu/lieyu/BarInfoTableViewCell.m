//
//  BarInfoTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BarInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation BarInfoTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigure:(NSDictionary *)dict{
    int i;
//    dict[@"stars"] = @"4";
//    [dict setValue:@"4" forKey:@"stars"];
    NSArray *iconsArray = @[self.icon1,self.icon2,self.icon3,self.icon4,self.icon5];
    [_barImage sd_setImageWithURL:[NSURL URLWithString:dict[@"imageURL"]]];
    _barNameLbl.text = dict[@"barName"];
    for (i = 0; i < [dict[@"stars"] intValue]; i ++) {
        ((UIImageView *)iconsArray[i]).image = [UIImage imageNamed:@"starRed"];
    }
    for(int j = i ; j <= [dict[@"stars"] intValue]; j ++ ){
        ((UIImageView *)iconsArray[j]).image = [UIImage imageNamed:@"starGray"];
    }
}

@end
