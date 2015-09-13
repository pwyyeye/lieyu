//
//  WeathGetManager.h
//  lieyu
//
//  Created by newfly on 9/13/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpOperatorProvider.h"

@interface WeathGetManager : NSObject

- (void)getWeath:(bNetReqResponse)rep;

@end
