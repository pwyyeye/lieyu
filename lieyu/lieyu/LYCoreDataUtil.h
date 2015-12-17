//
//  CoreDataUtil.h
//  lieyu
//
//  Created by pwy on 15/12/16.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCacheDefined.h"
@interface LYCoreDataUtil : NSObject
//获取单例
+ (LYCoreDataUtil *)shareInstance;

//保存
- (BOOL)saveOrUpdateCoreData:(NSString *)entryName withParam:(NSDictionary *)dic andSearchPara:(NSDictionary *)searchDic;
//自定义条件查询
- (NSArray *)getCoreData:(NSString *)entryName withPredicate:(NSPredicate *)predicate;

//单条件查询
- (NSArray *)getCoreData:(NSString *)entryName andSearchPara:(NSDictionary *)searchDic;

//删除
-(void)deleteCoreData:(NSString *)entryName withSearchPara:(NSDictionary *)searchDic;

//删除sqllite数据库
-(void)deleteLocalSQLLite;

@end