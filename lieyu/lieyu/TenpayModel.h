//
//  TenpayModel.h
//  lieyu
//
//  Created by pwy on 15/11/21.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenpayModel : NSObject
//字段说明参考https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_12

@property(strong,nonatomic) NSString *appid;
@property(strong,nonatomic) NSString *partnerid;
@property(strong,nonatomic) NSString *prepayid;
@property(strong,nonatomic) NSString *package;
@property(strong,nonatomic) NSString *noncestr;
@property(strong,nonatomic) NSString *timestamp;
@property(strong,nonatomic) NSString *paySign;

@end
