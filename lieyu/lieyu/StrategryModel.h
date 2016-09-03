//
//  StrategryModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//"content": "具体h5页面",
//"favNum": "收藏数",
//"id": 15,
//"likeNum":"点赞数",
//"strategyIconAll": "攻略主图",
//"subtitle": "副标题",
//"title": "主标题"

@interface StrategryModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *favNum;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *likeNum;
@property (nonatomic, strong) NSString *strategyIconAll;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *title;

@end
