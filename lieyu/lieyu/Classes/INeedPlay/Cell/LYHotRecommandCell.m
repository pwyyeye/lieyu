//
//  LYHotRecommandCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotRecommandCell.h"

@implementation LYHotRecommandCell

- (void)awakeFromNib {
    // Initialization code
    _label_line_bottom.bounds = CGRectMake(0, 0, 320, 0.5);
    _label_line_top.bounds = CGRectMake(0, 0, 320, 0.2);
    _label_line_bottom.hidden = YES;
    //_label_line_top.hidden = YES;
   // _label_line_top.backgroundColor = [UIColor redColor];
   // _label_line_bottom.backgroundColor= [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
