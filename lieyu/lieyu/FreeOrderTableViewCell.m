//
//  FreeOrderTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/6/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FreeOrderTableViewCell.h"

@implementation FreeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect{
    //两条虚线
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.bounds = _firstShapeLine.bounds;
    [shapeLayer1 setPosition:_firstShapeLine.center];
    [shapeLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer1 setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer1 setLineWidth:0.5];
    [shapeLayer1 setLineJoin:kCALineJoinRound];
    [shapeLayer1 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.bounds = _secondShapeLine.bounds;
    [shapeLayer2 setPosition:_secondShapeLine.center];
    [shapeLayer2 setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer2 setStrokeColor:RGBA(205, 205, 205, 1).CGColor];
    [shapeLayer2 setLineWidth:0.5];
    [shapeLayer2 setLineJoin:kCALineJoinRound];
    [shapeLayer2 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 8, -58);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 11, -58);
    [shapeLayer1 setPath:path];
    [shapeLayer2 setPath:path];
    CGPathRelease(path);
    [[_firstShapeLine layer]addSublayer:shapeLayer1];
    [[_secondShapeLine layer]addSublayer:shapeLayer2];
    
    //
    _bgView.layer.cornerRadius = 4;
    _userAvatarImage.layer.cornerRadius = 20;
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFreeOrder:(LYFreeOrderModel *)freeOrder{
    _freeOrder = freeOrder;
    [_consumerAddressLabel setText:_freeOrder.barname];
    _freeOrder.cassetteType == 1 ? [_kazuoTypeLabel setText:@"散座"] : (_freeOrder.cassetteType == 2 ? [_kazuoTypeLabel setText:@"小卡"] : (_freeOrder.cassetteType == 3 ? [_kazuoTypeLabel setText:@"大卡"] : [_kazuoTypeLabel setText:@"其他"]));
    [_orderNumberLabel setText:[NSString stringWithFormat:@"%d",_freeOrder.id]];
    [_orderCreateTimeLabel setText:_freeOrder.createTime];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.userModel.usertype isEqualToString:@"2"] || [app.userModel.usertype isEqualToString:@"3"]) {
        //用户的信息
        [_userAvatarImage sd_setImageWithURL:[NSURL URLWithString:_freeOrder.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNickLabel setText:_freeOrder.usernick];
    }else{
        [_userAvatarImage sd_setImageWithURL:[NSURL URLWithString:_freeOrder.vipAvatarImg] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNickLabel setText:_freeOrder.vipUsernick];
    }
    [_consumerTimeLabel setText:_freeOrder.reachTime];
    _freeOrder.orderStatus == 1 ? [_orderStatusLabel setText:@"待确认"] : (_freeOrder.orderStatus == 2 ?  [_orderStatusLabel setText:@"待评价"] : [_orderStatusLabel setText:_freeOrder.isSatisfactionName]);
    if (_freeOrder.minPartNumber < 10) {
        [_orderJoinLabel setText:[NSString stringWithFormat:@"%ld～%ld人参与",_freeOrder.minPartNumber,_freeOrder.partNumber]];
    }else{
        [_orderJoinLabel setText:[NSString stringWithFormat:@"%ld人以上参与",_freeOrder.minPartNumber]];
    }
     BOOL shanghuban = [[NSUserDefaults standardUserDefaults] boolForKey:@"shanghuban"];
    if (([app.userModel.usertype isEqualToString:@"2"] || [app.userModel.usertype isEqualToString:@"3"])&&shanghuban) {
        if (_freeOrder.orderStatus == 1) {
            _firstButton.hidden = YES;
            _secondButton.hidden = NO;
            [_secondButton setTitle:@"预留卡座" forState:UIControlStateNormal];
            [self drawPurperLayer:_secondButton];
        }else{
            _firstButton.hidden = YES;
            _secondButton.hidden = YES;
        }
    }else{
        //普通用户
        if (_freeOrder.orderStatus == 1) {
            _firstButton.hidden = YES;
            _secondButton.hidden = NO;
            [_secondButton setTitle:@"取消" forState:UIControlStateNormal];
            [self drawGrayLayer:_secondButton];
        }else if (_freeOrder.orderStatus == 2){
            _firstButton.hidden = NO;
            [_firstButton setTitle:@"满意" forState:UIControlStateNormal];
            _secondButton.hidden = NO;
            [_secondButton setTitle:@"不满意" forState:UIControlStateNormal];
            [self drawPurperLayer:_firstButton];
            [self drawGrayLayer:_secondButton];
        }else{
            _firstButton.hidden = YES;
            _secondButton.hidden = NO;
            [_secondButton setTitle:@"删除" forState:UIControlStateNormal];
            [self drawGrayLayer:_secondButton];
        }
    }
}

- (void)drawGrayLayer:(UIButton *)button{
    button.layer.borderColor = RGBA(128, 128, 128, 1).CGColor;
    button.layer.borderWidth = 0.5;
    [button setTitleColor:RGBA(128, 128, 128, 1) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
}

- (void)drawPurperLayer:(UIButton *)button{
    button.layer.borderWidth = 0 ;
    [button setBackgroundColor:RGBA(186, 40, 227, 1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
