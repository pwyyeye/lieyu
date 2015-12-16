//
//  CoreDataUtil.m
//  lieyu
//
//  Created by pwy on 15/12/16.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCoreDataUtil.h"

@implementation LYCoreDataUtil

+ (LYCoreDataUtil *)shareInstance{
    static LYCoreDataUtil * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
//保存数据
- (BOOL)saveOrUpdateCoreData:(NSString *)entryName withParam:(NSDictionary *)dic andSearchPara:(NSDictionary *)searchDic{

    @try {
        //获取上下文
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =app.managedObjectContext;
        
        NSManagedObject *contactInfo;
        
        //判断是否需要查询
        if (searchDic!=nil && searchDic.count>0) {
            //查询数据中是否有该对象，若有则更新，否则新增
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == '%@'",[searchDic allKeys].firstObject,[searchDic objectForKey:[searchDic allKeys].firstObject]]];
            NSArray *array=[self getCoreData:entryName withPredicate:predicate];
            if (array!=nil&&array.count>0) {
                contactInfo=(NSManagedObject *)array.firstObject;
            }else{
                contactInfo= [NSEntityDescription insertNewObjectForEntityForName:entryName  inManagedObjectContext:context];
            }
            
        }else{
            contactInfo= [NSEntityDescription insertNewObjectForEntityForName:entryName  inManagedObjectContext:context];
        }
       
        //比对数据库字段是否正确－－暂不写
        
//        NSDictionary *table_attributes=CACHE_TABLE_ATTRIBUTES;
//        NSArray *attribute=[table_attributes objectForKey:entryName];
        
        NSArray *keys=[dic allKeys];
        for (NSString *key in keys) {
            [contactInfo setValue:[dic objectForKey:key] forKey:key];
        }
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }else{
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"----pass-insertCoreData error:%@---",exception);
        return YES;
    }
    @finally {
        
    }
    
    return YES;
}

- (NSArray *)getCoreData:(NSString *)entryName withPredicate:(NSPredicate *)predicate
{
    
    @try {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =app.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entryName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        if (predicate!=nil) {
            // NSPredicate*predicate = [NSPredicate predicateWithFormat:@"name == %@",@lisi];
            [fetchRequest setPredicate:predicate];
        }
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *teamObject in fetchedObjects) {
            
            NSString *teamName = [teamObject valueForKey:@"lyCacheKey"];
            NSDictionary *teamCity = [teamObject valueForKey:@"lyCacheValue"];
            NSLog(@"Team info : %@, %@\n", teamName, teamCity);
        }
        return fetchedObjects;
    }
    @catch (NSException *exception) {
        return nil;
    }
    
}

-(void)deleteCoreData:(NSString *)entryName withSearchPara:(NSDictionary *)searchDic{
    @try {
        //获取上下文
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =app.managedObjectContext;
   
        NSArray *array;
        //判断是否需要查询
        if (searchDic!=nil && searchDic.count>0) {
            //查询数据中是否有该对象，若有则更新，否则新增
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == '%@'",[searchDic allKeys].firstObject,[searchDic objectForKey:[searchDic allKeys].firstObject]]];
            array=[self getCoreData:entryName withPredicate:predicate];
            
        }else{
            array=[self getCoreData:entryName withPredicate:nil];
        }
        
        for (NSManagedObject *contactInfo in array) {
            [context deleteObject:contactInfo];
        }
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能删除：%@",[error localizedDescription]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"----pass-deleteCoreData error:%@---",exception);
    }
    

}
@end
