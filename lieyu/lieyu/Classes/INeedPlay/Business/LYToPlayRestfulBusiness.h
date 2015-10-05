//
//  LYToPlayRestfulBusiness.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPController.h"
#import "MReqToPlayHomeList.h"
#import "NetPublic.h"

@interface LYToPlayRestfulBusiness : NSObject

- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList))block;

@end




