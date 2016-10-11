//
//  WatchPlayerClient.m
//  lieyu
//
//  Created by 狼族 on 16/10/10.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "WatchPlayerClient.h"

@interface WatchPlayerClient  ()
@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) NSString *oldUrl;//记录链接
@end

@implementation WatchPlayerClient
//全局变量
static WatchPlayerClient *PlayerClient = nil;
//单例方法
+(instancetype)sharedPlayerClient{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        PlayerClient = [[self alloc] init];
    });
    return PlayerClient;
}

- (instancetype)init
{
    __block WatchPlayerClient *temp = self;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((temp = [super init]) != nil) {
          
        }
    });
    self = temp;
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PlayerClient = [super allocWithZone:zone];
    });
    return PlayerClient;
}

//播放
-(PLPlayer *) playWithUrl: (NSString *) url{
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    if ([MyUtil isEmptyString:_oldUrl]) {//为空，第一次创建
        
    } else {
        if ([_oldUrl isEqualToString:url]) {//检测是否一致
            return nil;
        } else {//不一致就把之前的关闭
            [self stopPlayWithUrl:_oldUrl];
        }
    }
    _player = [PLPlayer playerWithURL:[NSURL URLWithString:url] option:option];
    if (![_player isPlaying]) {
        [_player play];
    }
    _oldUrl = url;
    return _player;
}

//停止
-(void)stopPlayWithUrl: (NSString *) url{
    if ([_player isPlaying]) {
        [_player stop];
    }
}

@end
