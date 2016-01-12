//
//  FriendsRecentModel.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsRecentModel : NSObject
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *attach;
@property (nonatomic,copy) NSString *attachType;
@property (nonatomic,copy) NSString *avatar_img;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,strong) NSMutableArray *commentList;
@property (nonatomic,copy) NSString *commentNum;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *frientId;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imUserId;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *isAttention;
@property (nonatomic,strong) NSMutableArray *likeList;
@property (nonatomic,copy) NSString *likeNum;
@property (nonatomic,copy) NSString *liked;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,strong) NSArray *lyMomentsAttachList;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *usernick;
@property (nonatomic,copy) NSString *friends_img;
@property (nonatomic,copy) NSArray *tags;
@property (nonatomic,unsafe_unretained) BOOL isMeSendMessage;
+(NSArray *)initFormNSArray:(NSArray *)arr;
+ (FriendsRecentModel *)initFromNSDictionary:(NSDictionary *)dic;
@end
