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
    _detailLabel.hidden = NO;
}

- (void)setStrategyModel:(NSDictionary *)strategyModel{
    _strategyModel = strategyModel;
    [_avatarImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self getQiniuUrl:[strategyModel objectForKey:@"strategyIcon"] width:0 andHeight:0]]]]];
    [_titleLabel setText:[strategyModel objectForKey:@"title"]];
    [_subTitleLabel setText:[strategyModel objectForKey:@"subtitle"]];
    [_detailLabel setText:[strategyModel objectForKey:@""]];
    _detailLabel.hidden = YES;
}

#pragma --mark 获取7牛访问链接

- (NSString *)getQiniuUrl:(NSString *)key width:(NSInteger)width andHeight:(NSInteger)height{
    if (key.length >= 4 && [[key substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"http"]) {
        return key;
    }else{
        NSString *encodeKey=[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if(width>0&&height>0){
            return [NSString stringWithFormat:@"http://source.lie98.com/%@?imageView2/0/w/%ld/h/%ld",encodeKey,width,height];
        }else{
            return [NSString stringWithFormat:@"http://source.lie98.com/%@",encodeKey];
        }
    }
}

- (void)setLiveshowModel:(NSDictionary *)liveshowModel{
    _liveshowModel = liveshowModel;
    [_avatarImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[liveshowModel objectForKey:@"roomImg"]]]]];
    [_titleLabel setText:[[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"usernick"] ? [[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"usernick"] : [[liveshowModel objectForKey:@"roomHostUser"] objectForKey:@"username"]];
    [_subTitleLabel setText:[liveshowModel objectForKey:@"roomName"]];
    [_detailLabel setText:[NSString stringWithFormat:@"%@人看过",[liveshowModel objectForKey:@"joinNum"]]];
    _detailLabel.hidden = NO;
}

@end
