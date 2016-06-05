//
//  FriendsRecentModel.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FriendsRecentModel.h"
#import "MJExtension.h"
#import "FriendsCommentModel.h"
#import "FriendsLikeModel.h"
#import "FriendsPicAndVideoModel.h"
#import "FriendsTagModel.h"
#import "LYAdviserItem.h"

@implementation FriendsRecentModel


+(void)load
{
    [FriendsRecentModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"commentList":@"FriendsCommentModel",
                 @"lyMomentsAttachList":@"FriendsPicAndVideoModel",
                 @"likeList":@"FriendsLikeModel",
                 @"tags":@"FriendsTagModel",
                 @"items":@"LYAdviserItem"
                 };
    }];
}

+(NSArray *)initFormNSArray:(NSArray *)arr
{
    NSArray *model = [FriendsRecentModel mj_objectArrayWithKeyValuesArray:arr];
    return model;
}

+ (FriendsRecentModel *)initFromNSDictionary:(NSDictionary *)dic{
    FriendsRecentModel *mod = [FriendsRecentModel mj_objectWithKeyValues:dic];
    return mod;
}

@end
