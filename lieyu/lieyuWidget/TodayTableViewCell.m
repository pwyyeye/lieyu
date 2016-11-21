//
//  TodayTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/11/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TodayTableViewCell.h"

@implementation TodayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImage.layer.cornerRadius = 4;
    _avatarImage.layer.masksToBounds = YES;
    _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setJiubaModel:(NSDictionary *)jiubaModel{
    _jiubaModel = jiubaModel;
    [_avatarImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jiubaModel objectForKey:@"baricon"]]]]];
    [_titleLabel setText:[jiubaModel objectForKey:@"barname"]];
    [_subTitleLabel setText:[jiubaModel objectForKey:@"subtitle"]];
    [_detailLabel setText:[jiubaModel objectForKey:@"addressabb"]];
}

- (void)setStrategyModel:(NSDictionary *)strategyModel{
    
}

- (void)setLiveshowModel:(NSDictionary *)liveshowModel{
    _liveshowModel = liveshowModel;
    [_avatarImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"avatar_img"]]]]];
    [_titleLabel setText:[[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"usernick"] ? [[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"usernick"] : [[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"username"]];
    [_subTitleLabel setText:[liveshowModel objectForKey:@"roomName"]];
    [_detailLabel setText:[NSString stringWithFormat:@"%@人看过",[liveshowModel objectForKey:@"joinNum"]]];
}

@end
