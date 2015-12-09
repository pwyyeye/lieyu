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
    _label_line_bottom.frame = CGRectMake(0, 45, SCREEN_WIDTH, 0.4);
    _viewLineTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.4);
    
    //_label_line_bottom.hidden = YES;
    //_label_line_top.hidden = YES;
   // _label_line_top.backgroundColor = [UIColor redColor];
   // _label_line_bottom.backgroundColor= [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
