//
//  LYFriendsLikeDetailTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsLikeDetailTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsCommentModel.h"
#import "UIButton+WebCache.h"
#import "FriendsLikeModel.h"

@implementation LYFriendsLikeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = (SCREEN_WIDTH - 98)/8.f / 2.f;
        btn.layer.masksToBounds = YES;
    }
    
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    _emojiImgVArray = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)drawRect:(CGRect)rect{
//    SCREEN_WIDTH - 49   7 10(top)
   
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSArray *array = recentM.likeList;
    if (_btnArray.count) {
    [_btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_btnArray removeAllObjects];
    }
    
    if (_emojiImgVArray.count) {
        [_emojiImgVArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_emojiImgVArray removeAllObjects];
    }
    
   
//    for (UIButton *btn in _btnArray) {
//        btn.hidden = YES;
//    }
//    for (int  i = 0; i < recentM.likeList.count; i ++) {
//        if(i >= 16) return;
//        UIButton *btn = _btnArray[i];
//                btn.hidden = NO;
////        btn.tag = i;
//        FriendsLikeModel *likeM = array[i];
////        NSLog(@"------>%ld------%@",array.count,commentModel.icon);
//        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
//    }
    CGFloat btnWidth = (SCREEN_WIDTH - 91) /7.f;
    CGFloat emojWidth = btnWidth * 0.4f;
    for (int i = 0;i < array.count ;i ++) {
        FriendsLikeModel *likeM = array[i];
        NSInteger rowNum = i / 7;
        NSInteger cloNum = i % 7;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(34 + (btnWidth + 7) * cloNum, rowNum* ( 7 + btnWidth) + 10, btnWidth, btnWidth)];
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
         [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
        [self addSubview:btn];
        btn.tag = i;
        [_btnArray addObject:btn];
        
        if (i == 0) {
            _like_icon_cons_top.constant = CGRectGetMinY(btn.frame) + 10;
        }
        NSString *emojiString ;
        switch ([likeM.likeType intValue]) {
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
        
        UIImageView *smallEmojImgV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) -emojWidth/1.5f, CGRectGetMaxY(btn.frame) - emojWidth/1.5f, emojWidth, emojWidth)];
        smallEmojImgV.layer.cornerRadius = emojWidth/2.f;
        smallEmojImgV.layer.masksToBounds = YES;
        [self addSubview:smallEmojImgV];
        [smallEmojImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0",emojiString]]];
        smallEmojImgV.backgroundColor = [UIColor clearColor];
        
        [_emojiImgVArray addObject:smallEmojImgV];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
