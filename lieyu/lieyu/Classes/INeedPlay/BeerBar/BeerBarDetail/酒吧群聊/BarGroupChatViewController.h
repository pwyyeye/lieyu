//
//  BarGroupChatViewController.h
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface BarGroupChatViewController : RCConversationViewController

@property(nonatomic, strong) NSArray *groupManage;//所有的老司机

@property(nonatomic, strong) NSString *titleName;//标题名字

@end
