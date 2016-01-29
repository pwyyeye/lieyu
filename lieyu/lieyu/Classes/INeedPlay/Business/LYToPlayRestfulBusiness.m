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
#import "LYCache.h"
#import "LYCoreDataUtil.h"
#import "HomePageModel.h"

@implementation LYToPlayRestfulBusiness

- (void)getToPlayOnHomeList2:(MReqToPlayHomeList *)reqParam pageIndex:(NSInteger)index results:(void(^)(LYErrorMessage * ermsg,HomePageModel *))block{
    NSString *addStr = reqParam.address;
    NSString *titleStr = reqParam.titleStr;
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
         NSMutableArray * barlist = nil;
         NSMutableArray *bartypeslist = nil;
         LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
         HomePageModel *homePageM = [[HomePageModel alloc]init];
         if (erMsg.state == Req_Success)
         {
             
             if(index == 0){
                 //存储缓存讯息 首页
                 LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
                 [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_YD,@"lyCacheValue":dataDic,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_YD}];
             }else if(index == 1){
                 LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
                 [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_BAR,@"lyCacheValue":dataDic,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_BAR}];
             }
             
             homePageM.banner = [dataDic valueForKey:@"banner"];
             barlist = [dataDic valueForKey:@"barlist"];
             homePageM.newbanner=[dataDic valueForKey:@"newbanner"];
             bartypeslist = [dataDic valueForKey:@"bartypeslist"];
             homePageM.bartypeslist = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:bartypeslist]];
             homePageM.barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:barlist]];
             homePageM.filterImages = [dataDic valueForKey:@"filterImages"];
             NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
             homePageM.recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
         }
         block(erMsg,homePageM);
         
     } failure:^(NSError *err)
     {
         [app stopLoading];
         NSLog(@"----->%@",err.description);
         LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
         block(erMsg,nil);
     }];

}


- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam pageIndex:(NSInteger)index results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList,NSArray *newbanner,NSMutableArray *bartypeslist))block
{
    NSString *addStr = reqParam.address;
    NSString *titleStr = reqParam.titleStr;
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
        NSArray *filterImages = nil;
        NSMutableArray *bartypeslist = nil;
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
        if (erMsg.state == Req_Success)
        {
            
            if(index == 1){
                //存储缓存讯息 首页
                LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
               // [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE,@"lyCacheValue":dataDic,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE}];
            }else{
                //存储娱乐分类讯息
                if ([MyUtil isEmptyString:addStr]) {
                    NSString *keyStr = [NSString stringWithFormat:@"%@%@",CACHE_HOTJIUBA,titleStr];
                    LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
                    [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":keyStr,@"lyCacheValue":dataDic,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":keyStr}];
                }
            }
            
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
        NSLog(@"----->%@",err.description);
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
        block(erMsg,nil,nil,nil,nil);
    }];

}

- (void)getBearBarOrYzhDetail:(NSNumber *)itemId results:(void(^)(LYErrorMessage * erMsg,BeerBarOrYzhDetailModel * detailItem))block failure:(void(^)(BeerBarOrYzhDetailModel *model))needLocal
{
    NSString *keyStr = [NSString stringWithFormat:@"%@%@",CACHE_JIUBADETAIL,itemId.stringValue];
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
             
             NSDictionary *param = @{@"lyCacheKey":keyStr,@"lyCacheValue":dataDic,@"createDate":[NSDate date]};
             [[LYCoreDataUtil shareInstance] saveOrUpdateCoreData:@"LYCache" withParam:param andSearchPara:@{@"lyCacheKey":keyStr}];
         }
         
         block(erMsg,model);
     } failure:^(NSError *err)
     {
         NSDictionary *paraDic = @{@"lyCacheKey":keyStr};
         NSArray *dataArray = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" andSearchPara:paraDic];
         if(dataArray.count){
         NSDictionary *dataDic = ((LYCache *)dataArray.firstObject).lyCacheValue;
         BeerBarOrYzhDetailModel *beerModel = [BeerBarOrYzhDetailModel initFormDictionary:dataDic];
         NSLog(@"-->%@--------%@",beerModel.barname,itemId);
         needLocal(beerModel);
         }
         [app stopLoading];
         LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
         block(erMsg,nil);
     }];
}

@end













