//
//  KuCunModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KuCunModel : NSObject

//"barid": 1,
//"createDate": "",
//"deleteflag": 0,
//"id": 1,
//"linkurl": "",
//"lybarsVO": null,
//"lyuserVO": null,
//"modifyDate": "",
//"name": "1",
//"price": 50,
//"stock": 0,
//"unit": "wo",
//"userid": 1
@property(nonatomic,assign)int  id;
@property(nonatomic,assign)int barid;
@property(nonatomic,assign)int userid;
@property(nonatomic,assign)int stock;
@property(nonatomic,assign)int deleteflag;
@property(nonatomic,copy)NSString * barname;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * linkurl;
@property(nonatomic,copy)NSString * lybarsVO;
@property(nonatomic,copy)NSString * createdate;
@property(nonatomic,copy)NSString * lyuserVO;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString * unit;
@property(nonatomic,copy)NSString * imagesUrls;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,retain)NSArray * images;
@property(nonatomic,copy)NSString * modifydate;
@property(nonatomic,assign)BOOL isSel;
@property(nonatomic,assign)int useCount;
@end
