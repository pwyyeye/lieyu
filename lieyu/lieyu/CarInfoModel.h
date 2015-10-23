//
//  CarInfoModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiuBaModel.h"
@interface CarInfoModel : NSObject
@property(nonatomic,assign)int applyStatus;
@property(nonatomic,retain)JiuBaModel * barinfo;
@property(nonatomic,retain)NSArray * cartlist;
@end
