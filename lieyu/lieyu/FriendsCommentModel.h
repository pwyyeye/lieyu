//
//  FriendsCommentModel.h
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsCommentModel : NSObject
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imUserId;
@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *toUserId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *commentId;
@end
