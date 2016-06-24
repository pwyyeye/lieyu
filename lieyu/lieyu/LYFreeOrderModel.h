//
//  LYFreeOrderModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/6/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface LYFreeOrderModel : NSObject
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *baricon;
@property (nonatomic, assign) NSInteger barid;//
@property (nonatomic, strong) NSString *barname;
@property (nonatomic, assign) int cassetteType;//
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *finishTime;
@property (nonatomic, assign) NSInteger id;//
@property (nonatomic, strong) NSString *imUserId;
@property (nonatomic, assign) BOOL isSatisfaction;
@property (nonatomic, strong) NSString *isSatisfactionName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) NSInteger orderStatus;//
@property (nonatomic, assign) NSInteger minPartNumber;//
@property (nonatomic, assign) NSInteger partNumber;//
@property (nonatomic, strong) NSString *reachTime;
@property (nonatomic, assign) NSInteger userid;//
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, strong) NSString *vipAvatarImg;
@property (nonatomic, strong) NSString *vipConfirmTime;
@property (nonatomic, strong) NSString *vipImUserId;
@property (nonatomic, strong) NSString *vipMobile;
@property (nonatomic, assign) NSInteger vipUserid;
@property (nonatomic, strong) NSString *vipUsernick;
@property (nonatomic, assign) BOOL isManager;
@end
