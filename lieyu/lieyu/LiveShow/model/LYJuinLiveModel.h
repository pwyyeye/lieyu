//
//  LYJuinLiveModel.h
//  lieyu
//
//  Created by 狼族 on 16/8/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class roomHostUser;
@interface LYJuinLiveModel : NSObject

@property (nonatomic, strong) NSString *roomType;
@property (nonatomic, strong) NSString *liveRtmpUrl;
@property (nonatomic, strong) NSString *playbackURL;
@property (nonatomic, strong) NSString *chatroomid;
@property (nonatomic, copy) roomHostUser *roomHostUser;


@end
