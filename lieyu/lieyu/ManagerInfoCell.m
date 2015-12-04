//
//  ManagerInfoCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ManagerInfoCell.h"
#import "UIImageView+WebCache.h"

@implementation ManagerInfoCell

- (void)awakeFromNib {
    self.starsArray = @[_star1,_star2,_star3,_star4,_star5];
    [self.iconImage addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.name addTarget:self action:@selector(nameClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureWithImage:(NSString *)imageUrl name:(NSString *)name stars:(NSString *)stars{
    [self.iconImage.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.name setTitle:name forState:UIControlStateNormal];
    int i;
    for(i = 0 ; i < [stars intValue] ; i ++){
        ((UIImageView *)self.starsArray[i]).image = [UIImage imageNamed:@"starRed"];
    }
    for (int j = i ; j < [stars intValue]; j ++) {
        ((UIImageView *)self.starsArray[j]).image = [UIImage imageNamed:@"starGray"];
    }
}


@end
