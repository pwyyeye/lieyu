//
//  ManagerChooseButton.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ManagerChooseButton.h"

@implementation ManagerChooseButton
- (void)awakeFromNib{
    self.selected = NO;
    self.recommond.hidden = YES;
    self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.width / 2;
    self.avatarImg.layer.masksToBounds = YES;
    self.maskLabel.layer.cornerRadius = self.avatarImg.frame.size.width / 2;
    self.maskLabel.layer.masksToBounds = YES;
    self.maskLabel.hidden = YES;
    _starsArray = @[_star1Img,_star2Img,_star3Img,_star4Img,_star5Img];
}

- (void)setSelected:(BOOL)selected{
    if(selected == YES){
        self.avatarImg.layer.borderColor = [RGB(186, 40, 227)CGColor];
        self.avatarImg.layer.borderWidth = 2;
    }else{
        self.avatarImg.layer.borderWidth = 0;
    }
}

- (void)configure:(ZSDetailModel *)Model{
    self.avatarImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Model.avatar_img]]];
    self.nameLbl.text = Model.usernick;
    int starsNum;
    if([Model.servicestar isEqualToString:@""]){
        starsNum = 5;
    }else{
        starsNum = [Model.servicestar intValue];
    }
    for (int i = 0 ; i < starsNum; i ++) {
        UIImageView *image = [_starsArray objectAtIndex:i];
        [image setImage:[UIImage imageNamed:@"purper_star"]];
    }
    for (int i = starsNum; i < 5; i ++) {
        UIImageView *image = [_starsArray objectAtIndex:i];
        [image setImage:[UIImage imageNamed:@"gray_star"]];
    }
}

@end
