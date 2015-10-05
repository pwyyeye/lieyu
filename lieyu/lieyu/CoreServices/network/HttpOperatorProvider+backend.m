//
//  ZKNetworkOperator+ .m
//  LYAppApp
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import "HttpOperatorProvider+backend.h"
#import "RestfulConstant.h"

@implementation HttpOperatorProvider (backend )

+(HttpOperatorProvider *)sharedBackendClient
{
    static HttpOperatorProvider * Client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
    ^{
        if ( Client == nil)
        {
             Client = [[HttpOperatorProvider alloc] initWithBaseUrl:nil init:^(NSObject *obj)

            {
            }];
        }
    });
    return  Client;
}


@end

















