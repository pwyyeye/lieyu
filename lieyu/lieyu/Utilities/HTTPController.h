//
//  HTTPController.h
//  SemCC
//
//  Created by SEM on 15/5/20.
//  Copyright (c) 2015年 SEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MJExtension.h"
//#import "NSDictionary+JSONManage.h"
//#import "NSString+JSONCategories.h"
//#import "NSObject+JSONCategories.h"
#import "LYUserLoginViewController.h"
#import "QNUploadManager.h"
#import "QNUploadOption.h"

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

@protocol HTTPControllerProtocol <NSObject>
//定义一个方法，接收一个参数：AnyObject
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname;

@end
@interface HTTPController : NSObject
{
    NSString *urlPam;
    int typePam;
    NSString *urlName;
    NSDictionary *pamDic;
    UIAlertView *alertView;
    UIActivityIndicatorView *indicator;    
    
}
+(void)requestFileWihtUrl:(NSString*)url
                     baseURL:(NSString*)baseStr
                      params:(NSDictionary*)params block:(void (^)(id <AFMultipartFormData> formData))block
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure;

+(void) requestWihtMethod:(RequestMethodType)methodType url : (NSString *)url
                  baseURL:(NSString*)baseStr
                   params:(NSDictionary *)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
//七牛上传图片
+(void)uploadImageToQiuNiu:(UIImage *)image complete:(QNUpCompletionHandler)completionHandler;
//七牛上传文件
+(BOOL)uploadFileToQiuNiu:(NSString *)filePath complete:(QNUpCompletionHandler)completionHandler;

@property (nonatomic, assign) id<HTTPControllerProtocol> delegate ;
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withUrlName:(NSString *)name;
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withPam:(NSDictionary *)pam  withUrlName:(NSString *)name;
-(void)onSearch;
-(void)onSearchForPostJson;
-(void)onFileForPostJson:(NSString *)acceptableContentTypes constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block error:(NSError *__autoreleasing *)error;
-(void)onSyncPostJson;

@end
