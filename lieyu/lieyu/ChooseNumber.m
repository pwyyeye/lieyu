//
//  ChooseNumber.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseNumber.h"

@implementation ChooseNumber
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_store == 1) {
        self.addBtn.enabled = NO;
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
    }
}

- (void)setStartNum:(NSUInteger)startNum{
    _startNum = startNum;
    if (_startNum <= 0) {
        _startNum = 1;
    }
    if (_startNum > 1) {
        self.lessBtn.enabled = YES;
        [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
    }
    _numberField.text = [NSString stringWithFormat:@"%ld",_startNum];
}

- (IBAction)lessBtnClick:(UIButton *)sender {
    int num = [self.numberField.text intValue];
    if(num > 2){
        self.numberField.text = [NSString stringWithFormat:@"%d",--num];
    }else if(num == 2){
        self.numberField.text = @"1";
        self.lessBtn.enabled = NO;
        [self.lessBtn setBackgroundImage:[UIImage imageNamed: @"gray_less"] forState:UIControlStateNormal];
    }
    if (_store) {
        if ([self.numberField.text intValue] < _store) {
            self.addBtn.enabled = YES;
            [self.addBtn setBackgroundImage:[UIImage imageNamed:@"purper_add"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)addBtnClick:(UIButton *)sender {
    self.numberField.text = [NSString stringWithFormat:@"%d",[self.numberField.text intValue] + 1];
    self.lessBtn.enabled = YES;
    [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
    if (_store) {
        if ([self.numberField.text intValue] >= _store) {
            self.addBtn.enabled = NO;
            [self.addBtn setBackgroundImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
        }
    }
}

- (void)configureTitle{
    self.title.text = @"选择参与人次";
}

- (void)configureTitleForAdviser{
    self.title.text = @"选择到达现场人数";
}

@end
