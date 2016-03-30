//
//  ZSTiXianTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/3/28.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSTiXianTableViewCell.h"

@implementation ZSTiXianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17, self.frame.size.height - 1, self.frame.size.width - 17, .8)];
//    lineView.backgroundColor = RGBA(230, 230, 230, 1);
//    [self addSubview:lineView];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *color = RGBA(204, 204, 204, 1);
    [color set];
    UIBezierPath *bezierP = [[UIBezierPath alloc]init];
    bezierP.lineWidth = 0.5;
    [bezierP moveToPoint:CGPointMake(17,self.frame.size.height - 1)];
    [bezierP addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 1)];
    [bezierP stroke];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
