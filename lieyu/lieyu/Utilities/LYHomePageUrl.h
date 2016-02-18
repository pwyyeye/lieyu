//
//  LYHomePageUrl.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//


#ifndef lieyu_LYHomePageUrl_h
#define lieyu_LYHomePageUrl_h
//一起玩列表
#define LY_YIQIWAN_LIST  @"togetherAction.do?action=list"
//一起玩列表详细
#define LY_YIQIWAN_DETAIL @"togetherAction.do?action=custom"
//从套餐转到订单确认

//http:121.40.229.133:8001/lieyu/togetherneedAction.do?action=expand
#define LY_YIQIWAN_DOORDER @"togetherneedAction.do?action=expand"
//录入拼客订单
#define LY_YIQIWAN_INORDER @"pinkerOrderAction.do?action=add"
//参与人参与拼客
#define LY_MY_ORDER_INPINKER @"pinkerOrderAction.do?action=update"

//我要订位
#define LY_WOYAODINWEI_INFO @"toPlayAction.do?action=expand"
// 我要订位请求获取套餐信息
#define LY_WOYAODINWEI_TAOCAN_INFO @"toPlayAction.do?action=save"
//录入套餐订单
#define LY_WOYAODINWEI_INORDER @"smOrderAction.do?action=add"
//点赞
#define LY_DIANZANG @"userPraisedAction.do?action=add"
//取消赞
#define LY_QUXIAOZANG @"userPraisedAction.do?action=delete"

//吃喝专场
//获取吃喝列表
#define LY_CH_LISt @"drinksAction.do?action=list"
//获取吃喝明细
#define LY_CH_DETAIL @"drinksAction.do?action=custom"
//加入购物车
#define LY_CH_ADDCAR @"cartAction.do?action=add"
//购物车列表
#define LY_CH_CARLIST @"cartAction.do?action=list"
//购物车删除
#define LY_CH_DEL @"cartAction.do?action=delete"
//购物车数量变更
#define LY_CH_NUMCHANGE @"cartAction.do?action=update"
//购物车转订单
#define LY_CH_INORDER  @"cartAction.do?action=list"
//录入购物车订单
#define LY_CH_ORDERIN @"cartAction.do?action=addToOrder"

//获取某个酒吧下的专属经理列表
#define LY_BAR_VIPLIST @"toPlayGetVipAction.do?action=list"
//收藏专属经理
#define LY_SC_VIPLIST @"lyUsersVipStoreAction.do?action=add"


#define LY_BAR_ACTIVITYLIST @"activitiesOutAction.do?action=list"
//获取专题页列表
#define LY_ACTION_LIST @"activitiesOutAction.do?action=expand"
//获取活动详情
#define LY_ACTIVITY_DETAIL @"activitiesOutAction.do?action=custom"
#endif
