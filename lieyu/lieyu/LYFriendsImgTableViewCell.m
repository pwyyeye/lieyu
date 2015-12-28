//
//  LYFriendsImgTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsImgTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"
#import "UIButton+WebCache.h"
@implementation LYFriendsImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentModel:(FriendsRecentModel *)recentModel{
    _recentModel = recentModel;
    NSArray *array = recentModel.lyMomentsAttachList;
    _btnArray = [[NSMutableArray alloc]init];
    [_btnArray removeAllObjects];
    switch (array.count) {
        case 1:
        {
            FriendsPicAndVideoModel *pvModel = array[0];
            UIButton *btn_imgOne = [[UIButton alloc]initWithFrame:self.bounds];
            [btn_imgOne sd_setBackgroundImageWithURL:[NSURL URLWithString:pvModel.imageLink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            [self addSubview:btn_imgOne];
            [_btnArray addObject:btn_imgOne];
        }
            break;
        case 2:
        {
            CGFloat btnW = (SCREEN_WIDTH - 2) / 2.f;
            for (int i = 0; i < 2; i ++) {
                FriendsPicAndVideoModel *pvModel = array[i];
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%2 *(btnW + 2) , 0, btnW, btnW)];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:pvModel.imageLink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
                [self addSubview:btn];
                [_btnArray addObject:btn];
            }
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
