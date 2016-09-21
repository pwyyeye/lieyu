//
//  LYOrderWriteTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYOrderWriteTableViewCell.h"

@implementation LYOrderWriteTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)jiaAct:(UIButton *)sender {
    int count = self.label_count.text.intValue;
    count++;
    self.label_count.text=[NSString stringWithFormat:@"%d",count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numChange" object:nil];
    [self.btn_minus setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
}

- (IBAction)jianAct:(UIButton *)sender {
    int count = self.label_count.text.intValue;
    if (count>1) {
        count--;
    }
    if (count == 1) {
        [self.btn_minus setBackgroundImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
    }
    self.label_count.text=[NSString stringWithFormat:@"%d",count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numChange" object:nil];
}

@end
