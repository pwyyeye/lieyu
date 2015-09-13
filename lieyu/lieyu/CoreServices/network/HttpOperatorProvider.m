//
//  ZKNetworkOperator.m
//  ZKPublic
////  Created by apple on 14/12/10.
//
//
#import "LYDataStore.h"

#import "HttpOperatorProvider.h"
#import "HttpResponseParse.h"
#include "RKCoreData.h"
#import "RestKit.h"
#import "RKObjectManager.h"
#import "NSString+Expend.h"

@interface HttpOperatorProvider()
{

}

@property(nonatomic,strong)RKObjectManager *client;

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
        _client = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:url]];
        [_client setRequestSerializationMIMEType:@"application/json"];
        [self setupCoreData];
        handle(_client);
    }
    return self;
}

- (RKObjectManager *)client
{
    return _client;
}

- (void)removeRespnseDescriptor:(RKResponseDescriptor *)obj
{
    [_client removeResponseDescriptor:obj];
}

- (void)setupCoreData
{
    _client.managedObjectStore = [LYDataStore currentInstance].managedObjectStore;
}

-(NSString *)getDataWithApi:(NSString *)urlPrefix api:(NSString *)api jsonParams:(NSDictionary *)jsonParams retHandle:(bNetReqResponse)handle
{
    LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
    erMsg.mErrorCode = kErrorMessageUnknow;
    erMsg.mErrorMessage = nil;
    erMsg.mErrorType = ErrorMessageNoError;
    erMsg.state = Req_Sending;
    handle(erMsg,nil);

    __weak RKObjectManager * weakClient = _client;
    [_client getObjectsAtPath:api parameters:jsonParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        NSDictionary *dic = mappingResult.dictionary;
        LYRestfulResponse *resHead = [dic valueForKey:@""];
        LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
        erMsg.state = Req_Success;

        NSObject *data = nil;
        
        [HttpResponseParse praseData:[resHead keyValues] erMsg:&erMsg data:&data];
        handle(erMsg,mappingResult.dictionary);

        if ([weakClient.managedObjectStore.mainQueueManagedObjectContext hasChanges])
        {

            NSManagedObjectContext* c = weakClient.managedObjectStore.mainQueueManagedObjectContext;
            __block BOOL success = YES;
            while (c && success)
            {
                [c performBlockAndWait:^{
                    NSError *er = nil;
                    success = [c save:&er];
                    //handle save success/failure
                }];
                c = c.parentContext;
            }
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
        if (error.code == -1001)
        {
            erMsg.mErrorCode = kErrorMessageNetwork;
            erMsg.mErrorType = ErrorMessageNetwork;
        }
        erMsg.state = Req_Failed;
        erMsg.mErrorMessage = [NSString stringWithFormat:@"%@",error];
        handle(erMsg,nil);
    }];
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
    strHash = [strHash stringByAppendingFormat:@"%@/%@/%@",_client.baseURL,api,jsonParams] ;
    strHash = strHash.md5Hash;
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

    __weak RKObjectManager * weakClient = _client;
    [_client postObject:nil path:api parameters:jsonParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        NSDictionary *dic = mappingResult.dictionary;
        LYRestfulResponse *resHead = [dic valueForKey:@""];
        LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
        erMsg.state = Req_Success;
        NSObject *data = nil;
        [HttpResponseParse praseData:[resHead keyValues] erMsg:&erMsg data:&data];

        handle(erMsg,mappingResult.dictionary);

        if ([weakClient.managedObjectStore.mainQueueManagedObjectContext hasChanges])
        {

            NSManagedObjectContext* c = weakClient.managedObjectStore.mainQueueManagedObjectContext;
            __block BOOL success = YES;
            while (c && success)
            {
                [c performBlockAndWait:^{
                    NSError *er = nil;
                    success = [c save:&er];
                    //handle save success/failure
                }];
                c = c.parentContext;
            }
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        LYErrorMessage *erMsg = [[LYErrorMessage alloc] init];
        if (error.code == -1001)
        {
            erMsg.mErrorCode = kErrorMessageNetwork;
            erMsg.mErrorType = ErrorMessageNetwork;
        }
        erMsg.state = Req_Failed;
        erMsg.mErrorMessage = [NSString stringWithFormat:@"%@",error];
        handle(erMsg,nil);
    }];
    return [self hashRequestApi:api jsonParams:jsonParams];
}

- (void)addResponseDescriptorsFromArray:(NSArray *)ary
{
    [self.client addResponseDescriptorsFromArray:ary];
}

- (void)removeDescriptors:(NSArray *)ary
{
    for (RKResponseDescriptor *item in ary)
    {
        [self.client removeResponseDescriptor:item];
    }
}

- (void)cancelAllRequest
{
    [_client.operationQueue cancelAllOperations];
}


@end













































