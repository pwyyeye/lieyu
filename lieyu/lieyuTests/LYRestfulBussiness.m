//
//  LYRestfulBussiness.m
//  lieyu
//
//  Created by newfly on 9/23/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYRestfulBussiness.h"

HttpOperatorProvider * httpClient = nil;

@implementation LYRestfulBussiness

+(void)queryDrinksAction:(NSNumber *)miniprice maxPrice:(NSNumber *)maxPrice minnum:(NSNumber *)minium maxnum:(NSNumber *)maxnum handle:(bNetReqResponse)rep
{
    NSDictionary  * param =
        @{@"minprice":[miniprice stringValue],
          @"maxprice":[miniprice stringValue],
          @"minnum":[miniprice stringValue],
          @"maxnum":[miniprice stringValue]                     };
    httpClient  = [[HttpOperatorProvider alloc] initWithBaseUrl:URL init:^(NSObject *obj) {
        
    }];
    
//    
//    RKResponseDescriptor *des = RestKitResponse(API_QUERYDRINK, [LYRestfulResponseBase mapping], @"");
//    [httpClient.client addResponseDescriptor:des];
//    [httpClient postDataWithApi:URL api:API_QUERYDRINK jsonParams:param retHandle:^(LYErrorMessage *erMsg, id data) {
//        
//    }];

}


@end
