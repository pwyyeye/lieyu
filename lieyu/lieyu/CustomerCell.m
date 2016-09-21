//
//  CustomerCell.m
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.descLabel.hidden = YES;
}

- (void)drawRect:(CGRect)rect{
    
    self.smallImageView.layer.masksToBounds =YES;
    self.smallImageView.layer.cornerRadius =self.smallImageView.frame.size.width/2;
    
    self.cusImageView.layer.masksToBounds =YES;
    self.cusImageView.layer.cornerRadius =self.cusImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoModel:(LYAdviserManagerBriefInfo *)infoModel{
    _infoModel = infoModel;
    if ([[_infoModel.usernick stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        _nameLal.text = _infoModel.usernick;
    }else{
        _nameLal.text = @"暂无昵称";
    }
    [_smallImageView setHidden:YES];
    NSString *imageUrl = [MyUtil getQiniuUrl:infoModel.avatar_img width:0 andHeight:0];
    [_cusImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
}

- (void)setMemberModel:(CustomerModel *)memberModel{
    _memberModel = memberModel;
    _smallImageView.hidden = YES;
    _countLal.hidden = YES;
    if ([[memberModel.usernick stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] > 0) {
        [_nameLal setText:memberModel.usernick];
    }else{
        [_nameLal setText:@"暂无昵称"];
    }
    [_cusImageView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:memberModel.avatar_img width:0 andHeight:0]]];
}

@end
