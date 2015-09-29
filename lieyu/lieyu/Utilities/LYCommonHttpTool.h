//
//  LYCommonHttpTool.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSUrl.h"
#import "HTTPController.h"
@interface LYCommonHttpTool : NSObject
+ (LYCommonHttpTool *)shareInstance;
// 获取7牛token
-(void) getTokenByqiNiuWithParams:(NSDictionary*)params
                            block:(void(^)(NSString* result)) block;
@end
