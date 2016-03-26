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
        btn.layer.cornerRadius = (SCREEN_WIDTH - 114)/7.f / 2.f;
        btn.layer.masksToBounds = YES;
    }
    _btn_more.layer.cornerRadius = (SCREEN_WIDTH - 114)/7.f / 2.f;
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
    if(array.count > 7){
        count = 7;
        _btn_more.hidden = NO;
    }else{
        count = array.count;
    }
    for(UIImageView *imageView in _imageArray){
        imageView.hidden = YES;
    }
    for (int i = 0; i<count; i++ ) {
        if(_btnArray.count <= i || array.count <= i) return;
        UIButton *btn = _btnArray[i];
        btn.hidden = NO;
        FriendsLikeModel *likeModel = array[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeModel.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
        
        UIImageView *image = _imageArray[i];
        NSString *emojiString ;
        switch ([likeModel.likeType intValue]) {
            case 0:
                emojiString = @"dianzan";
                break;
            case 1:
                emojiString = @"angry";
                break;
            case 2:
                emojiString = @"sad";
                break;
            case 3:
                emojiString = @"wow";
                break;
            case 4 :
                emojiString = @"kawayi";
                break;
            case 5:
                emojiString = @"happy";
                break;
            case 6:
                emojiString = @"dianzan";
                break;
            default:
                emojiString = @"dianzan";
                break;
        }
        image.hidden = NO;
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0",emojiString]]];
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
