//
//  SingletonTenpay.m
//  lieyu
//
//  Created by pwy on 15/11/21.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SingletonTenpay.h"
#import "MJExtension.h"
#import "LYMyOrderManageViewController.h"
@implementation SingletonTenpay
//获取支付单例
+(SingletonTenpay *)singletonTenpay{
    static dispatch_once_t onceToken;
    static SingletonTenpay *singletonTenpay;
    dispatch_once(&onceToken, ^{
        singletonTenpay=[[SingletonTenpay alloc] init];
    });
    NSLog(@"-------singletonAlipay---------%@",singletonTenpay);
    return singletonTenpay;
}

-(void)preparePay:(NSDictionary *)param complete:(void (^)(BaseReq *result))block{
    [[LYUserHttpTool shareInstance] prepareWeixinPayWithParams:param complete:^(NSDictionary *result) {
        _tenpayModel=[TenpayModel objectWithKeyValues:result];
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = _tenpayModel.partnerid;
        request.prepayId= _tenpayModel.prepayid;
        request.package =_tenpayModel.package;// @"Sign=WXPay";
        request.nonceStr= _tenpayModel.noncestr;
        request.timeStamp=_tenpayModel.timestamp.intValue;
        request.sign=_tenpayModel.paySign;
        block(request);
    }];
}

-(void) onReq:(BaseReq*)req{
    [WXApi sendReq:req];
}

-(void) onResp:(BaseResp*)resp{
    NSLog(@"----pass-onResp%@---",resp);
    //0成功 1失败 2用户取消
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [MyUtil showMessage:@"支付成功！"];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;

    UIViewController *detailViewController;
    
    detailViewController  = [[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    [delegate.navigationController pushViewController:detailViewController animated:YES];
}
@end
