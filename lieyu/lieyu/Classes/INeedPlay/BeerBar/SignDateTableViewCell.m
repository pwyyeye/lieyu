//
//  SignDateTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SignDateTableViewCell.h"

@implementation SignDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = COMMON_PURPLE;
    [color set];
    UIBezierPath *cPath = [UIBezierPath bezierPathWithRect:CGRectMake(30, -1, 4, 200)];
    [cPath fill];
    
    //color = [UIColor redColor];
    [color set]; //设置线条颜色
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(24, 16, 16, 16)];
    
    [aPath fill];
    
    color = [UIColor whiteColor];
    [color set];
    UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(28, 20, 8, 8)];
    [bPath fill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
