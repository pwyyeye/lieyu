//
//  IdentifiedObject.h
//  LYApp
//
//  Created by ZKTeco on 4/17/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LYCoreDataObject : NSManagedObject

@property (nonatomic, retain) NSString * recordId;
+(NSString*)entityName;
+(instancetype)createObject;

/**
 *  find coredata object
 *
 *  @param recordId recordId description
 *
 *  @return return value description
 */


@end
