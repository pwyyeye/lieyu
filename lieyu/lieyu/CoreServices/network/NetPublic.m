//
//  @implementation LYErrorMessage   @end ZKNetPublic.m
//  ZKPublic
//
//  Created by apple on 14/12/11.
//
//

#import <Foundation/Foundation.h>
#import "NetPublic.h"

NSString *gSessionId = nil;

@implementation LYRestfulResponseBase


@end

@implementation LYRestfulResponse

@end

NSString *getSysLang()
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@implementation LYErrorMessage

+ (LYErrorMessage *)instanceWithDictionary:(NSDictionary *)dic
{
    LYErrorMessage * erMsg = [[LYErrorMessage alloc] init];
    erMsg.mErrorCode = [dic stringForKeySafe:@"errorcode"];
    erMsg.mErrorMessage = [dic stringForKeySafe:@"message"];
    if ([erMsg.mErrorCode isEqualToString:SUCCESS_CODE]) {
        erMsg.state = Req_Success;
    }
    else
    {
        erMsg.state = Req_Failed;
    }
    return erMsg;
}

+ (LYErrorMessage *)instanceWithError:(NSError *)er
{
    LYErrorMessage * erMsg = [[LYErrorMessage alloc] init];
    erMsg.mErrorMessage = er.description;
    erMsg.mErrorCode = er.domain;
    
    return erMsg;
}

@end



