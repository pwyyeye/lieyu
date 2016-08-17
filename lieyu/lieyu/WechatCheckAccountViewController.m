//
//  wechatCheckAccountViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "wechatCheckAccountViewController.h"
#import "LYUserHttpTool.h"
#import "SingletonTenpay.h"
@interface wechatCheckAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *shapeLabel;



@end

@implementation wechatCheckAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _checkButton.layer.cornerRadius = 21;
    if ([MyUtil isEmptyString:_nsCode]) {
        [self getnsData];
    }
    
    [self.checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = CGRectMake(150, 150, SCREEN_WIDTH - 10, 1);
    [shapeLayer setPosition:_shapeLabel.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[RGBA(0, 0, 0, 0.2)CGColor]];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[_shapeLabel layer]addSublayer:shapeLayer];
}

#pragma mark － 支付所需的微信ns码
- (void)getnsData{
    [LYUserHttpTool checkZSwechatComplete:^(NSString *result) {
        self.nsCode = result;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BaseGoBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkClick{
    if ([MyUtil isEmptyString:_nsCode]) {
        [MyUtil showCleanMessage:@"暂时无法验证！"];
        return;
    }
    SingletonTenpay *tenpay=[SingletonTenpay singletonTenpay];
    tenpay.isManagerCheck=1;
    [tenpay preparePay:@{@"orderNo":self.nsCode,@"payAmount":@"1",@"productDescription":@"申请专属经理账号验证"} complete:^(BaseReq *result) {
        if (result) {
            [tenpay onReq:result];
        }else{
            [MyUtil showMessage:@"无法调起微信支付！"];
        }
    }];
}

@end
