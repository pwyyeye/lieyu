//
//  LYCommonHttpTool.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCommonHttpTool.h"

@implementation LYCommonHttpTool
+ (LYCommonHttpTool *)shareInstance
{
    static LYCommonHttpTool * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
-(void)getTokenByqiNiuWithParams:(NSDictionary*)params
                           block:(void(^)(NSString* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_QINIUTOKEN baseURL:QINIU_SERVER  params:params success:^(id response) {
        
        NSString *token=response[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(token);
        });
    } failure:^(NSError *err) {
//        NSLog(err.domain);
    }];
}
// 获取IMtoken
-(void) getTokenByIMWithParams:(NSDictionary*)params
                         block:(void(^)(NSString* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_IMTOKEN baseURL:QINIU_SERVER  params:params success:^(id response) {
        
        NSString *token=response[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(token);
        });
    } failure:^(NSError *err) {
        //        NSLog(err.domain);
    }];

}
@end
