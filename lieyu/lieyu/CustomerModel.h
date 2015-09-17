//
//  CustomerModel.h
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * name_en;
@property(nonatomic,copy)NSString * phone;
@property NSInteger sectionNumber;
@property BOOL rowSelected;
@end
