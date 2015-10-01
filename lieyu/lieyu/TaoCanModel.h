//
//  TaoCanModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoCanModel : NSObject
//"smname":"标题",
//"price":"价格",
//"rebate":"返利点",
//"linkUrl":"icon链接地址", //多张图片，用","号分隔
//"minnum":"适合最少人数",
//"maxnum":"适合最多人数"
//"smdate":"套餐时间"
//"begindate":"开始时间"，
//"enddate":"结束时间",
//"userid":"专属经理ID",
//"barid":"酒吧ID",
//"introduction":"介绍",
//"goodsList":[//套餐商品id
//             商品id1,商品id2,商品id3......
//             ],
//"goodsNum":[//套餐商品数量
//            数量1,数量2,数量3......

@property(nonatomic,assign)int id;
@property(nonatomic,assign)int buynum;
@property(nonatomic,assign)int maxnum;
@property(nonatomic,assign)int minnum;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * linkicon;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,assign)double  price;
@property(nonatomic,assign)double  money;
@property(nonatomic,assign)double  rebate;
@property(nonatomic,copy)NSString * smdate;
@property(nonatomic,assign)int smid;
@end
