//
//  LYAmusementClassCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAmusementClassCell.h"
#import "LYHotJiuBarViewController.h"
@interface LYAmusementClassCell()<UIScrollViewDelegate>

@end

@implementation LYAmusementClassCell

- (void)awakeFromNib {
    // Initialization code
//    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    
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
    
    [self.button_page_left addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.button_page_right addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pageClick:(UIButton *)buton{
    if (!buton.tag) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.button_page_left setBackgroundImage:[UIImage imageNamed:@"chevron right copy"] forState:UIControlStateNormal];
        [self.button_page_right setBackgroundImage:[UIImage imageNamed:@"chevron right"] forState:UIControlStateNormal];
    }else{
        [self.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        [self.button_page_left setBackgroundImage:[UIImage imageNamed:@"arrowLeftHight"] forState:UIControlStateNormal];
        [self.button_page_right setBackgroundImage:[UIImage imageNamed:@"arrowRitht"] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 300) {
        [self.button_page_left setBackgroundImage:[UIImage imageNamed:@"arrowLeftHight"] forState:UIControlStateNormal];
        [self.button_page_right setBackgroundImage:[UIImage imageNamed:@"arrowRitht"] forState:UIControlStateNormal];
    }else{
        [self.button_page_left setBackgroundImage:[UIImage imageNamed:@"chevron right copy"] forState:UIControlStateNormal];
        [self.button_page_right setBackgroundImage:[UIImage imageNamed:@"chevron right"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
