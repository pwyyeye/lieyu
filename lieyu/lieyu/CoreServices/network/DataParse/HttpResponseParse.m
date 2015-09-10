//
//  ZKDataProcess.m
//  
//
//  Created by apple on 15/3/18.
//
//

#import "HttpResponseParse.h"
#import "NetPublic.h"
#import "NSDictionary+Json.h"
@implementation HttpResponseParse
+(void)praseData:( NSDictionary *)json erMsg:(ZKErrorMessage **)erMsg data:(NSDictionary **)data
{
    NSError * error = nil;
    NSDictionary *tInfoDic = json;
    
    *erMsg = [[ZKErrorMessage alloc] init];
    ZKErrorMessage *eg = *erMsg;
    if (!error)
    {
        /*********---------
         服务器返回格式未知
         *****************/
        eg.mErrorCode = [tInfoDic objectForKey:keyCode];
        eg.mErrorMessage = [tInfoDic objectForKey:keyMessage];

        if ([tInfoDic hasKey:keySessionId])
        {
            gSessionId = [tInfoDic objectForKey:keySessionId];
        }

        if ([eg.mErrorCode isEqualToString:SUCCESS_CODE] || [tInfoDic hasKey:keyCode] == NO)
        {
            eg.state = Req_Success;
        }
        else
        {
            eg.state = Req_Failed;
        }

           *data = [tInfoDic s_ValueForKey:keyData];
            if ([*data isKindOfClass:[NSNull class]])
            {
                *data = nil;
            }
    }
    else
    {
        eg.mErrorType = ErrorMessageParsing;
        eg.mErrorCode = kErrorMessageParsing;
        eg.state = Req_Failed;
        eg.mErrorMessage = NSLocalizedString(String_JsonDataPrase_Error, nil);
        if ([tInfoDic hasKey:keyData])
        {
            *data = nil;
        }
    }
}

@end




