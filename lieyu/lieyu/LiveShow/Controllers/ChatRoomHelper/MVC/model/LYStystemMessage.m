//
//  LYStystemMessage.m
//  lieyu
//
//  Created by 狼族 on 16/9/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYStystemMessage.h"

@implementation LYStystemMessage
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

- (void)decodeWithData:(NSData *)data {
    __autoreleasing NSError *__error = nil;
    if (!data) {
        return;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&__error];
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:dictionary];
    if (!__error && dict) {
        NSDictionary *userinfoDic = [dict objectForKey:@"user"];
        [self decodeUserInfo:userinfoDic];
    } else {
        self.rawJSONData = data;
    }
}

- (NSData *)encode {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dict setObject:__dic forKey:@"user"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return jsonData;
}

+ (NSString *)getObjectName {
    return RCStystemMessageIdentifier;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [super dealloc];
}
#endif //__has_feature(objc_arc)

@end
