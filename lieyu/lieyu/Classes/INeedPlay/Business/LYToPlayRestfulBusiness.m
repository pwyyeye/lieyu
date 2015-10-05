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

- (void)getToPlayOnHomeList:(MReqToPlayHomeList *)reqParam results:(void(^)(LYErrorMessage * ermsg,NSArray * bannerList,NSArray *barList))block
{
    NSDictionary * param = [reqParam keyValues];
    if (param == nil) {
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_TOPLAY_HOMELIST  baseURL:LY_SERVER params:param success:^(id response)
    {
        [app stopLoading];
        NSDictionary *dataDic = response[@"data"];
        NSMutableArray *bannerList = nil;
        NSMutableArray * barlist = nil;
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithDictionary:response];
        if (erMsg.state == Req_Success)
        {
            bannerList = [dataDic valueForKey:@"banner"];
            barlist = [dataDic valueForKey:@"barlist"];
            barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel objectArrayWithKeyValuesArray:barlist]];
        }
        
        block(erMsg,bannerList,barlist);
    } failure:^(NSError *err)
    {
        [app stopLoading];
        LYErrorMessage * erMsg = [LYErrorMessage instanceWithError:err];
        block(erMsg,nil,nil);
    }];

}


@end
