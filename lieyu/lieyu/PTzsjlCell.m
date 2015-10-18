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
    self.userImageView.layer.masksToBounds =YES;
    
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(ZSDetailModel*)model
{
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.avatar_img ;
    [_userImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _nameLal.text=model.userName;
    _ageLal.text=[NSString stringWithFormat:@"年龄：%@",model.age];
    
    [self.selBtn setSelected:model.issel];
    
    
}

@end
