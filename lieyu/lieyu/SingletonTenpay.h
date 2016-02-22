//
//  SingletonTenpay.h
//  lieyu
//
//  Created by pwy on 15/11/21.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "LYUserHttpTool.h"
#import "TenpayModel.h"
@protocol SingletonTenpayDelegate <NSObject>

-(void)callBack:(NSDictionary *)resultDic;

@end

@interface SingletonTenpay : NSObject<WXApiDelegate>

@property(strong,nonatomic) id<SingletonTenpayDelegate> delegate;
@property(strong,nonatomic) TenpayModel *tenpayModel;
@property(assign,nonatomic) NSInteger isPinker;

@property(assign,nonatomic) BOOL isFaqi;
@property(strong,nonatomic) NSString *orderNO;

+(SingletonTenpay *)singletonTenpay;

-(void)preparePay:(NSDictionary *)param complete:(void (^)(BaseReq *result))block;
@end
