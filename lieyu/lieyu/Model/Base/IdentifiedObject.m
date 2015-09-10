//
//  IdentifiedObject.m
//  timecube
//
//  Created by ZKTeco on 4/17/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import "IdentifiedObject.h"
#import "DataStore.h"

@implementation IdentifiedObject

@dynamic recordId;

+(NSString*)entityName
{
    return [[self class] description];
}

+(instancetype)createObject
{
    DataStore *store = [DataStore currentInstance];
    IdentifiedObject *iObj = (IdentifiedObject*)[store createObjectOfEntity:[self entityName]];
    iObj.recordId = [[[NSUUID UUID] UUIDString] lowercaseString];
    return iObj;
}



@end







