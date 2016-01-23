//
//  LYZSdetailCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYZSdetailCell.h"
#import "UIImageView+WebCache.h"

@implementation LYZSdetailCell

- (void)awakeFromNib {
    _imagesArray = @[_iconStar1,_iconStar2,_iconStar3,_iconStar4,_iconStar5];
    self.backView.layer.cornerRadius = 2;
    self.backView.layer.masksToBounds = YES;
//    self.backView.layer.shadowColor = [[UIColor grayColor]CGColor];
//    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
//    self.backView.layer.shadowOpacity = 0.8;
//    self.backView.layer.shadowRadius = 2 ;
//    self.layer.shadowColor = [[UIColor grayColor]CGColor];
//    self.layer.shadowOffset = CGSizeMake(0, 1);
//    self.layer.shadowOpacity = 0.8;
//    self.layer.shadowRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigure:(ZSDetailModel *)ZSModel{
    NSLog(@"%@",ZSModel);
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:ZSModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.nameLal.text = ZSModel.usernick;
    self.biaoqianLal.text = ZSModel.introduction;
    self.scBtn.tag = self.tag;
    self.phoneBtn.tag = self.tag;
    self.messageBtn.tag = self.tag;
    int num ;
    if([ZSModel.servicestar isEqualToString:@""]){
        num = 5;
    }else{
        num = [ZSModel.servicestar intValue];
    }
    int i;
    for(i = 0 ; i < num ; i ++){
        [_imagesArray[i] setImage:[UIImage imageNamed:@"starRed"]];
    }
    for(int j = i ; j < 5 ; j ++){
        [_imagesArray[j] setImage:[UIImage imageNamed:@"starGray"]];
    }
}

@end
