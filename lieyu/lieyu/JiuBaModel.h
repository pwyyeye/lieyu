//
//  JiuBaModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiuBaModel : NSObject
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * quYu;
@property (nonatomic, retain) NSString * img;
@property(nonatomic,copy)NSString * name_en;
@property NSInteger sectionNumber;
@property BOOL rowSelected;
@end
