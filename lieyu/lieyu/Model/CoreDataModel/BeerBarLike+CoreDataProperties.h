//
//  BeerBarLike+CoreDataProperties.h
//  lieyu
//
//  Created by 狼族 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeerBarLike.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeerBarLike (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isLike;
@property (nullable, nonatomic, retain) NSNumber *barid;
@property (nullable, nonatomic, retain) NSNumber *userid;

@end

NS_ASSUME_NONNULL_END
