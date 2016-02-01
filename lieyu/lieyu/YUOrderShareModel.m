//
//  YUOrderShareModel.m
//  lieyu
//
//  Created by 狼族 on 16/2/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "YUOrderShareModel.h"
#import "MJExtension.h"
#import "YUOrderInfo.h"

@implementation YUOrderShareModel
+ (NSDictionary *)objectClassInArray{
    return @{@"orderInfo":@"YUOrderInfo"};
}
@end
