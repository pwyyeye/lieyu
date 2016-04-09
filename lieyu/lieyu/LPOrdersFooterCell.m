//
//  LPOrdersFooterCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersFooterCell.h"
#import "UserModel.h"

@implementation LPOrdersFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = self.shaperLbl.bounds;
    [shapeLayer setPosition:_shaperLbl.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 9, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shapeLayer];
    
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
    _oliverLabel.hidden = YES;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 102) byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 102);
    layer.path = bezierPath.CGPath;
    _backGround.layer.mask = layer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OrderInfoModel *)model{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserModel *userModel = app.userModel;
    _acturePriceLbl.text = [NSString stringWithFormat:@"¥%@",model.amountPay];
    if (model.orderStatus == 9) {
        _oliverLabel.hidden = YES;
        _profitStatusLbl.text = @"已返利";
        _profitLbl.text = [NSString stringWithFormat:@"¥%.2f",[model.rebateAmout doubleValue]];
    }else if (model.orderStatus == 10){
        _oliverLabel.hidden = YES;
        _profitStatusLbl.text = @"已退款";
        double backPrice = [model.amountPay doubleValue] - [model.penalty doubleValue];
        _profitLbl.text = [NSString stringWithFormat:@"¥%g",backPrice];
    }else if (model.orderStatus == 3 || model.orderStatus == 4 || model.orderStatus == 5){
        _oliverLabel.hidden = YES;
        _profitStatusLbl.text = @"可退款";
        double backPrice = [model.amountPay doubleValue] - [model.penalty doubleValue];
        _profitLbl.text = [NSString stringWithFormat:@"¥%g",backPrice];
    }else{
        _oliverLabel.hidden = YES;
        _profitStatusLbl.text = @"可返利";
        _profitLbl.text = [NSString stringWithFormat:@"¥%@",model.rebateAmout];
    }
    if (model.orderStatus == 0) {
        //待付款
        _firstButton.hidden = NO;
        _firstButton.layer.borderColor = [RGBA(128, 128, 128, 1) CGColor];
        _firstButton.layer.borderWidth = 0.5;
        [_firstButton setBackgroundColor:[UIColor whiteColor]];
        [_firstButton setTitleColor:RGBA(128, 128, 128, 1) forState:UIControlStateNormal];
        _secondButton.hidden = NO;
        _secondButton.layer.borderWidth = 0 ;
        [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (model.ordertype == 1) {
            _introduceLbl.hidden = NO;
            [_introduceLbl setFont:[UIFont systemFontOfSize:12]];
//            [_introduceLbl setTextColor:RGBA(186, 40, 227, 1)];
            [_introduceLbl setText:[NSString stringWithFormat:@"%d人组局",model.pinkerCount]];
            if (userModel.userid == model.userid) {
                [_secondButton setTitle:@"立即组局" forState:UIControlStateNormal];
                [_firstButton setTitle:@"取消组局" forState:UIControlStateNormal];
            }else{
                [_secondButton setTitle:@"立即支付" forState:UIControlStateNormal];
                [_firstButton setTitle:@"删除订单" forState:UIControlStateNormal];
            }
        }else{
            [_secondButton setTitle:@"立即付款" forState:UIControlStateNormal];
            [_firstButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _introduceLbl.hidden = YES;
        }
    }else if (model.orderStatus == 1 || model.orderStatus == 2){
        //待消费
        _firstButton.hidden = YES;
        _secondButton.hidden = NO;
        _secondButton.layer.borderColor = [RGBA(127, 127, 127, 1) CGColor];
        _secondButton.layer.borderWidth = 0.5;
        [_secondButton setTitleColor:RGBA(127, 127, 127, 1) forState:UIControlStateNormal];
        [_introduceLbl setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14]];
        NSString *introduce;
        NSString *consumptionCode;
        if (model.userid == userModel.userid) {
            consumptionCode = [MyUtil decryptUseDES:model.consumptionCode withKey:app.desKey];
            introduce = [NSString stringWithFormat:@"消费码：%@",consumptionCode];
        }
        if (model.ordertype == 1) {
            //拼客
            if(model.userid == userModel.userid){
                //我发起
                NSMutableAttributedString *attiString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %d人组局",introduce,model.pinkerCount]];
                [attiString addAttribute:NSStrikethroughStyleAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(consumptionCode.length + 6, attiString.length - consumptionCode.length - 6)];
                [_introduceLbl setAttributedText:attiString];
                [_secondButton setTitle:@"取消组局" forState:UIControlStateNormal];
            }else{
                [_introduceLbl setText:[NSString stringWithFormat:@"%d人组局",model.pinkerCount]];
                [_introduceLbl setFont:[UIFont systemFontOfSize:12]];
                _secondButton.layer.borderWidth = 0 ;
                [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
                [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_secondButton setTitle:@"查看详情" forState:UIControlStateNormal];
            }
        }else{
            [_introduceLbl setText:introduce];
            [_secondButton setTitle:@"取消订单" forState:UIControlStateNormal];
        }
    }else if (model.orderStatus == 8){
        //待评价
        _firstButton.hidden = YES;
        _secondButton.hidden = NO;
        [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
        _secondButton.layer.borderWidth = 0 ;
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_secondButton setTitle:@"立即评价" forState:UIControlStateNormal];
        if (model.ordertype == 1) {
            [_introduceLbl setFont:[UIFont systemFontOfSize:12]];
            [_introduceLbl setText:[NSString stringWithFormat:@"%d人组局",model.pinkerCount]];
        }else{
            _introduceLbl.hidden = YES;
        }
    }else if (model.orderStatus == 7 || model.orderStatus == 9){
        //待返利 － 7  已返利 － 9
        _firstButton.hidden = YES;
        _secondButton.hidden = NO;
        _secondButton.layer.borderWidth = 0.5;
        _secondButton.layer.borderColor = [RGBA(127, 127, 127, 1) CGColor];
        [_secondButton setTitleColor:RGBA(127, 127, 127, 1) forState:UIControlStateNormal];
        if (model.orderStatus == 7) {
            //加上承诺label
            _oliverLabel.hidden = NO;
            [_secondButton setTitle:@"查看详情" forState:UIControlStateNormal];
        }else{
            [_secondButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
        if (model.ordertype == 1) {
            _introduceLbl.hidden = NO;
            [_introduceLbl setText:[NSString stringWithFormat:@"%d人组局",model.pinkerCount]];
            [_introduceLbl setFont:[UIFont systemFontOfSize:14]];
        }else{
            _introduceLbl.hidden = YES;
        }
    }else if (model.orderStatus == 3 || model.orderStatus == 4 || model.orderStatus == 5 || model.orderStatus == 10){
        //待退款 － 3.4.5  已退款 － 10
        _introduceLbl.hidden = YES;
        _firstButton.hidden = YES;
        _secondButton.hidden = NO;
        if (model.orderStatus == 10) {
            _secondButton.layer.borderWidth = 0.5;
            _secondButton.layer.borderColor = [RGBA(127, 127, 127, 1) CGColor];
            [_secondButton setTitleColor:RGBA(127, 127, 127, 1) forState:UIControlStateNormal];
            [_secondButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }else{
            _secondButton.layer.borderWidth = 0 ;
            [_secondButton setBackgroundColor:RGBA(186, 40, 227, 1)];
            [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_secondButton setTitle:@"退款中" forState:UIControlStateNormal];
        }
    }
}

@end
