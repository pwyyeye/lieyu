//
//  YUOrderShareModel.h
//  lieyu
//
//  Created by 狼族 on 16/2/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YUOrderInfo;

@interface YUOrderShareModel : NSObject
@property (nonatomic,copy) NSString *allowSex;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,strong) YUOrderInfo *orderInfo;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *shareDate;
@property (nonatomic,copy) NSString *shareType;
@property (nonatomic,copy) NSString *shareUsers;
@end
