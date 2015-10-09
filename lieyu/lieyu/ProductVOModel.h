//
//  ProductVOModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/6.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVOModel : NSObject
@property(nonatomic,assign)int allocatestock;
@property(nonatomic,copy)NSString * auditDate;
@property(nonatomic,assign)int auditStatus;
@property(nonatomic,copy)NSString * auditStatusName;
@property(nonatomic,assign)int barid;
@property(nonatomic,copy)NSString * barname;
@property(nonatomic,copy)NSString * brand;
@property(nonatomic,assign)int brandid;
@property(nonatomic,copy)NSString * category;
@property(nonatomic,assign)int categoryid;
@property(nonatomic,assign)double cost;
@property(nonatomic,copy)NSString * createdate;
@property(nonatomic,assign)int favnum;
@property(nonatomic,copy)NSString * fullname;
@property(nonatomic,copy)NSString * goods_image;
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * images_450;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,assign)int ishot;
@property(nonatomic,copy)NSString * ishotName;
@property(nonatomic,assign)int ismarketable;
@property(nonatomic,assign)int itemProductId;
@property(nonatomic,copy)NSString * itemProductName;
@property(nonatomic,copy)NSString * keyword;
@property(nonatomic,copy)NSString *marketprice;
@property(nonatomic,copy)NSString * memo;
@property(nonatomic,copy)NSString * modifydate;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * offshelfDate;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,assign)int productimageid;
@property(nonatomic,copy)NSString *rebate;
@property(nonatomic,assign)double sales;
@property(nonatomic,assign)int scorecount;
@property(nonatomic,assign)int stock;
@property(nonatomic,assign)int totalscore;
@property(nonatomic,copy)NSString * unit;
@property(nonatomic,assign)int upflag;
@property(nonatomic,copy)NSString * upflagName;
@property(nonatomic,assign)int userid;
@property(nonatomic,assign)double weight;
@end
