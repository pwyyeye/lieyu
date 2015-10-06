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
@property (nonatomic, copy) NSString * avatar_img;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * servicestar;
@property(nonatomic,assign)int userid;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * usernick;
@end
