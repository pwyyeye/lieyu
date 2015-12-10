//
//  ManagerInfoCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ManagerInfoCell.h"
#import "UIImageView+WebCache.h"

@implementation ManagerInfoCell

- (void)awakeFromNib {
    self.starsArray = @[_star1,_star2,_star3,_star4,_star5];
//    [self.iconImage addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.name addTarget:self action:@selector(nameClick) forControlEvents:UIControlEventTouchUpInside];
    if(self.radioButon.selected == YES){
        [self.radioButon setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateNormal];
    }else{
        [self.radioButon setBackgroundImage:[UIImage imageNamed:@"CustomBtn_unSelected"] forState:UIControlStateSelected];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

//- (IBAction)selectManager:(UIButton *)sender {
//    [self.radioButon setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateNormal];
//}

- (void)cellConfigureWithImage:(NSString *)imageUrl name:(NSString *)name stars:(NSString *)stars{
    NSLog(@"imageUrl:%@",imageUrl);
    [self.iconImage.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [self.name setTitle:name forState:UIControlStateNormal];
    int i;
    for(i = 0 ; i < [stars intValue] ; i ++){
        ((UIImageView *)self.starsArray[i]).image = [UIImage imageNamed:@"starRed"];
    }
    for (int j = i ; j < [stars intValue]; j ++) {
        ((UIImageView *)self.starsArray[j]).image = [UIImage imageNamed:@"starGray"];
    }
}

- (void)cellConfigure:(int)index{
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.zsDetail.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [self.iconImage.imageView sd_setImageWithURL:[NSURL URLWithString:self.zsDetail.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [self.name setTitle:self.zsDetail.usernick forState:UIControlStateNormal];
    int num ;
    if(self.zsDetail.servicestar){
        num = [self.zsDetail.servicestar intValue];
    }else{
        num = 5;
    }
    int i;
    for(i = 0 ; i < num ; i ++){
        ((UIImageView *)self.starsArray[i]).image = [UIImage imageNamed:@"starRed"];
    }
    for (int j = i ; j < 5; j ++) {
        ((UIImageView *)self.starsArray[j]).image = [UIImage imageNamed:@"starGray"];
    }
}

@end
