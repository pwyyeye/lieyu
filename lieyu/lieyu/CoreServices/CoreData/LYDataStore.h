//
//  LYDataStore.h
//  LYApp
//
//  Created by ZKTeco on 4/25/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Blocks.h"

@class RKObjectManager;
@interface LYDataStore : NSObject

@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,readonly)NSString *dbFilePath;
@property(nonatomic, copy) SimpleBlock onSave;

@property(nonatomic, readwrite) BOOL testMode;

+ (LYDataStore*) currentInstance;

- (id)createObjectOfEntity:(NSString *)entityName;

- (NSArray *)fetchEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sorterDescs:(NSArray *)sorters inSameContextAs:(NSManagedObject*)obj;

- (int)countEntity:(NSString *)entityName predicate:(NSPredicate *)predicate;

- (BOOL)save;

- (void)deleteObject:(NSManagedObject *)obj;

@end







