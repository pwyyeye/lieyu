//
//  PTPayAmoutCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTPayAmoutCell.h"

@implementation PTPayAmoutCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
