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
    _label_line_bottom.frame = CGRectMake(0, 45, SCREEN_WIDTH, 0.3);
    _viewLineTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
