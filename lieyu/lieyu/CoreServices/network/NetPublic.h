//
//  NetPublic.h
//  ZKPublic
//
//  Created by apple on 14/12/10.
//
//

#ifndef ZKPublic_NetPublic_h
#define ZKPublic_NetPublic_h

#import "MJExtension.h"
//错误信息
#define ERROR_Message      @"ERROR_Message"
#define SUCCESS_CODE       @"1"
//错误信息类型

typedef NS_ENUM(NSUInteger, ErrorMessageType)
{
    ErrorMessageNoError = 0,
    ErrorMessageNetwork=1,  //网络错误(AFNetwork错误类型)
    ErrorMessageResponse,   //服务端返回错误消息(根据服务返回的信息)
    ErrorMessageParsing,    //解析错误
    ErrorMessageApi,        //API错误
};

#define  kErrorMessageUnknow   @"-1"
#define  kErrorMessageResponse @"-2"
#define  kErrorMessageParsing  @"-3"
#define  ErrorMessageApi       @"-4"
#define  kErrorMessageNetwork  @"-5" 

//数据解析错误类型
typedef NS_ENUM(NSUInteger, ParsingErrorType)
{
    ParsingError_JSON=1,//json解析错误
    ParsingError_XML,//xml解析错误
};

typedef NS_ENUM(NSUInteger, ReqState)
{
    Req_Sending = 2,
    Req_Failed  = 0,
    Req_Success = 1
};

@interface LYErrorMessage : NSObject

//错误信息
@property(nonatomic,retain)NSString *mErrorMessage;
//错误code
@property NSString *mErrorCode;
//错误类型
@property ErrorMessageType mErrorType;

@property ReqState state;

+ (LYErrorMessage *)instanceWithDictionary:(NSDictionary *)dic;
+ (LYErrorMessage *)instanceWithError:(NSError *)er;

@end


@interface LYRestfulResponseBase:NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *sessionId;

@end

@interface LYRestfulResponse : LYRestfulResponseBase

@property(nonatomic,copy)NSDictionary *payload;

@end


#define keyCode     @"errorcode"
#define keyMessage  @"message"
#define keyData     @"data"

#define keySessionId @"sessionId"

/***********************
 
 block名字:bNetreqResponse
 出参erMsg:网络请求返回的结构描述
 出参data :处理返回后的数据集，可以是模型，也可以是基础数据类型

************************/

typedef void(^bNetReqResponse)(LYErrorMessage *erMsg,id data);

#define String_JsonDataPrase_Error  @"json数据解析失败了"

extern NSString *gSessionId;
extern NSString *getSysLang();
#define  Log(Api,error,value,...) \
    if([value isKindOfClass:[JSONModel class]])\
    {                  \
        DEBUG_Log(@" Api-%@ -error = [%@,mErrorMessage=%@],value = [%@]",Api,[error toDictionary],error.mErrorMessage,[value toDictionary]);\
    }                  \
    else               \
    {                       \
        DEBUG_Log(@" Api-%@ -error = [%@,mErrorMessage=%@],value = [%@]",Api,[error toDictionary],error.mErrorMessage,value);\
    }
#endif

























