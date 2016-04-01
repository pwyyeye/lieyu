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
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_WIDTH,1)];
    lineView.backgroundColor = RGBA(243, 243, 243, 1);
    [self addSubview:lineView];
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    _label_commentCount.text = [NSString stringWithFormat:@"查看全部%ld条评论...",recentM.commentNum.integerValue];
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0.5);
//    self.layer.shadowRadius = 1;
//    self.layer.shadowOpacity  = .1;
    
    
   
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
//    UIColor *color = RGBA(204, 204, 204, 1);
//    [color set];
//    UIBezierPath *bezierP = [[UIBezierPath alloc]init];
//    bezierP.lineWidth = 0.5;
//    [bezierP moveToPoint:CGPointMake(0,self.frame.size.height - 1)];
//    [bezierP addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 1)];
//    [bezierP stroke];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
