//
//  User+Utils.m
//  LYApp
//
//  Created by jolly on 15/8/3.
//  Copyright (c) 2015年 Steven Mai. All rights reserved.
//

#import "User+Utils.h"
#import "RestKit.h"
#import "LYDataStore.h"
#import "NSDictionary+Json.h"
#import "RestKitMapping.h"


@implementation User (Utils)

+(RKEntityMapping *)mapEntity:(RKManagedObjectStore *)store
{
    RKEntityMapping *selfMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:store];
    [selfMapping addAttributeMappingsFromDictionary:
     @{
       @"avatar"        :@"avatar",
       @"mobile"        :@"mobile",
       @"account":       @"account",
       @"name"          :@"name"
       }];
    selfMapping.identificationAttributes = @[@"name",@"account",@"mobile",@"avatar",@"recordId"];
    return selfMapping;
}


@end















