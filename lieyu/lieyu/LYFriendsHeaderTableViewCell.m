//
//  LYFriendsHeaderTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsHeaderTableViewCell.h"
#import "UIButton+WebCache.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)drawRect:(CGRect)rect{
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:recentM.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empy120"]];
    _label_name.text = recentM.usernick;
    _label_content.text = recentM.message;
    
    NSArray *urlArray = nil;
    if(recentM.lyMomentsAttachList.count){
    urlArray = [((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    for (int i = 0; i < urlArray.count; i ++) {
        UIImageView *imgView = _imageViewArray[i];
        if([recentM.attachType isEqualToString:@"1"]){
            [imgView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] mediaType:QiNiuUploadTpyeDefault width:120 andHeight:120]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            UIImageView *imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imgView.frame)/2.f - 15, CGRectGetWidth(imgView.frame)/2.f - 15, 30, 30)];
            imgPlay.image = [UIImage imageNamed:@"dabofangqi_icon"];
            imgPlay.userInteractionEnabled = YES;
            [imgView addSubview:imgPlay];
        }else{
            NSInteger picWidth = 120;
            if(recentM.isMeSendMessage) picWidth = 0;
            [imgView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        }

    }
    }
    _label_time.text = [NSString stringWithFormat:@"%@\n%@",[MyUtil calculateDateFromNowWith:recentM.date],recentM.location];
    
    
    for (int i = 0; i< urlArray.count ; i ++) {
        UIImageView *imgView = _imageViewArray[i];
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesClick:)];
        [imgView addGestureRecognizer:tapGes];
    }
}

- (void)tapGesClick:(UITapGestureRecognizer *)ges{
    UIImageView *imgView = (UIImageView *)ges.view;
    if([_delegate respondsToSelector:@selector(friendsHeaderCellImageView:)]){
        [_delegate friendsHeaderCellImageView:imgView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
