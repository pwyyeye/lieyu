//
//  LYCityChooseTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/6/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCityChooseTableViewCell.h"
#import "CityChooseButton.h"
#import "CityModel.h"

#define width ( SCREEN_WIDTH - 75 ) / 3 
#define height 35

@implementation LYCityChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCityArray:(NSMutableArray *)cityArray{
    _cityArray = cityArray;
    for (int i = 0 ; i < self.contentView.subviews.count;) {
        [[self.contentView.subviews objectAtIndex:i] removeFromSuperview];
    }
    for (int i = 0 ; i < cityArray.count ; i ++) {
        CityChooseButton *button = [[CityChooseButton alloc]initWithFrame:CGRectMake((i % 3) * (width + 20) + 15, (i / 3) * (height + 15) + 15, width, height)];
        [button setTitle:((CityModel *)[cityArray objectAtIndex:i]).cityName forState:UIControlStateNormal];
        [self.contentView addSubview:button];
    }
}

@end
