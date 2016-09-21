//
//  HDDetailHeaderCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDDetailHeaderCell.h"
#import "LYUserLocation.h"
@implementation HDDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//NSDictionary *dict = @{@"startTime":_barActivity.beginDate,
//                       @"endTime":_barActivity.endDate,
//                       @"address":_barActivity.barInfo.address,
//                       @"latitude":_barActivity.barInfo.latitude,
//                       @"longitude":_barActivity.barInfo.longitude,
//                       @"environment":_barActivity.environment,
//                       @"music":_barActivity.music};
- (void)setDict:(NSDictionary *)dict{
    NSString *startTime = [dict[@"startTime"] substringWithRange:NSMakeRange(0, 10)];
    NSString *endTime = [dict[@"endTime"] substringWithRange:NSMakeRange(0, 10)];
    NSString *time = [dict[@"endTime"] substringWithRange:NSMakeRange(11, 5)];
    _timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@  %@开始",startTime,endTime,time];
    _addressLabel.text = dict[@"address"];
    NSString *latitude = dict[@"latitude"];
    NSString *longitude = dict[@"longitude"];
    double distance = [[LYUserLocation instance]configureDistance:latitude And:longitude];
    _distanceLabel.text = [NSString stringWithFormat:@"%.0fkm",distance];
    _environmentLabel.text = dict[@"environment"];
    _musicLabel.text = dict[@"music"];
}

@end
