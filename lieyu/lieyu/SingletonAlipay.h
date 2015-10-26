//
//  SingletonAlipay.h
//  haitao
//
//  Created by pwy on 15/8/7.
//  Copyright (c) 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayOrder.h"

@protocol SingletonAlipayProtocol<NSObject>

-(void)callBack:(NSDictionary *)resultDic;

@end

@interface SingletonAlipay : NSObject

@property(strong,nonatomic) id<SingletonAlipayProtocol> delegate;

+(SingletonAlipay *)singletonAlipay;
-(void)payOrder:(AlipayOrder *) order;
@end
