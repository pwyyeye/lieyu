//
//  ActivityListTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityListTableViewCell.h"
#import "BeerBarOrYzhDetailModel.h"

@implementation ActivityListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_activityImageView setContentMode:UIViewContentModeScaleAspectFill];
    _activityImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBarActivity:(BarActivityList *)barActivity{
    _barActivity = barActivity;
    [_activityImageView sd_setImageWithURL:[NSURL URLWithString:_barActivity.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_activityNameLabel setText:_barActivity.name];
    [_activityPriceLabel setText:[NSString stringWithFormat:@"门票 ¥%@",barActivity.price]];
    NSString *startTime;
    NSString *endTime;
    NSString *time;
    if (barActivity.beginDate.length > 10) {
        startTime = [barActivity.beginDate substringWithRange:NSMakeRange(0, 10)];
    }
    if (barActivity.endDate.length > 10) {
        endTime = [barActivity.endDate substringWithRange:NSMakeRange(0, 10)];
    }
    if (barActivity.endDate.length > 16) {
        time = [barActivity.endDate substringWithRange:NSMakeRange(11, 5)];
    }
    _activityTimeLabel.text = [NSString stringWithFormat:@"%@ ~ %@  %@开始",startTime,endTime,time];
    [_activityPlaceLabel setText:((BeerBarOrYzhDetailModel *)barActivity.barInfo).address];
}


@end
