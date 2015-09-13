//
//  ZKNetworkOperator.h
//  ZKPublic
//
//  Created by apple on 14/12/10.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetPublic.h"
#import "RestKit.h"

typedef void(^init)(RKObjectManager *obj);

@interface HttpOperatorProvider : NSObject

- (id)  initWithBaseUrl:(NSString *)url init:(init)handle;

-(void)removeRespnseDescriptor:(RKResponseDescriptor *)obj;


//<---处理get请求后返回的结果
- (NSString *)getDataWithApi:(NSString *)urlPrefix api:(NSString *)api jsonParams:(NSDictionary *)jsonParams retHandle:(bNetReqResponse)handle;

//<---处理post请求返回的结果
- (NSString *)postDataWithApi:(NSString *)urlPrefix  api:(NSString *)api jsonParams:(NSDictionary *)jsonParams retHandle:(bNetReqResponse)handle;

//----部分接口没有经过映射通过 这个接口调用获得返回内容
- (LYRestfulResponse *)getShortResponse:(NSDictionary *)dic;
- (NSString *)hashRequestApi:(NSString *)api jsonParams:(NSDictionary *)jsonParams;
/**
 *  上传文件
 *
 *  @param filePath 本地文件路径
 *  @param param    入参
 *  @param url      远程服务器url
 *  @param fileType 如@"image/jpeg"
 *  @param fileName 远程文件名
 *
 *  @return 返回操作对象
 */
//- (AFHTTPRequestOperation *)uploadFile:(NSString *)filePath param:(id)param remoteUrl:(NSString *)url fileName:(NSString *)fileName fileType:(NSString *)fileType;

- (void)cancelAllRequest;
- (RKObjectManager *)client;

/**
 *  适配模型映射
 *
 *  @param ary ary description
 */

- (void)addResponseDescriptorsFromArray:(NSArray *)ary;
- (void)removeDescriptors:(NSArray *)ary;


@end





