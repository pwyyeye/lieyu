//
//  ZKNetworkOperator+ .h
//  LYAppApp
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import "HttpOperatorProvider.h"


@interface HttpOperatorProvider (backend )

+(HttpOperatorProvider *)sharedBackendClient;

@end
