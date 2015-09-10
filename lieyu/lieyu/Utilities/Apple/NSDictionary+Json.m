//
//  NSDictionary+Json.m
//  TimeCubeApp
//
//  Created by apple on 15/3/19.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)
- (NSString *)toJsonString
{
        NSDictionary *outDic = self;
        NSString *jsonString = nil;
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:outDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        } else
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        return jsonString;
}

- (BOOL)hasKey:(NSString *)key
{
    BOOL isFind = NO;
    for (NSString *item in self.allKeys)
    {
        if ([item isEqualToString:key]) {
            isFind = YES;
            break;
        }
    }
    return isFind;
}

- (id)s_ValueForKey:(NSString *)key
{
    BOOL hasKey = [self hasKey:key];
    if (hasKey) {
        return [self valueForKey:key];
    }
    return nil;
}

+ (id)loadfromJsonFile:(NSString *)strPath inStream:(NSInputStream **)inStream
{
    id dic = nil;
    NSError *er = nil;
    *inStream = [[NSInputStream alloc] initWithFileAtPath:strPath];
    [*inStream open];
    dic = [NSJSONSerialization JSONObjectWithStream:*inStream options:NSJSONReadingAllowFragments error:&er];
    return dic;
}

+ (id)loadfromJsonString:(NSString *)jsonString error:(NSError **)er
{
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    id obj  = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:er];
    return obj;
}


@end





