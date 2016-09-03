//
//  HomepageBannerModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageBannerModel : NSObject

@property (nonatomic, strong) NSString *ad_type;//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客
@property (nonatomic, strong) NSString *ad_typename;//"酒吧",
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *linkid;//对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
@property (nonatomic, strong) NSString *linkurl;//文章或网页链接地址
@property (nonatomic, strong) NSString *content;//活动内容
@property (nonatomic, strong) NSString *title;

@end
