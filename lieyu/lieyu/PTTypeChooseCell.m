//
//  PTTypeChooseCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTTypeChooseCell.h"

@implementation PTTypeChooseCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)typeChooseAct:(UIButton *)sender {
    [sender setSelected:YES];
    if(sender.tag==100){
        _pinkertype=@"0";
        [self.aaBtn setSelected:false];
        [self.freePayBtn setSelected:false];
    }else if(sender.tag==101){
        _pinkertype=@"1";
        [self.payAllBtn setSelected:false];
        [self.freePayBtn setSelected:false];
    }else{
        _pinkertype=@"2";
        [self.aaBtn setSelected:false];
        [self.payAllBtn setSelected:false];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"typeChange" object:nil];
}
@end
