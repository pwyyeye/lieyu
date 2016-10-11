//
//  WatchPlayerClient.h
//  lieyu
//
//  Created by 狼族 on 16/10/10.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PLPlayerKit/PLPlayerKit.h>

@interface WatchPlayerClient : NSObject

+(instancetype)sharedPlayerClient;

//播放
-(PLPlayer *) playWithUrl: (NSString *) url;
//停止
-(void)stopPlayWithUrl: (NSString *) url;

@end
