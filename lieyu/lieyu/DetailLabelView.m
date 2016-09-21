//
//  DetailLabelView.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailLabelView.h"

@implementation DetailLabelView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 26) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 26);
    layer.path = bezierPath.CGPath;
    _backGround.layer.mask = layer;
}


- (void)configureManager:(BOOL)isManager{
    if (isManager) {
        [_introduceLbl setText:@"选择的VIP专属经理:"];
        [_numberLbl setHidden:YES];
    }else{
        [_introduceLbl setText:@"邀请我的人:"];
        [_numberLbl setHidden:YES];
    }
}

- (void)configureNumber:(int)number{
    [_introduceLbl setText:@"已参与组局玩友："];
    [_numberLbl setHidden:NO];
    [_numberLbl setText:[NSString stringWithFormat:@"%d人参与",number]];
}

@end
