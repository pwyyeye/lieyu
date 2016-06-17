//
//  LYGuWenPersonCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenPersonCollectionViewCell.h"

@implementation LYGuWenPersonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    _btnFlower.hidden = YES;
}

- (void)setVipModel:(UserModel *)vipModel{
    _vipModel = vipModel;
    
    [_imgHeaderView sd_setImageWithURL:[NSURL URLWithString:_vipModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _labelNick.text = vipModel.usernick;
    _labelBarName.text = [NSString stringWithFormat:@"@ %@",vipModel.barname];
    _labelAddress.text = vipModel.addressabb;
    _labelDistance.text = [NSString stringWithFormat:@"%@km",vipModel.distance];
    
    [_btnFlower setTitle:vipModel.facescoreNum forState:UIControlStateNormal];
    
    [_btnPopular setTitle:vipModel.popularityNum forState:UIControlStateNormal];
    
    if([vipModel.gender isEqualToString:@"0"]){
        [_sexImage setImage:[UIImage imageNamed:@"woman"]];
    }else{
        [_sexImage setImage:[UIImage imageNamed:@"manIcon"]];
    }
}

@end
