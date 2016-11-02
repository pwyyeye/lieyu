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
#define LY_Friends_Recent @"lyMomentsOutAction.do?action=list"

//获取我的的玩友圈动态
#define LY_Friends_User @"lyMomentsOutAction.do?action=custom"

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

//删除我的评论
#define LY_Friends_DeleteMyComment @"lyMomentCommentAction.do?action=delete"

//获取所有评论
#define LY_Friends_AllComments @"lyMomentCommentOutAction.do?action=list"

//获取最新消息
#define LY_Friends_NewMessage @"lyMomentsAction.do?action=login"

//获取最新消息明细
#define LY_Friends_NewMessageDetail @"lyMomentsAction.do?action=expand"

//更改玩友圈背景图片
#define LY_Friends_ChangeBGImage @"lyuserAction.do?action=custom"

//根据动态id获取动态
#define LY_Friends_GetAMessage @"lyMomentsAction.do?action=importExcel"

//举报
#define LY_Friends_JuBaoDT @"lyMomentCommentAction.do?action=update"

//屏蔽
#define LY_Friends_PingBiUser @"lyMomentsAction.do?action=update"

//根据话题ID获取玩友圈动态
#define LY_Friends_TopicMessage @"lyMomentsOutAction.do?action=expand"

//玩友--关注
#define LY_Friends_follow @"app/api/sns/follow?1=1"

//玩友--取消关注
#define LY_Frienfs_Unfollow @"app/api/sns/removefollow?1=1"

//玩友列表
#define LY_Friends_friendsGroup @"app/api/sns/friendsGroup?1=1"

//新粉丝列表
#define LY_Friends_newFriendsList @"app/api/sns/newFansList?1=1"

#pragma mark -- 直播接口
//获取stream
#define LY_Live_getstream @"app/api/liveroom/createTempStream?1=1"

//开始直播
#define LY_Live_beginLive @"app/api/liveroom/create?1=1"

//获取直播列表
#define LY_Live_getList @"app/api/liveroom/list?1=1"

//进入直播间
#define LY_Live_enter @"app/api/liveroom/live?1=1"

//结束直播
#define LY_Live_closeLive @"app/api/liveroom/close?1=1"

//获取直播间打赏金额
#define LY_Live_getMoney @"app/api/liveroom/rewardNum?1=1"

//点赞
#define LY_Live_like @"app/api/liveroom/likeLiveRoom?1=1"

//请求人员列表和点赞
#define LY_Live_requestlist @"app/api/liveroom/roomUserList?1=1"

//获取直播状态
#define LY_Live_liveStatus @"app/api/liveroom/getLiveStatus?1=1"

#pragma mark --- 打赏
#define LY_DaShang @"dailyCoinAction.do?action=custom"

#define LY_DaShangList  @"app/api/reward/rewardTypeList?1=1"
//删除直播
#define LY_LIVE_DELETE @"app/api/liveroom/delete?1=1"

#endif /* LYFriendsPageUrl_h */
