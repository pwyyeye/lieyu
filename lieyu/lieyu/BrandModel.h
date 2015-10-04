//
//  BrandModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/2.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject
//"id": 1,
//"introduction": "人头马是好酒",
//"logo": "",
//"name": "人头马",
//"orders": 1,
//"type": 0,
//"url": ""
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int orders;
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * logo;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)BOOL isSel;
@end
