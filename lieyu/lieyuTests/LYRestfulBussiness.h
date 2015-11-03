//
//  LYRestfulBussiness.h
//  lieyu
//
//  Created by newfly on 9/23/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpOperatorProvider.h"

#define API_QUERYDRINK @"drinksAction.do?action=list"
#define URL LY_SERVER


@interface LYRestfulBussiness : NSObject

+(void)queryDrinksAction:(NSNumber *)miniprice maxPrice:(NSNumber *)maxPrice minnum:(NSNumber *)minium maxnum:(NSNumber *)maxnum handle:(bNetReqResponse)rep;

@end
