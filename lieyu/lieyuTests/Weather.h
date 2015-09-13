//
//  Weather.h
//  lieyu
//
//  Created by newfly on 9/13/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKitMapping.h"

@interface Weather : NSObject<RestKitMapping>

@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * cityid;
@property(nonatomic,copy)NSString * WD;


@end



