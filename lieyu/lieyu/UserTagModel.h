//
//  UserTagModel.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTagModel : NSObject

@property(assign,nonatomic) NSInteger id;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *tagname;
@property(assign,nonatomic) NSInteger tagid;
@property(assign,nonatomic) NSInteger orders;

@end
