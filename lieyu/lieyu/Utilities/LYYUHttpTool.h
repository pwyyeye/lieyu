//
//  LYYUHttpTool.h
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYYUHttpTool : NSObject
//获取娱模版主页数据
+ (void)yuGetDataOrderShareWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte;
@end
