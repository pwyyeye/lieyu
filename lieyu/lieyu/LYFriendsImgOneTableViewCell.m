//
//  LYFriendsImgOneTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsImgOneTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsImgOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    if(recentM.lyMomentsAttachList.count){
        FriendsPicAndVideoModel *pvModel = recentM.lyMomentsAttachList[0];
        NSLog(@"----->%@",recentM.lyMomentsAttachList);
              NSLog(@"----->%@",pvModel.imageLink);
        [_imageView_one sd_setImageWithURL:[NSURL URLWithString:pvModel.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        _imageView_one.userInteractionEnabled = YES;
    }
    
    
//    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
//    [_imageView_one addGestureRecognizer:tapGes];
}



- (void)tapGes{
    if ([_delegate respondsToSelector:@selector(friendsImgOneCell:)]) {
      //  [_delegate friendsImgOneCell:self ];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
