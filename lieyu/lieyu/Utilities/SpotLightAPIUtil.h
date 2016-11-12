//
//  SpotLightAPIUtil.h
//  lieyu
//
//  Created by 王婷婷 on 16/11/12.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotLightAPIUtil : NSObject

+ (SpotLightAPIUtil *)shareInstance;

- (void)addSearchItemsArray:(NSArray *)array;
- (void)deleteSpotLightItems;

@end
