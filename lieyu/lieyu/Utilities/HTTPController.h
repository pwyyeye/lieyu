//
//  HTTPController.h
//  SemCC
//
//  Created by SEM on 15/5/20.
//  Copyright (c) 2015年 SEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "NSDictionary+JSONManage.h"
//#import "NSString+JSONCategories.h"
//#import "NSObject+JSONCategories.h"
typedef enum {
    GETURL,
    POSTURL
}urltype;
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

@property (nonatomic, assign) id<HTTPControllerProtocol> delegate ;
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withUrlName:(NSString *)name;
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withPam:(NSDictionary *)pam  withUrlName:(NSString *)name;
-(void)onSearch;
-(void)onSearchForPostJson;
-(void)onFileForPostJson:(NSString *)acceptableContentTypes constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block error:(NSError *__autoreleasing *)error;
-(void)onSyncPostJson;

@end
