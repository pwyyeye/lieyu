//
//  LYAmusementClassCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAmusementClassCell.h"
#import "LYHotJiuBarViewController.h"
#import "bartypeslistModel.h"
#import "UIButton+WebCache.h"
#define LINEHEIGHT 0.3

@interface LYAmusementClassCell()<UIScrollViewDelegate>

@end

@implementation LYAmusementClassCell

- (void)awakeFromNib {
    // Initialization code
//    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    self.label_line_blue.frame = CGRectMake(0, 0.2, CGRectGetWidth(self.label_line_blue.frame), CGRectGetHeight(self.label_line_blue.frame));
    
    _viewLineTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, LINEHEIGHT);
    _viewLineMiddle.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, LINEHEIGHT);
    _viewLineBottom.frame = CGRectMake(0, 211, SCREEN_WIDTH, LINEHEIGHT);
    
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

- (void)setBartypeArray:(NSArray *)bartypeArray{
    _bartypeArray = bartypeArray;
    for (int i = 0; i < bartypeArray.count; i ++) {
        if (i == 1 || i == 2 || i == 3|| i == 0) {
            break;
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(8 + i%(bartypeArray.count) * (150 + 10) , 8, 150, 150)];
        btn.tag = i;
        [self.buttonArray addObject:btn];
        [self addSubview:btn];
    }
    
    for (int i = 0; i < bartypeArray.count; i ++) {
        UIButton *btn = self.buttonArray[i];
        bartypeslistModel *bartypeModel = bartypeArray[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:bartypeModel.imageurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"middlePlace"]];
    }
    _scrollView.contentSize = CGSizeMake(bartypeArray.count * SCREEN_WIDTH/2.0, 0);
    _scrollView.alwaysBounceVertical = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
