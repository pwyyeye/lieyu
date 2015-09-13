//
//  @implementation LYErrorMessage   @end ZKNetPublic.m
//  ZKPublic
//
//  Created by apple on 14/12/11.
//
//

#import <Foundation/Foundation.h>
#import "NetPublic.h"
#import "RestKit.h"
NSString *gSessionId = nil;

@implementation LYRestfulResponseBase
+(RKObjectMapping *)mapping
{
    return RestKitMapWithDic([LYRestfulResponseBase class],
                                @{
                                  @"code" : @"code",
                                  @"message" : @"message",
                                  @"sessionId":@"sessionId"
                                });
}

@end

@implementation LYRestfulResponse
+(RKObjectMapping *)mapping
{
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[LYRestfulResponse class]];
    [statusMapping addAttributeMappingsFromDictionary:@{
                                                            @"code" : @"code",
                                                            @"message" : @"message",
                                                            @"sessionId":@"sessionId",
                                                            @"payload":@"payload"
                                                        }];
    return statusMapping;
}
@end

NSString *getSysLang()
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@implementation LYErrorMessage


@end



