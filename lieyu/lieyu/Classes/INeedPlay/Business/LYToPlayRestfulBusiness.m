//
//  LYToPlayRestfulBusiness.m
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYToPlayRestfulBusiness.h"
#import "JiuBaModel.h"

@implementation LYToPlayRestfulBusiness

- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList,NSArray *newbanner))block
{
    NSDictionary * param = [reqParam keyValues];
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
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
        if (erMsg.state == Req_Success)
        {
            bannerList = [dataDic valueForKey:@"banner"];
            barlist = [dataDic valueForKey:@"barlist"];
            newbanner=[dataDic valueForKey:@"newbanner"];
            barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:barlist]];
        }
        
        block(erMsg,bannerList,barlist,newbanner);
    } failure:^(NSError *err)
    {
        [app stopLoading];
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
        block(erMsg,nil,nil,nil);
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













