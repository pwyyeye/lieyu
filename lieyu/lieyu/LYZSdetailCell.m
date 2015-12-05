//
//  LYZSdetailCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYZSdetailCell.h"
#import "ZSDetailModel.h"

@implementation LYZSdetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setZsModel:(ZSDetailModel *)zsModel{
    _zsModel = zsModel;
//    @property(nonatomic,assign)int id;
//    @property(nonatomic,assign)int barid;
//    @property (nonatomic, copy) NSString * barname;
//    @property (nonatomic, copy) NSString * age;
//    @property (nonatomic, copy) NSString * avatar_img;
//    @property (nonatomic, copy) NSString * introduction;
//    @property (nonatomic, copy) NSString * mobile;
//    @property (nonatomic, copy) NSString * servicestar;
//    @property(nonatomic,assign)int userid;
//    @property (nonatomic, copy) NSString * userName;
//    @property (nonatomic, copy) NSString * username;
//    @property (nonatomic, copy) NSString * usernick;
//    @property (nonatomic, copy) NSString * imUserId;
//    @property (nonatomic, copy) NSString * isFull;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:zsModel.avatar_img] placeholderImage:nil];
    self.nameLal.text =  zsModel.userName;
    self.biaoqianLal.text = zsModel.introduction;
    self.jiubaLal.text = zsModel.barname;
    
}

@end
