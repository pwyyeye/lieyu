//
//  LYMineUrl.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/8.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#ifndef lieyu_LYMineUrl_h
#define lieyu_LYMineUrl_h
//客户订单
#define LY_MY_ORDER  @"lyOrderAction.do?action=list"
//删除订单
#define LY_MY_ORDER_DEL @"lyOrderAction.do?action=delete"
//参与人删除订单
#define LY_MY_ORDER_DELBYCANYU @"pinkerOrderAction.do?action=delete"

//取消订单
#define LY_MY_ORDER_CANCEL @"lyOrderAction.do?action=cancel"
//一定会去
#define LY_MY_ORDER_GO @"lyOrderAction.do?action=custom"

//收藏的店铺
#define LY_MY_BAR_LIST @"userStoreAction.do?action=list"
//收藏酒吧
#define LY_MY_BAR_ADD @"userStoreAction.do?action=add"
//删除收藏酒吧
#define LY_MY_BAR_DEL @"userStoreAction.do?action=delete"

//我的好友
#define LY_MY_FRIENDS_LIST @"friendAction.do?action=list"
//删除好友
#define LY_MY_FRIENDS_DEL @"friendAction.do?action=delete"
//信息中心添加我的朋友信息
#define LY_ADDME_LIST @"lyUserShakeAction.do?action=expand"
//加好友
#define LY_ADDFRIEND_LIST @"friendAction.do?action=add"
//用户信息
#define LY_USER_INFO @"usersAction.do?action=login"
//打招呼
#define LY_GREETINGS_LIST @"lyUserShakeAction.do?action=custom"
// 接受打招呼好友
#define LY_ACCEPT_GREETINGS @"lyUserShakeAction.do?action=save"
//忽略打招呼好友
#define LY_DEL_GREETINGS @"lyUserShakeAction.do?action=delete"

//查找好友
#define LY_FINDFRIEND_LIST @"usersAction.do?action=cancel"
//附近玩家
#define LY_FINDNEARFRIEND_LIST @"lyUserShakeAction.do?action=update"
//摇一摇
#define LY_YAOYIYAO_LIST @"lyUserShakeAction.do?action=add"
//摇到的历史
#define LY_YAOHIS_LIST @"lyUserShakeAction.do?action=list"
#endif
