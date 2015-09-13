//
//  IdentifiedObject.m
//  LYApp
//
//  Created by ZKTeco on 4/17/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import "LYCoreDataObject.h"
#import "LYDataStore.h"

@implementation LYCoreDataObject

@dynamic recordId;

+(NSString*)entityName
{
    return [[self class] description];
}

+(instancetype)createObject
{
    LYDataStore *store = [LYDataStore currentInstance];
    LYCoreDataObject *iObj = (LYCoreDataObject*)[store createObjectOfEntity:[self entityName]];
    iObj.recordId = [[[NSUUID UUID] UUIDString] lowercaseString];
    return iObj;
}



@end







