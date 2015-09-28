//
//  ZKNetworkOperator.m
//  ZKPublic
////  Created by apple on 14/12/10.
//
//
#import "LYDataStore.h"

#import "HttpOperatorProvider.h"
#import "HttpResponseParse.h"
#import "NSString+Expend.h"

@interface HttpOperatorProvider()
{

}


@end

@implementation HttpOperatorProvider

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}

- (id)  initWithBaseUrl:(NSString *)url init:(init)handle
{
    if (self = [super init])
    {

    }
    return self;
}




-(NSString *)getDataWithApi:(NSString *)urlPrefix api:(NSString *)api jsonParams:(NSDictionary *)jsonParams retHandle:(bNetReqResponse)handle
{
    LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
    erMsg.mErrorCode = kErrorMessageUnknow;
    erMsg.mErrorMessage = nil;
    erMsg.mErrorType = ErrorMessageNoError;
    erMsg.state = Req_Sending;
    handle(erMsg,nil);

    return [self hashRequestApi:api jsonParams:jsonParams];
}
- (LYRestfulResponse *)getShortResponse:(NSDictionary *)dic
{
    return [dic valueForKey:@""];
}

//<---处理post请求返回的结果

- (NSString *)hashRequestApi:(NSString *)api jsonParams:(NSDictionary *)jsonParams
{
    NSString * strHash = @"";

    return strHash;
}

-(NSString *)postDataWithApi:(NSString *)urlPrefix  api:(NSString *)api jsonParams:(NSDictionary *)jsonParams retHandle:(bNetReqResponse)handle
{
    LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
    erMsg.mErrorCode = kErrorMessageUnknow;
    erMsg.mErrorMessage = nil;
    erMsg.mErrorType = ErrorMessageNoError;
    erMsg.state = Req_Sending;
    handle(erMsg,nil);

    return [self hashRequestApi:api jsonParams:jsonParams];
}



@end













































