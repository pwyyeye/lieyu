//
//  DataStore.m
//  timecube
//
//  Created by ZKTeco on 4/25/15.
//  Copyright (c) 2015 ZKTeco. All rights reserved.
//

#import "DataStore.h"


static DataStore* currentInstance = nil;
static BOOL suppressServerCommunication = NO;

@implementation DataStore

+ (DataStore*) currentInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (currentInstance == nil)
        {
            currentInstance = [[DataStore alloc] initWithTestMode:NO];
        }

    });
       return currentInstance;
}

+ (void) destroyAllWithName:(NSString*)dbName {
    NSLog(@"Wiping out all data!");
    // delete all of the core data files.
    NSURL *storeURL = [self storeURL];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtURL:storeURL
                             includingPropertiesForKeys:@[]
                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                  error:nil];
    NSString* predicateFormat = [NSString stringWithFormat:@"lastPathComponent LIKE[c] '%@.sql*'", dbName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    NSArray *coreDataFiles = [dirContents filteredArrayUsingPredicate:predicate];
    for (NSString *file in coreDataFiles) {
        NSLog(@"    Deleting %@", file);
        NSError *error = nil;
        [fm removeItemAtPath:file error:&error];
        if (error) {
            NSLog(@"FAILED: %@", error);
        }
    }
    
    currentInstance = nil;
}

+ (NSURL *)storeURL {
    return [self applicationDocumentsDirectory];
}

+ (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "zkteco.timecube" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(id)initWithTestMode:(BOOL)_test  {
    if (self = [super init]) {
        self.testMode = _test;
        [self setupCoreData];
        if (!suppressServerCommunication)
        {
            //[self setupRestKit];
        }
        NSLog(@"Finished initing Data Store.");
    }
    return self;
}

-(void)setupCoreData {
    @try {
        [self setupManagedObjectModel];
        [self setupRKStorage];
        [self setupContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception setting up DB: %@, %@", exception, [exception userInfo]);
        if ([exception.name isEqualToString:NSInternalInconsistencyException]) {
            [self showDBConsistencyProblem];
        } else {
            @throw;
        }
        
    }
}

-(void)setupRestKit {

    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    self.objectManager.managedObjectStore = self.managedObjectStore;
    NSLog(@"Done setting up rest kit.");
}



- (void)setupManagedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"timecube" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (void)setupRKStorage {
    NSError *err = nil;
    
    self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSString *dbFileName = @"timecube";
    if (self.testMode) {
        dbFileName = @"Test";
        [DataStore destroyAllWithName:dbFileName];
    }
    NSURL *storeURL = [DataStore storeURL];
    NSString* pathComponent = [NSString stringWithFormat:@"%@.sqlite", dbFileName];
    storeURL = [storeURL URLByAppendingPathComponent:pathComponent];
    NSLog(@"Create store at path %@", storeURL.path);
    _dbFilePath = [storeURL absoluteString];
    NSDictionary *options = nil;


   options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
              };
    
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                              URL:storeURL
                                                                                            error:&err];
    
    if (err)
    {
        NSLog(@"Failed to get log for persistent store: %@", err);
        err = nil;
    }


    BOOL migrationNeeded = ![self.managedObjectModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    if (migrationNeeded) {
        NSLog(@"We will need to perform a migration on the persistent store.");
    }


    [self.managedObjectStore createPersistentStoreCoordinator];
    [self.managedObjectStore addSQLitePersistentStoreAtPath:storeURL.path
                                     fromSeedDatabaseAtPath:nil
                                          withConfiguration:nil
                                                    options:options
                                                      error:&err];
    
    if (err != nil) {
        NSLog(@"%@", err);
    }
}

- (void)setupContext
{
    [self.managedObjectStore createManagedObjectContexts];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];//NSMainQueueConcurrencyType];
    self.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    self.managedObjectContext.persistentStoreCoordinator = self.managedObjectStore.persistentStoreCoordinator;


    // Configure a managed object cache to ensure we do not create duplicate objects
    self.managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onObjectsChanged:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.managedObjectContext];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onObjectsNeedMerge:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectStore.mainQueueManagedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLocalObjectsSaved:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
}

- (void)onObjectsChanged:(NSNotification*)notification
{
    
}

- (void)onObjectsNeedMerge:(NSNotification*)notification
{

}

- (void)onLocalObjectsSaved:(NSNotification*)notification
{
    
}

-(id)createObjectOfEntity:(NSString *)entityName {
    if(entityName == nil || entityName.length == 0 || self.managedObjectContext == nil){
        NSLog(@"invalid arguments for entity object creation");
        return nil;
    }
    
    @try {
        return [NSEntityDescription
                insertNewObjectForEntityForName:entityName
                inManagedObjectContext:self.managedObjectContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occurred in createObjectOfEntity: %@, %@", exception, [exception userInfo]);
        if ([exception.name isEqualToString:NSInvalidArgumentException]) {
            // this should occur only when we are dealing with a DB that needs to be upgraded, which will
            // only happen with dev builds in between releases. Just swallow it long enough to show
            // an alert.
            return nil;
        }
        @throw;
    }
}

#pragma mark
#pragma - Core Data Saving support
-(BOOL)save {
    if (self.onSave) {
        self.onSave();
    }

//    if ([self.managedObjectStore.mainQueueManagedObjectContext hasChanges])
//    {
//        NSManagedObjectContext* c = self.managedObjectStore.mainQueueManagedObjectContext;
//        __block BOOL success = YES;
//        while (c && success)
//        {
//            [c performBlockAndWait:^{
//                NSError *er = nil;
//                success = [c save:&er];
//                //handle save success/failure
//            }];
//            c = c.parentContext;
//        }
//    }
    return [self saveContext];
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return error == nil;
}

- (void)showDBConsistencyProblem {
    @throw [NSException exceptionWithName:@"DBError" reason:@"DB inconsistency" userInfo:nil];
}

#pragma mark
#pragma - entity interface.
- (NSArray *)fetchEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sorterDescs:(NSArray *)sorters inSameContextAs:(NSManagedObject*)obj{
    NSManagedObjectContext* moContext = self.managedObjectContext;
    
    if (obj != nil) {
        moContext = obj.managedObjectContext;
    }
    NSFetchRequest* fetchReq = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchReq.predicate = predicate;
    fetchReq.sortDescriptors = sorters;
    
    NSError* err = nil;
    NSArray* items = [moContext executeFetchRequest:fetchReq error:&err];
    if (err != nil) {
        NSLog(@"Fetch entity failed: %@", err);
    }
    return items;
}

- (int)countEntity:(NSString *)entityName predicate:(NSPredicate *)predicate {
    NSFetchRequest* fetchReq = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchReq.predicate = predicate;
    
    NSError* err = nil;
    int count = (int)[self.managedObjectContext countForFetchRequest:fetchReq error:&err];
    if (err != nil) {
        NSLog(@"Fetch entity failed: %@", err);
    }
    return count;
}

- (void)deleteObject:(NSManagedObject *)obj{
    [self.managedObjectContext deleteObject:obj];
}

@end
