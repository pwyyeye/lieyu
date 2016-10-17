//
//  SingletonAlipay.m
//  haitao
//
//  Created by pwy on 15/8/7.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SingletonAlipay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
@implementation SingletonAlipay
//获取支付单例
+(SingletonAlipay *)singletonAlipay{
    static dispatch_once_t onceToken;
    static SingletonAlipay *singletonAlipay;
    dispatch_once(&onceToken, ^{
        singletonAlipay=[[SingletonAlipay alloc] init];
    });
    NSLog(@"-------singletonAlipay---------%@",singletonAlipay);
    return singletonAlipay;
}
-(void)payOrder:(AlipayOrder *) order{

    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021655735042";
    NSString *seller = @"410164551@qq.com";
    NSString *privateKey =@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJqjmJvcEWjNTjbPLP/RjFo/7QnPh38mTKST9UgUz0a2df3pfnIj7D7/fnou2qM8Lk5Iz/bMJ0Vz6Zwdd9OSaWWctUU0xFhR2M2pH69I7/kUbUFMuRENWThwWUemIeZV34PVb+nPPcYSUIhwnZCs8On65eFbZQyCvIQSBe5IMwhzAgMBAAECgYB7kXi0KvFabpwuXfTWYwslXum6KjRa3S7nYDfjJoXPOqQkhr181cnFOYJGfkRFpiRWeAZ+bvp+nDYzgrSqwtcmlkgZloRFLxKuvTGtlPMojXsq0uSYPycLjif9d9sfyjpP5qHZWUPPxVKGI851xRBXVf8u8UumqZnqZAc5GvaqoQJBAMjqtDlL52T9bWtP7dS2tqETDNYTrA6jTo1mJlhFnPBGjuE6MchVaBoxUj3RYFBtSX7fqsZgrpxo4HEMO3Q0G4MCQQDFCOYYjVwoXSsf9MRKhGgDxXlnc287hA2xZzssm1Yf37h0nUZJzfM2CCukjWeO+fkKdadyn9UY0Oi3d//KPBxRAkBTJqeN6vcKGcRWHE9OsIum4A547s1PhZC1/meyMqU/38O0PPRrd8VMycrCoMuenYxEQOcZkNvTCaiRwME+V25nAkAy+9B+PeXA1Arao/0+wvAfObPmXupDXjIk229mZXNtn/gcxK1xX4c1TfvtAmHvjyMv363KbS041KXDA5v+enthAkEAlPTgyZLYgLa6aeFf8aMQrb4szZf97vQz2CIPFs6fr7+jA5OA2/laLY0pDpLHCpASCo9a9sXZp+er3f7s+EHH6w==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
//    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    //--------必须填充－－－－begin
//    order.tradeNO = @"123123123"; //订单ID（由商家自行制定）
//    order.productName = @"商品标题"; //商品标题
//    order.productDescription = @"商品描述"; //商品描述
    //必须填充－－－－－－－－－end
    
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@alipayOrderAction.do",LY_SERVER]; //回调URL  $return_url = DOMAIN."/plugins/pk_alipay/pk_return_url.php";
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"lieyu";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        /***
         9000 订单支付成功
         8000 正在处理中
         4000 订单支付失败
         6001 用户中途取消
         6002 网络连接出错
         */
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([self.delegate respondsToSelector:@selector(callBack:)]) {
                [self.delegate callBack:resultDic];
            }else{
                NSLog(@"reslut with no delegate");
            }
            
        }];

    }
    
}
@end
