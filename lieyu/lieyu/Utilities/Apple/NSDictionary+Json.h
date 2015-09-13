//
//  NSDictionary+Json.h
//  LYAppApp
//
//  Created by apple on 15/3/19.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

- (NSString *)toJsonString;
- (BOOL)hasKey:(NSString *)key;
- (id)s_ValueForKey:(NSString *)key;
+ (id)loadfromJsonFile:(NSString *)strPath inStream:(NSInputStream **)inStream;
+ (id)loadfromJsonString:(NSString *)jsonString error:(NSError **)er;

@end
