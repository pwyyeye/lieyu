//
//  WeathGetManager.m
//  lieyu
//
//  Created by newfly on 9/13/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "WeathGetManager.h"
#import "Weather.h"
#import "RestKit.h"

NSString *baseWeathUrl = @"http://www.weather.com.cn/adat/";

@implementation WeathGetManager

HttpOperatorProvider * httpClient = nil;


- (void)getWeath:(bNetReqResponse)rep
{
   httpClient  = [[HttpOperatorProvider alloc] initWithBaseUrl:baseWeathUrl init:^(RKObjectManager *obj) {
       
   }];
    
    __block NSString *api = @"sk/101010100.html";
    
    RKResponseDescriptor *des = RestKitResponse(api, [Weather mapping], @"weatherinfo");
    [httpClient.client addResponseDescriptor:des];
    [httpClient getDataWithApi:baseWeathUrl api:api jsonParams:nil retHandle:^(LYErrorMessage *erMsg, id data) {
        if (erMsg.state != Req_Sending)
        {
            [httpClient.client removeResponseDescriptor:des];
        }
    }];
}

@end




