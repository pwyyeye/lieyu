//
//  LYToPlayRestfulBusiness.m
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYToPlayRestfulBusiness.h"
#import "JiuBaModel.h"
#import "bartypeslistModel.h"
@implementation LYToPlayRestfulBusiness

- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList,NSArray *newbanner,NSMutableArray *bartypeslist))block
{
    NSDictionary * param = [reqParam mj_keyValues];
    if (param == nil) {
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:kHttpAPI_LY_TOPLAY_HOMELIST  baseURL:LY_SERVER params:param success:^(id response)
    {
        
        [app stopLoading];
        NSDictionary *dataDic = response[@"data"];
        NSMutableArray *bannerList = nil;
        NSMutableArray * barlist = nil;
        NSArray *newbanner = nil;
        NSMutableArray *bartypeslist = nil;
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
        if (erMsg.state == Req_Success)
        {
            
            //存储缓存讯息
            LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
            [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE,@"lyCacheValue":dataDic,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE}];
            
            bannerList = [dataDic valueForKey:@"banner"];
            barlist = [dataDic valueForKey:@"barlist"];
            newbanner=[dataDic valueForKey:@"newbanner"];
            bartypeslist = [dataDic valueForKey:@"bartypeslist"];
            bartypeslist = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:bartypeslist]];
            barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:barlist]];
        }
        
        block(erMsg,bannerList,barlist,newbanner,bartypeslist);
    } failure:^(NSError *err)
    {
        [app stopLoading];
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
        block(erMsg,nil,nil,nil,nil);
    }];

}

- (void)getBearBarOrYzhDetail:(NSNumber *)itemId results:(void(^)(LYErrorMessage * erMsg,BeerBarOrYzhDetailModel * detailItem))block
{
    if (itemId == nil) {
        return;
    }
    NSDictionary * param = @{@"barid":itemId};

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:kHttpAPI_LY_TOPLAY_BARDETAIL  baseURL:LY_SERVER params:param success:^(id response)
     {
         [app stopLoading];
         NSDictionary *dataDic = response[@"data"];
         BeerBarOrYzhDetailModel *model = nil;

         LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
         if (erMsg.state == Req_Success)
         {
             model = [BeerBarOrYzhDetailModel initFormDictionary:dataDic];
         }
         
         block(erMsg,model);
     } failure:^(NSError *err)
     {
         [app stopLoading];
         LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
         block(erMsg,nil);
     }];
}

@end













