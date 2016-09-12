//
//  LYGiftMessage.h
//  lieyu
//
//  Created by 狼族 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "GiftContent.h"

#define RCGiftMessageIdentifier @"LY:GiftMsg"
/* 点赞消息
 *
 * 对于聊天室中发送频率较高，不需要存储的消息要使用状态消息，自定义消息继承RCMessageContent
 * 然后persistentFlag 方法返回 MessagePersistent_STATUS
 */
@interface LYGiftMessage : RCMessageContent

/*
 * 类型 0 赞，1，礼物
 */
@property(nonatomic, strong) NSString *type;

@property (nonatomic ,strong) GiftContent *gift;


@end
