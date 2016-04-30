//
//  LYDateUtil.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYDateUtil.h"

@implementation LYDateUtil
+ (BOOL)isMoreThanFiveMinutes:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createDate = [formatter dateFromString:dateString];
    NSTimeInterval timeInter = [[NSDate date] timeIntervalSinceDate:createDate];
    if (timeInter <= 600) {
        return NO;
    }else{
        return YES;
    }
}
@end
