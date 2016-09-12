//
//  LYGiftMessage.m
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGiftMessage.h"

@implementation LYGiftMessage

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
        self.type = [dict objectForKey:@"type"];
        NSDictionary *userinfoDic = [dict objectForKey:@"user"];
        [self decodeUserInfo:userinfoDic];
        NSDictionary *giftDic = [dict objectForKey:@"gift"];
        [self decodeUserInfo:giftDic];
    } else {
        self.rawJSONData = data;
    }
}

- (NSData *)encode {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.type) {
        [dict setObject:self.type forKey:@"type"];
    }
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
    if (self.gift) {
        NSMutableDictionary *_dict = [[NSMutableDictionary alloc] init];
        if (self.gift.giftId) {
            [_dict setObject:self.gift.giftId forKeyedSubscript:@"giftId"];
        }
        if (self.gift.giftUrl) {
            [_dict setObject:self.gift.giftUrl forKeyedSubscript:@"giftUrl"];
        }
        if (self.gift.giftLocalUrl) {
            [_dict setObject:self.gift.giftLocalUrl forKeyedSubscript:@"giftLocalUrl"];
        }
        if (self.gift.giftId) {
            [_dict setObject:self.gift.giftId forKeyedSubscript:@"giftId"];
        }
        [dict setObject:_dict forKey:@"gift"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return jsonData;
}

+ (NSString *)getObjectName {
    return RCGiftMessageIdentifier;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [super dealloc];
}
#endif //__has_feature(objc_arc)


@end
