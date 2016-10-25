//
//  ActivityDetailInfoTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityDetailInfoTableViewCell.h"
#import "BeerBarOrYzhDetailModel.h"

@implementation ActivityDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setBarActivity:(BarActivityList *)barActivity{
    _barActivity = barActivity;
    [_activityName setText:barActivity.name];
    double price = [barActivity.price doubleValue];
    if (price <= 0) {
        _activityPrice.hidden = YES;
        _constant.constant = -20;
    }else{
        _activityPrice.hidden = NO;
        _constant.constant = 14;
        [_activityPrice setText:[NSString stringWithFormat:@"门票 ¥%@",barActivity.price]];
    }
    [_activityPrice setText:[NSString stringWithFormat:@"门票 ¥%@",barActivity.price]];
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
    _activityTime.text = [NSString stringWithFormat:@"%@ ~ %@  %@开始",startTime,endTime,time];
    
    [_activityAddress setText:barActivity.address];
//    if (barActivity.barInfo) {
//        if (![MyUtil isEmptyString:((BeerBarOrYzhDetailModel *)barActivity.barInfo).address]) {
//            [_activityAddress setText:((BeerBarOrYzhDetailModel *)barActivity.barInfo).address];
//        }else{
//            [_activityAddress setText:barActivity.address];
//        }
//    }else{
//        
//        [_activityAddress setText:barActivity.address];
//    }
    if (barActivity.barInfo) {
        if (![MyUtil isEmptyString:((BeerBarOrYzhDetailModel *)barActivity.barInfo).telephone]) {
            [_activityPhone setText:((BeerBarOrYzhDetailModel *)barActivity.barInfo).telephone];
        }else{
            _activityPhone.hidden = YES;
        }
    }else{
        _activityPhone.hidden = YES;
    }
}

@end
