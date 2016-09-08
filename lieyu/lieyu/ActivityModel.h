//
//  ActivityModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BarActivityList;

@interface ActivityModel : NSObject

@property (nonatomic, strong) BarActivityList *barActivity;
@property (nonatomic, strong) NSString *activityType;

@end
