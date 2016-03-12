//
//  LYFriendsLikeTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsLikeTableViewCell.h"
#import "FriendsRecentModel.h"
#import "UIButton+WebCache.h"
#import "FriendsLikeModel.h"

@implementation LYFriendsLikeTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = (SCREEN_WIDTH - 114)/8.f / 2.f;
        btn.layer.masksToBounds = YES;
    }
    _btn_more.layer.cornerRadius = (SCREEN_WIDTH - 114)/8.f / 2.f;
    _btn_more.layer.masksToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    
//    NSArray *array1 = @[recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],recentM.likeList[0],];
//    recentM.likeList = array1.mutableCopy;
    
    for (UIButton *btn in _btnArray) {
        btn.hidden = YES;
    }
    NSArray *array = recentM.likeList;
    NSInteger count = 0;
    if(array.count > 8){
        count = 8;
        _btn_more.hidden = NO;
    }else{
        count = array.count;
    }
    for (int i = 0; i<count; i++ ) {
        if(_btnArray.count <= i || array.count <= i) return;
        UIButton *btn = _btnArray[i];
        btn.hidden = NO;
        FriendsLikeModel *likeModel = array[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeModel.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    }
    
 /*   if (!recentM.likeList.count) {
        return;
    }
    for (UIButton *button in _btnArray) {
        button.hidden = NO;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:((FriendsLikeModel *)recentM.likeList[0]).icon] forState:UIControlStateNormal];
    } */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
