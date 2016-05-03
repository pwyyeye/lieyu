//
//  LPOrdersHeaderView.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrdersHeaderView.h"
#import <QuartzCore/QuartzCore.h>
@implementation LPOrdersHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = self.shaperLbl.bounds;
    [shapeLayer setPosition:_shaperLbl.center];
    [shapeLayer setFillColor:[[UIColor redColor] CGColor]];
    [shapeLayer setStrokeColor:RGBA(0, 0, 0, 1).CGColor];
    [shapeLayer setLineWidth:2];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 12, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH - 21, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shaperLbl layer]addSublayer:shapeLayer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 6, 59) byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 59);
    layer.path = bezierPath.CGPath;
    _backGround.layer.mask = layer;
    [self.telphone addTarget:self action:@selector(callTelephone) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setModel:(OrderInfoModel *)model{
    _model = model;
    self.placeLbl.text = model.barinfo.barname;
    self.orderStatusLbl.text = [MyUtil getOrderStatus:model.orderStatus];
    self.orderNumberLbl.text = [NSString stringWithFormat:@"%d",model.id];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"时间：%@",[model.createDate substringToIndex:model.createDate.length - 3]];
}

-(void)callTelephone{
    if (![MyUtil isEmptyString:self.telphone.titleLabel.text]) {
        NSLog(@"----pass-pass%@---",@"test");
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.telphone.titleLabel.text]];
        
        if ( !_phoneCallWebView ) {
            
            _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
            
        }
        
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];

    }
}

@end
