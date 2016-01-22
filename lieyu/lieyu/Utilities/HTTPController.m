//
//  HTTPController.m
//  SemCC
//
//  Created by SEM on 15/5/20.
//  Copyright (c) 2015年 SEM. All rights reserved.
//

#import "HTTPController.h"
#import "AppDelegate.h"
#import "LYUserLoginViewController.h"

@implementation HTTPController
+ (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                  baseURL:(NSString*)baseStr
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    //添加userid
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![MyUtil isEmptyString:app.s_app_id] && ![url isEqualToString:LY_DL]) {
        url = [NSString stringWithFormat:@"%@&SEM_LOGIN_TOKEN=%@",url,app.s_app_id];
    }
 
    NSURL* baseURL = [NSURL URLWithString:baseStr];
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@[@"text/html",@"text/json"], nil];
#ifdef ContentType
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [mgr GET:url parameters:params
             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                 if (success) {
                     NSString *code = [NSString stringWithFormat:@"%@",responseObj[@"errorcode"]];
                     if ([code isEqualToString:@"-1"]) {
                         LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
                         UINavigationController * nav = (UINavigationController *)app.window.rootViewController;
                         [nav pushViewController:login animated:YES];
                         [app stopLoading];
                         return;
                     }
                     
                     success(responseObj);
                 }
             } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 [app stopLoading];
                 if([error code]==-1009){
                     [MyUtil showCleanMessage:@"无网络连接！"];
                 }
                 if (failure) {
                     failure(error);
                 }
             }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:url parameters:params
              success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                  if (success) {
                      NSString *code = [NSString stringWithFormat:@"%@",responseObj[@"errorcode"]];
                      if ([code isEqualToString:@"-1"]) {
                          LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
                          UINavigationController * nav = (UINavigationController *)app.window.rootViewController;
                          [nav pushViewController:login animated:YES];
                          [app stopLoading];
                          return;
                      }
                      success(responseObj);
                  }
              } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                  [app stopLoading];
                  if([error code]==-1009){
                      [MyUtil showCleanMessage:@"无网络连接！"];
                  }
                  if (failure) {
                      failure(error);
                  }
              }];
        }
            break;
        default:
            break;
    }
}
//文件上传
+ (void)requestFileWihtUrl:(NSString*)url
                  baseURL:(NSString*)baseStr
                       params:(NSDictionary*)params block:(void (^)(id <AFMultipartFormData> formData))block
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    //添加userid
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (![MyUtil isEmptyString:app.s_app_id]) {
        url = [NSString stringWithFormat:@"%@&SEM_LOGIN_TOKEN=%@",url,app.s_app_id];
    }
    NSURL* baseURL = [NSURL URLWithString:baseStr];
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
#ifdef ContentType
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:url parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"errorcode"]];
            if ([code isEqualToString:@"-1"]) {
                LYUserLoginViewController *login=[[LYUserLoginViewController alloc] initWithNibName:@"LYUserLoginViewController" bundle:nil];
                UINavigationController * nav = (UINavigationController *)app.window.rootViewController;
                [nav pushViewController:login animated:YES];
                [app stopLoading];
                return;
            }
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
    
    
    
                    
    
}
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withUrlName:(NSString *)name{
    self = [super init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (![MyUtil isEmptyString:app.s_app_id]) {
        urlPam = [NSString stringWithFormat:@"%@&s_app_id=%@",urlStr,app.s_app_id];
    }else{
        urlPam=urlStr;
    }
    typePam = type;
    urlName = name;
  
    return self;
}
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withPam:(NSDictionary *)pam  withUrlName:(NSString *)name {
    self = [super init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![MyUtil isEmptyString:app.s_app_id]) {
        urlPam = [NSString stringWithFormat:@"%@&s_app_id=%@",urlStr,app.s_app_id];
    }else{
        urlPam=urlStr;
    }
    
    typePam = type;
    urlName = name;
    pamDic = pam;

    return self;
}


-(void)onSearch{
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    urlPam = [urlPam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//     [self showToast:@"查询中....."];
    [manager GET:urlPam parameters:pamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([urlName isEqual:@"login"]) {
            NSLog(@"JSON: %@", responseObject);

        }
        //判断是否登录如果未登录 则进入登录页面
        NSNumber *status=[responseObject objectForKey:@"status"];
        NSLog(@"----pass-httprequest header%@---",operation.request);
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if([status integerValue] == -1){
            
//            UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            [app stopLoading];
//        
//            [app.navigationController pushViewController:vc animated:YES];
//            [app.navigationController presentViewController:vc animated:YES completion:^{
//                
//            }];
        }else if([status integerValue] == 0){
            id array=[responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                ShowMessage([array objectAtIndex:0]);
            }
            
//            [app stopLoading];
        }else{
            [self.delegate didRecieveResults:responseObject withName:urlName];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        [app stopLoading];
        
        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
//        [indicator stopAnimating];
//        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)onSearchForPostJson{
     //[self showToast:@"查询中....."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    NSDictionary *parameters = pamDic;
    //你的接口地址
    NSString *url=urlPam;
    //发送请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
        //[indicator stopAnimating];
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"----pass-httprequest header%@---",operation.request);
        //判断是否登录如果未登录 则进入登录页面
        NSNumber *status=[responseObject objectForKey:@"status"];

        if([status integerValue] == -1){
//            
//            UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            [app stopLoading];
            
//            [app.navigationController pushViewController:vc animated:YES];
        }else if([status integerValue] == 0){
            id array=[responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                 ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                  ShowMessage([array objectAtIndex:0]);
            }
            
//            [app stopLoading];
           
        }else{
            [self.delegate didRecieveResults:responseObject withName:urlName];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
        //[indicator stopAnimating];
        
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        [app stopLoading];

        NSLog(@"Error: %@", error);
        NSLog ( @"operation: %@" , operation. responseString );
    }];
}

//上传文件 示例：
//   [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//   [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_1" fileName:@"idcard_1.png" mimeType:@"image/png"];
//   [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_2" fileName:@"idcard_2.png" mimeType:@"image/png"];
//   } error:nil];

//默认acceptableContentTypes 添加@"text/html"
-(void)onFileForPostJson:(NSString *)acceptableContentTypes constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                   error:(NSError *__autoreleasing *)error
{
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    AFJSONResponseSerializer *jsonResphone=[AFJSONResponseSerializer serializer];
    if (acceptableContentTypes==nil) {
        jsonResphone.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    }else{
        jsonResphone.acceptableContentTypes=[NSSet setWithObject:acceptableContentTypes];
    }
    
    manager.responseSerializer =jsonResphone;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableURLRequest *mutableUrlRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlPam parameters:pamDic constructingBodyWithBlock:block error:error];

    
    NSDictionary *dic =[mutableUrlRequest allHTTPHeaderFields];
    
    NSLog(@"dic=================%@",dic);
     NSLog(@"mutableUrlRequest=================%@",mutableUrlRequest);
    
    NSData *data= [mutableUrlRequest HTTPBody];
    
    NSLog(@"-----%@",data);
//    NSMutableURLRequest *mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlPam parameters:pamDic constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block error:nil];
    
    NSProgress * progress=nil;
    NSURLSessionUploadTask *uploadTask=[manager uploadTaskWithStreamedRequest:mutableUrlRequest progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"----pass-pass%@---",responseObject);
        if (error) {
            NSLog(@"%@",error);
        }else{
            
            NSLog(@"%@",@"success!");
            [self.delegate didRecieveResults:responseObject withName:urlName];
            //获取本地缓冲图片
//            NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"temp.png"];
//            UIImage *tempImage=[[UIImage alloc] initWithContentsOfFile:fullPath];
            
        }
    }];
    
    
    
    [uploadTask resume];

}

//同步请求 无法100％同步 相对同步
-(void)onSyncPostJson{
    
    AFHTTPRequestSerializer *requestSerializer=[AFHTTPRequestSerializer serializer];
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:urlPam parameters:pamDic error:nil];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    @try {
        [requestOperation setResponseSerializer:responseSerializer];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        NSDictionary *responseObject=[requestOperation responseObject];
        NSNumber *status=[responseObject objectForKey:@"status"];
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if([status integerValue] == -1){
//            
//            UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            [app stopLoading];
//            
//            [app.navigationController pushViewController:vc animated:YES];
        }else if([status integerValue] == 0){
            id array=[responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                ShowMessage([array objectAtIndex:0]);
            }
            
//            [app stopLoading];
            
        }else{
            [self.delegate didRecieveResults:responseObject withName:urlName];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"----pass-onSyncPostJson%@---",exception);
    }
    @finally {
        
    }

}

//七牛上传图片
+(void)uploadImageToQiuNiu:(UIImage *)image complete:(QNUpCompletionHandler)completionHandler{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.qiniu_token){
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        QNUploadOption *op=[[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
        
        NSString *fileName = [NSString stringWithFormat:@"lieyu_ios_%@_%@.jpg",[MyUtil getNumberFormatDate:[NSDate date]], [MyUtil randomStringWithLength:8]];
        
        //上传代码
        //图片压缩到30%
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        
        // fileName=@"ZSKC2015-09-30_22:45:04_OoIkxuCe.jpg";
        [upManager putData:data key:fileName token:app.qiniu_token complete:(QNUpCompletionHandler)completionHandler  option:op];
        
        
    }
}
//七牛上传图片
+(void)uploadImageToQiuNiu:(UIImage *)image withDegree:(CGFloat)degree complete:(QNUpCompletionHandler)completionHandler{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.qiniu_token){
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        QNUploadOption *op=[[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
        
        NSString *fileName = [NSString stringWithFormat:@"lieyu_ios_%@_%@.jpg",[MyUtil getNumberFormatDate:[NSDate date]], [MyUtil randomStringWithLength:8]];
        
        //上传代码
        //图片压缩到30%
        NSData *data = UIImageJPEGRepresentation(image, degree);
        
        // fileName=@"ZSKC2015-09-30_22:45:04_OoIkxuCe.jpg";
        [upManager putData:data key:fileName token:app.qiniu_token complete:(QNUpCompletionHandler)completionHandler  option:op];
        
        
    }
}
//七牛上传文件
+(BOOL)uploadFileToQiuNiu:(NSString *)filePath  complete:(QNUpCompletionHandler)completionHandler{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.qiniu_media_token){
        @try {
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *op=[[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
            
            NSString *fileName = [NSString stringWithFormat:@"lieyu_ios_%@_%@%@",[MyUtil getNumberFormatDate:[NSDate date]], [MyUtil randomStringWithLength:8],[filePath lastPathComponent]];
            
            //上传代码
            
            NSData *data =[NSData dataWithContentsOfFile:filePath];
  
            [upManager putData:data key:fileName token:app.qiniu_media_token complete:(QNUpCompletionHandler)completionHandler  option:op];
            return YES;
        }
        @catch (NSException *exception) {
            NSLog(@"----pass-uploadFileToQiuNiu error >%@---",exception);
            return NO;
        }
        @finally {
            
        }
        
    }
}

//弹出消息框来显示消息
void ShowMessage(NSString* message)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
