//
//  LYAmusementClassCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAmusementClassCell.h"
#import "LYHotJiuBarViewController.h"

@implementation LYAmusementClassCell

- (void)awakeFromNib {
    // Initialization code
//    self.scrollView.directionalLockEnabled = YES;

    
    self.label_lineTop.frame = CGRectMake(0, 0, 320, 0.5);
    self.label_line_middle.frame = CGRectMake(0, 44.5, 320, 0.5);
    self.label_line_bottom.bounds = CGRectMake(0, 0, 320, 0.5);
    self.label_line_bottom.hidden = YES;
    
    for (UIButton *btn in _buttonArray) {
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
    }
    [((UIButton *)_buttonArray[0]) setBackgroundImage:[UIImage imageNamed:@"jiQingYeDian.jpg"] forState:UIControlStateNormal];
    [((UIButton *)_buttonArray[1]) setBackgroundImage:[UIImage imageNamed:@"文艺清吧.jpg"] forState:UIControlStateNormal];
    [((UIButton *)_buttonArray[2]) setBackgroundImage:[UIImage imageNamed:@"音乐清吧1.jpg"] forState:UIControlStateNormal];
    [((UIButton *)_buttonArray[3]) setBackgroundImage:[UIImage imageNamed:@"ktv.jpg"] forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
