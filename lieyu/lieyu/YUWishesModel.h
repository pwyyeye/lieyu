//
//  YUWishesModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"address": "上海 闵行区",
//"createDate": "2016-04-22 13:38:23",
//"desc": "周末有地方去玩吗",
//"id": 7,
//"isReply": "已回复",
//"isfinished": 0,
//"isfinishedStr": "未处理",
//"moneyEnd": 0,
//"moneyStart": 50,
//"pointNumber": 0,
//"releaseAvatarImg": "http://7xn0lq.com2.z0.glb.qiniucdn.com/20160127212540923.jpg",
//"releaseUserName": "albert",
//"releaseUserid": 130615,
//"replyAvatarImg": "",
//"replyContent": "建议去东方明珠玩下！！！",
//"replyDate": "2016-04-22 15:32:25",
//"replyUserName": "",
//"replyUserid": 130610,
//"tagName": "去旅游",
//"tagid": 3
@interface YUWishesModel : NSObject
@property (nonatomic,copy) NSString *isChatroom;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *imUserId;
@property (nonatomic, strong) NSString *isReply;
@property (nonatomic, strong) NSString *isfinished;
@property (nonatomic, strong) NSString *isfinishedStr;
@property (nonatomic, assign) int moneyEnd;
@property (nonatomic, assign) int moneyStart;
@property (nonatomic, strong) NSString *pointNumber;
@property (nonatomic, strong) NSString *releaseAvatarImg;
@property (nonatomic, strong) NSString *releaseUserName;
@property (nonatomic, assign) int releaseUserid;
@property (nonatomic, strong) NSString *replyAvatarImg;
@property (nonatomic, strong) NSString *replyContent;
@property (nonatomic, strong) NSString *replyDate;
@property (nonatomic, strong) NSString *replyUserName;
@property (nonatomic, assign) int replyUserid;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) int tagid;
@end
