//
//  LYAdviserItem.m
//  lieyu
//
//  Created by 狼族 on 16/6/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAdviserItem.h"
#import "LYAdviserComment.h"
#import "MJExtension.h"

@implementation LYAdviserItem

+ (void)load{
    [LYAdviserItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"commentList":@"LYAdviserComment"};
    }];
}


@end
