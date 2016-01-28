//
//  LYToPlayRestfulBusiness.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPController.h"
#import "MReqToPlayHomeList.h"
#import "NetPublic.h"
#import "BeerBarOrYzhDetailModel.h"
@class HomePageModel;

@interface LYToPlayRestfulBusiness : NSObject

//----获得酒吧，夜总会列表
- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam pageIndex:(NSInteger)index results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList,NSArray *newbanner,NSMutableArray *bartypeslist))block;

- (void)getToPlayOnHomeList2:(MReqToPlayHomeList *)reqParam pageIndex:(NSInteger)index results:(void(^)(LYErrorMessage * ermsg,HomePageModel *))block;

//---获得酒吧信息
- (void)getBearBarOrYzhDetail:(NSNumber *)itemId results:(void(^)(LYErrorMessage * erMsg,BeerBarOrYzhDetailModel * detailItem))block failure:(void(^)(BeerBarOrYzhDetailModel *model))needLocal;


@end




