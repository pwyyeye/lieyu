//
//  HDZTListCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDZTListCell.h"
#import "UIImageView+WebCache.h"
#import "BarTopicInfo.h"
#import "BeerBarOrYzhDetailModel.h"
#import "LYUserLocation.h"

@implementation HDZTListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _back_view.layer.cornerRadius = 2;
    _back_view.layer.masksToBounds = YES;
    _action_page.contentMode = UIViewContentModeScaleAspectFill;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_action_page.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = _action_page.bounds;
    layer.path = path.CGPath;
    _action_page.layer.mask = layer;
    _hot_triangle.hidden = YES;
    _action_likeBtn.hidden = YES;
    _action_likeNum.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBarActivity:(BarActivityList *)barActivity{
    [_action_page sd_setImageWithURL:[NSURL URLWithString:barActivity.imageUrl] placeholderImage:[UIImage imageNamed:@"emptyImage_rect"]];
    _action_title.text = barActivity.name;
    
    NSString *lowstPrice = [NSString stringWithFormat:@"¥%@起",barActivity.barInfo.lowest_consumption];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lowstPrice];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(attributedStr.length - 1, 1)];
    _action_price.attributedText = attributedStr;
    _action_barName.text = [NSString stringWithFormat:@"@%@",barActivity.barInfo.barname];
    _action_address.text = barActivity.barInfo.addressabb;
    float distance = [[LYUserLocation instance]configureDistance:barActivity.barInfo.latitude And:barActivity.barInfo.longitude];
    _action_distance.text = [NSString stringWithFormat:@"%.0fkm",distance];
    NSString *startTime = [barActivity.beginDate substringWithRange:NSMakeRange(0, 10)];
    NSString *endTime = [barActivity.endDate substringWithRange:NSMakeRange(0, 10)];
    _action_time.text = [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
}

@end
