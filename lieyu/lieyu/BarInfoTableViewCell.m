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
    int i;
    NSArray *iconsArray = @[self.icon1,self.icon2,self.icon3,self.icon4,self.icon5];
    [_barImage sd_setImageWithURL:[NSURL URLWithString:self.barInfoDict[@"imageURL"]]];
    _barNameLbl.text = self.barInfoDict[@"barName"];
    for (i = 0; i < [self.barInfoDict[@"stars"] intValue]; i ++) {
        ((UIImageView *)iconsArray[i]).image = [UIImage imageNamed:@"icon_lightStar"];
    }
    for(int j = i ; j < [self.barInfoDict[@"stars"] intValue]; j ++ ){
        ((UIImageView *)iconsArray[j]).image = [UIImage imageNamed:@"icon_darkStar"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
