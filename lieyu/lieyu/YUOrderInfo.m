//
//  YUOrderInfo.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "YUOrderInfo.h"
#import "MJExtension.h"
#import "JiuBaModel.h"
#import "YUPinkerListModel.h"
#import "YUPinkerinfo.h"

@implementation YUOrderInfo
+ (NSDictionary *)objectClassInArray{
    return @{@"barinfo":@"JiuBaModel",@"pinkerList":@"YUPinkerListModel",@"pinkerinfo":@"YUPinkerinfo"
             };
}
@end
