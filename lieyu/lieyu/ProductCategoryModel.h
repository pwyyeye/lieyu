//
//  ProductCategoryModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/2.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryModel : NSObject
//"grade": 10,
//"id": 1,
//"introduction": "meiyou",
//"logo": "meiyou ",
//"name": "红酒",
//"orders": 1,
//"parent": 0
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int grade;
@property(nonatomic,assign)int orders;
@property(nonatomic,assign)int parent;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,copy)NSString * logo;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)BOOL isSel;
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString * url;

@end
