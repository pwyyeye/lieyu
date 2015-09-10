//
//  User+Utils.h
//  timecube
//
//  Created by jolly on 15/8/3.
//  Copyright (c) 2015年 Steven Mai. All rights reserved.
//

#import "User.h"
#import "RestKitMapping.h"

@interface User (Utils)<RestKitMapping>

+ (User *)initFromPushMsgItem:(NSDictionary *)userInfo;

+ (BOOL)insertItem:(User *)user;
+ (BOOL)updateItem:(User *)user;
+ (BOOL)deleteItem:(NSString *)account;
+ (User*)selectItem:(NSString *)account;

@end
