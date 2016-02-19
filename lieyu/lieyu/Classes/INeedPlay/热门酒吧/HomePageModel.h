//
//  HomePageModel.h
//  lieyu
//
//  Created by 狼族 on 16/1/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JiuBaModel;
@class RecommendedTopic;

@interface HomePageModel : NSObject
@property (nonatomic,strong) NSArray *banner;
@property (nonatomic,strong) NSArray *barlist;
@property (nonatomic,strong) NSArray *bartypeslist;
@property (nonatomic,strong) NSArray *filterImages;
@property (nonatomic,strong) NSArray *newbanner;
@property (nonatomic,strong) JiuBaModel *recommendedBar;
@property (nonatomic,strong) RecommendedTopic *recommendedTopic;
@end
