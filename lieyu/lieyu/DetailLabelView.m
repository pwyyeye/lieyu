//
//  DetailLabelView.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailLabelView.h"

@implementation DetailLabelView

- (void)configureManager{
    [_introduceLbl setText:@"选择的VIP专属经理:"];
    [_numberLbl setHidden:YES];
}

- (void)configureNumber:(int)number{
    [_introduceLbl setText:@"已参与组局玩友："];
    [_numberLbl setHidden:NO];
    [_numberLbl setText:[NSString stringWithFormat:@"%d人参与",number]];
}

@end
