//
//  LYFriendsAllCommentTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsAllCommentTableViewCell.h"
#import "FriendsRecentModel.h"

@implementation LYFriendsAllCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    _label_commentCount.text = [NSString stringWithFormat:@"查看全部%ld条评论...",recentM.commentNum.integerValue];
   
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_WIDTH,1)];
//    lineView.backgroundColor = RGBA(243, 243, 243, 1);
//        [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
