//
//  LYAdviserComment.h
//  lieyu
//
//  Created by 狼族 on 16/6/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"userId":"评论者用户ID",
//"nickName":"评论者昵称",
//"icon":"评论者头像",
//"imUserId":"评论者的IM号",
//"toUserId":"针对某人回复时使用，空表示正常评论",
//"comment":"评论内容",
//"date":"评论日期和时间"
@interface LYAdviserComment : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *imUserId;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *date;

@end
