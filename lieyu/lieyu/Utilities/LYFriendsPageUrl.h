//
//  LYFriendsPageUrl.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#ifndef LYFriendsPageUrl_h
#define LYFriendsPageUrl_h
//获取最新的玩友圈动态
#define LY_Friends_Recent @"lyMomentsAction.do?action=list"

//获取我的的玩友圈动态
#define LY_Friends_User @"lyMomentsAction.do?action=custom"

//获取我的的玩友圈消息
#define LY_Friends_MyNewsMessage @"lyMomentsCommentAction.do?action=list"

//给别人玩友圈动态点赞
#define LY_Friends_Like @"lyMomentLikeAction.do?action=add"
#endif /* LYFriendsPageUrl_h */
