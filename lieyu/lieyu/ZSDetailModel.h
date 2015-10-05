//
//  ZSDetailModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSDetailModel : NSObject
//"avatar_img": "",
//"id": 0,
//"introduction": "",
//"mobile": "130610",
//"servicestar": "",
//"userid": 2,
//"username": "130610",
//"usernick": ""
@property(nonatomic,assign)int id;
@property (nonatomic, retain) NSString * avatar_img;
@property (nonatomic, retain) NSString * introduction;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * servicestar;
@property(nonatomic,assign)int userid;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * usernick;
@end
