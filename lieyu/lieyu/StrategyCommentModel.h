//
//  StrategyCommentModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrategyCommentModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *imUserId;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *toUserNickName;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *strategyId;


@end
