//
//  RestKitMapping.h
//  TimeCubeApp
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;
@class RKEntityMapping;
@class RKManagedObjectStore;

@protocol RestKitMapping <NSObject>
@optional
+ (RKObjectMapping *)mapping;
@optional
+ (RKEntityMapping *)mapEntity:(RKManagedObjectStore *)store;
+ (id)fromDictionary:(NSDictionary *)dic;

@end

#define KPPAYLOAD_RESULT  @"payload.results"
#define KPPAYLOAD         @"payload"
#define KPROOT            @""

#define RestKitResponse(API,MAP,KEYPATH) [RKResponseDescriptor responseDescriptorWithMapping:MAP \
                                             method:RKRequestMethodAny     \
                                        pathPattern:API                     \
                                            keyPath:KEYPATH                   \
                                        statusCodes:[NSIndexSet indexSetWithIndex:RKStatusCodeClassSuccessful]]



extern  RKObjectMapping * RestKitMapWithDic(Class ca,NSDictionary *dic);



