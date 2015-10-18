//
//  PTChooseNumCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTChooseNumCell.h"

@implementation PTChooseNumCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)jiaAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    count++;
    self.numLal.text=[NSString stringWithFormat:@"%d",count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"typeChange" object:nil];
}

- (IBAction)jianAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    if (count>2) {
        count--;
    }
    self.numLal.text=[NSString stringWithFormat:@"%d",count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"typeChange" object:nil];
}
@end
