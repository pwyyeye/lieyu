//
//  PTzsjlCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTzsjlCell.h"
#import "ZSDetailModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation PTzsjlCell

- (void)awakeFromNib {
    // Initialization code
    self.managerAvatar.layer.masksToBounds =YES;
    
    self.managerAvatar.layer.cornerRadius =self.managerAvatar.frame.size.width/2;
    
    _starsArray = @[_icon1,_icon2,_icon3,_icon4,_icon5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(ZSDetailModel*)model
{
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.avatar_img ;
    [_managerAvatar  setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    
    _managerName.text=model.usernick;
    
    [self.selectBtn setSelected:model.issel];
    
    int num;
    if(!model.servicestar){
        num = 5;
    }else{
        num = [model.servicestar intValue];
    }
    int i = 0 ;
    for (i = 0 ; i < num; i ++) {
        [_starsArray[i] setImage:[UIImage imageNamed:@"starRed"]];
    }
    for(int j = i ; j < 5; j ++){
        [_starsArray[j] setImage:[UIImage imageNamed:@"starGray"]];
    }
    
}

@end
