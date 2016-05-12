//
//  LYDateUtil.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYDateUtil : NSObject
#pragma mark - 参数事件距离当前是否大于（可更改）10分钟
+ (BOOL)isMoreThanFiveMinutes:(NSString *)dateString;
@end
