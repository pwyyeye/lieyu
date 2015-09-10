//
//  DataStore.h
//  timecube
//
//  Created by ZKTeco on 4/25/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Blocks.h"
#import "RestKit.h"

@class RKObjectManager;
@interface DataStore : NSObject

@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) RKManagedObjectStore *managedObjectStore;
@property(nonatomic, strong) RKObjectManager *objectManager;
@property(nonatomic,readonly)NSString *dbFilePath;
@property(nonatomic, copy) SimpleBlock onSave;

@property(nonatomic, readwrite) BOOL testMode;

+ (DataStore*) currentInstance;

- (id)createObjectOfEntity:(NSString *)entityName;

- (NSArray *)fetchEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sorterDescs:(NSArray *)sorters inSameContextAs:(NSManagedObject*)obj;

- (int)countEntity:(NSString *)entityName predicate:(NSPredicate *)predicate;

- (BOOL)save;

- (void)deleteObject:(NSManagedObject *)obj;

@end
