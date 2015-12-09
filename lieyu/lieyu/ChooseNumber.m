//
//  ChooseNumber.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseNumber.h"

@implementation ChooseNumber

- (IBAction)lessBtnClick:(UIButton *)sender {
    int num = [self.numberField.text intValue];
    if(num > 2){
        self.numberField.text = [NSString stringWithFormat:@"%d",--num];
    }else if(num == 2){
        self.numberField.text = @"1";
        self.lessBtn.enabled = NO;
        [self.lessBtn setBackgroundImage:[UIImage imageNamed: @"gray_less"] forState:UIControlStateNormal];
    }else{
        return;
    }
}

- (IBAction)addBtnClick:(UIButton *)sender {
//    if(num < _store - 1){
//        self.numberField.text = [NSString stringWithFormat:@"%d",++num];
//        if(self.lessBtn.enabled == NO){
//            [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
//        }
//    }else if(num == _store - 1){
//        self.numberField.text = [NSString stringWithFormat:@"%d",_store];
//        self.addBtn.enabled = NO;
//        [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//    }else{
//        return;
//    }
    self.numberField.text = [NSString stringWithFormat:@"%d",[self.numberField.text intValue] + 1];
    self.lessBtn.enabled = YES;
    [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
}
@end
