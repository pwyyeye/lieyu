//
//  DetailTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(KuCunModel *)good{
    self.wineName.text = good.name;
    self.wineNumber.text = [NSString stringWithFormat:@"%@%@",good.num,good.unit];
    if([good.num intValue] != 1){
        self.winePrice.text = [NSString stringWithFormat:@"¥%g",[good.num intValue]*[good.price floatValue]];
    }else{
        self.winePrice.text = [NSString stringWithFormat:@"¥%@",good.price];
    }
}

@end
