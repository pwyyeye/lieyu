//
//  AnnouncementModel.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementModel : NSObject

@property(nonatomic,strong)NSNumber *barid;
@property(nonatomic,copy)NSString *barname;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createdate;
@property(nonatomic,copy)NSNumber *id;
@property(nonatomic,copy)NSString *modifydate;
@property(nonatomic,copy)NSString *title;

@end
