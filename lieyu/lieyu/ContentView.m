//
//  ContentView.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

- (void)awakeFromNib{
    self.buttonsArray = @[_redioButton1,_radioButton2,_radioButton3];
    self.buttonStatusArray = [NSMutableArray array];
}

- (IBAction)Btn1Click:(UIButton *)sender {
    for (UIButton *button in _buttonsArray) {
        if(button == sender){
            [button setBackgroundImage:[UIImage imageNamed: @"CustomBtn_Selected"] forState:UIControlStateNormal];
            button.selected = YES;
        }else{
            [button setBackgroundImage:[UIImage imageNamed: @"CustomBtn_unSelected"] forState:UIControlStateNormal];
            button.selected = NO;
        }
    }
    
    [self.redioButton1 setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateNormal];
}

- (IBAction)Btn2Click:(UIButton *)sender {
    [self.radioButton2 setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateNormal];
}

- (IBAction)Btn3Click:(UIButton *)sender {
    [self.radioButton3 setBackgroundImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateNormal];
}
@end
