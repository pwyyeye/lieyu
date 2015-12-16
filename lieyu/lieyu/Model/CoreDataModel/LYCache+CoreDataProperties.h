//
//  LYCache+CoreDataProperties.h
//  lieyu
//
//  Created by pwy on 15/12/16.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LYCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYCache (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *lyCacheKey;
@property (nullable, nonatomic, retain) id lyCacheValue;
@property (nullable, nonatomic, retain) NSDate *createDate;

@end

NS_ASSUME_NONNULL_END
