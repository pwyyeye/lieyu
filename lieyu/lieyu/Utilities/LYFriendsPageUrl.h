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

//给动态或者某人评论
#define LY_Friends_Comment @"lyMomentCommentAction.do?action=add"

//发布动态
#define LY_Friends_Send @"lyMomentsAction.do?action=add"

//删除我的动态
#define LY_Friends_DeleteMyMessage @"lyMomentsAction.do?action=delete"

//获取所有评论
#define LY_Friends_AllComments @"lyMomentCommentAction.do?action=list"

#endif /* LYFriendsPageUrl_h */
