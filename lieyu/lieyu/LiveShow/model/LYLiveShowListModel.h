//
//  LYLiveShowListModel.h
//  lieyu
//
//  Created by 狼族 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class roomHostUser;
@interface LYLiveShowListModel : NSObject

@property (nonatomic, assign) int roomId;
@property (nonatomic, assign) int roomHostId;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *roomImg;
@property (nonatomic, strong) NSString *roomChat;
@property (nonatomic, strong) NSString *roomType;

//@property (nonatomic, strong) NSString *roomType;
//@property (nonatomic, strong) NSString *roomLive;
//@property (nonatomic, strong) NSString *roomChat;
//@property (nonatomic, strong) NSString *playbackURL;
//@property (nonatomic, strong) NSString *roomTime;
@property (nonatomic, strong) roomHostUser *roomHostUser;
@property (nonatomic, assign) int chatNum;
@property (nonatomic, assign) int likeNum;
@property (nonatomic, assign) int joinNum;


@end
