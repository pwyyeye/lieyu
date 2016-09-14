//
//  HomepageBarDetailTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomepageBarDetailTableViewCell.h"
#import "LYUserLoginViewController.h"
#import "LYHomePageHttpTool.h"

@implementation HomepageBarDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_barImage setContentMode:UIViewContentModeScaleAspectFill];
    _barImage.layer.masksToBounds = YES;
    
    _bottomView.layer.shadowColor = [[UIColor blackColor]CGColor];
    _bottomView.layer.shadowOpacity = 0.3;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    
    _communicateButton.layer.cornerRadius = 15;
    _communicateButton.layer.borderColor = [RGBA(186, 40, 227, 1) CGColor];
    _communicateButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setBarModel:(JiuBaModel *)barModel{
    _barModel = barModel;
    [_barImage sd_setImageWithURL:[NSURL URLWithString:barModel.baricon] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_barNameLabel setText:barModel.barname];
    [_barDescLabel setText:barModel.subtitle];
    [_barAddressShortLabel setText:barModel.addressabb];
    if([MyUtil isEmptyString:barModel.addressabb]){
        _seperateView.hidden = YES;
    }else{
        _seperateView.hidden = NO;
    }
    if(![MyUtil isEmptyString:barModel.distance] && barModel.distance.floatValue != 0.f){
        CGFloat distanceStr = barModel.distance.floatValue * 1000;
        if (distanceStr > 1000) {
            [_barDistanceLabel setText:[NSString stringWithFormat:@"%.0fkm",distanceStr/1000]];
        }else{
            [_barDistanceLabel setText:[NSString stringWithFormat:@"%.0fm",distanceStr]];
        }
    }
    if (barModel.like_num) {
        int num = barModel.like_num;
        if(num < 1000){
            [_collectButton setTitle:[NSString stringWithFormat:@"%d",barModel.like_num] forState:UIControlStateNormal];
        }else{
            [_collectButton setTitle:[NSString stringWithFormat:@"%dk+",barModel.like_num / 1000] forState:UIControlStateNormal];
        }
    }else{
        [_collectButton setTitle:@"0" forState:UIControlStateNormal];
    }
    if (barModel.commentNum) {
        int num = barModel.commentNum;
        if (num < 1000) {
            [_commentButton setTitle:[NSString stringWithFormat:@"%d",barModel.commentNum] forState:UIControlStateNormal];
        }else{
            [_commentButton setTitle:[NSString stringWithFormat:@"%dk+",barModel.commentNum / 1000] forState:UIControlStateNormal];
        }
    }else{
        [_commentButton setTitle:@"0" forState:UIControlStateNormal];
    }
}

@end
