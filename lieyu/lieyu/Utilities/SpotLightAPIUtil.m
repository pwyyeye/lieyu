//
//  SpotLightAPIUtil.m
//  lieyu
//
//  Created by 王婷婷 on 16/11/12.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SpotLightAPIUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import <UIKit/UIKit.h>
#import "JiuBaModel.h"

BOOL IS_IOS_9 = NO;
#define DomainIdentifier @"com.WTT.Spotlight--"

@implementation SpotLightAPIUtil

+ (SpotLightAPIUtil *)shareInstance{
    static SpotLightAPIUtil *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)addSearchItemsArray:(NSArray *)array{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        IS_IOS_9 = YES;
    }
    if (IS_IOS_9) {
        NSMutableArray<CSSearchableItem *> *searchItems = [[NSMutableArray alloc]init];
        for (JiuBaModel *dict in array) {
            NSString *title = dict.barname;
            NSString *desc = dict.subtitle;
            NSString *address = dict.addressabb;
            int nid = dict.barid;
            
            NSString *identifier = [NSString stringWithFormat:@"%d",nid];
//            上海 南京
            CSSearchableItemAttributeSet *itemSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:identifier];
            itemSet.title = title;
            itemSet.contentDescription = [NSString stringWithFormat:@"%@\n%@",desc,address];
            NSMutableArray *keywords = [[NSMutableArray alloc]initWithArray:[title componentsSeparatedByString:@" "]];
            [keywords addObject:desc];
            [keywords addObject:address];
            [keywords addObject:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]];
            itemSet.contactKeywords = keywords;
            
            [searchItems addObject:[[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:DomainIdentifier attributeSet:itemSet]];
        }
        [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:searchItems completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error.localizedDescription);
            }else{
                NSLog(@"Items were indexed successfully");
            }
        }];
    }
}

- (void)deleteSpotLightItems{
    [[CSSearchableIndex defaultSearchableIndex]deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        //删除所有的保存设置
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }else{
            NSLog(@"Items were deleted successfully");
        }
    }];
}

@end
