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
    self.radioButtons = @[_redioButton1,_radioButton2,_radioButton3];
    self.selectButton = @[_selectBtn1, _selectBtn2, _selectBtn3];
    self.buttonStatusArray = [NSMutableArray array];
    [self.buttonStatusArray addObjectsFromArray:@[@"0",@"0",@"1"]];
}

- (void)contentViewChooseBtn{
    if([_defaultString isEqualToString:@"自由付款"] || [_defaultString isEqualToString:@"请选择消费方式"]){
        [self.radioButton3 setBackgroundImage:[UIImage imageNamed: @"CustomBtn_Selected"] forState:UIControlStateNormal];
    }else if([_defaultString isEqualToString:@"AA付款"]){
        [self.radioButton2 setBackgroundImage:[UIImage imageNamed: @"CustomBtn_Selected"] forState:UIControlStateNormal];
    }else{
        [self.redioButton1 setBackgroundImage:[UIImage imageNamed: @"CustomBtn_Selected"] forState:UIControlStateNormal];
    }
}

- (IBAction)BtnClick:(UIButton *)sender {
    [self.buttonStatusArray removeAllObjects];
    for (UIButton *button in _radioButtons) {
        if(button.tag == sender.tag){
            [button setBackgroundImage:[UIImage imageNamed: @"CustomBtn_Selected"] forState:UIControlStateNormal];
            button.selected = YES;
        }else{
            [button setBackgroundImage:[UIImage imageNamed: @"CustomBtn_unSelected"] forState:UIControlStateNormal];
            button.selected = NO;
        }
        [self.buttonStatusArray addObject:[NSString stringWithFormat:@"%d",button.selected]];
    }
}

@end
