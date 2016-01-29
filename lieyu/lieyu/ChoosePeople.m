//
//  ChoosePeople.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChoosePeople.h"

@implementation ChoosePeople

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)lessBtnClick:(UIButton *)sender {
    int num = [self.numberField.text intValue];
    if(num > 3){
        self.numberField.text = [NSString stringWithFormat:@"%d",--num];
    }else if(num == 3){
        self.numberField.text = @"2";
        self.lessBtn.enabled = NO;
        [self.lessBtn setBackgroundImage:[UIImage imageNamed: @"gray_less"] forState:UIControlStateNormal];
    }else{
        return;
    }
}

- (IBAction)addBtnClick:(UIButton *)sender {
    self.numberField.text = [NSString stringWithFormat:@"%d",[self.numberField.text intValue] + 1];
    self.lessBtn.enabled = YES;
    [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
}

- (void)configure:(int)defaultNum{
    if (defaultNum > 2) {
        [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
        self.numberField.text = [NSString stringWithFormat:@"%d",defaultNum];
    }else if(defaultNum == 1 || defaultNum == 2){
        self.numberField.text = @"2";
    }
}

@end
