//
//  LYMineUrl.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/8.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#ifndef lieyu_LYMineUrl_h
#define lieyu_LYMineUrl_h
//客户列表
#define LY_MY_ORDER  @"lyOrderAction.do?action=list"
//免费订台列表
#define LY_MY_FREEORDER @"lyOrderFreeAction.do?action=list"

//客户明细
#define LY_MY_ORDERDETAIL  @"smOrderAction.do?action=custom"
//sn 获取拼客订单明细
#define LY_MY_ORDERDETAILSN  @"smOrderAction.do?action=expand"

//分享拼客订单
#define LY_MY_ORDER_SHARE @"lyOrderShareInAction.do?action=add"

//删除订单
#define LY_MY_ORDER_DEL @"lyOrderAction.do?action=delete"
//参与人删除订单
#define LY_MY_ORDER_DELBYCANYU @"pinkerOrderAction.do?action=delete"

//微信预付款接口
#define LY_WEIXIN_YUFU @"tenpayOrderAction.do?action=custom"

//订单统计
#define LY_MY_ORDER_TTL @"lyOrderAction.do?action=expand"

//订单评价
#define LY_MY_ORDER_PINGJIA @"lyOrderEvaluationAction.do?action=add"

//订单评价商家回复
#define LY_MY_ORDER_REVIEW @"lyOrderEvaluationAction.do?action=save"

//取消订单
#define LY_MY_ORDER_CANCEL @"lyOrderAction.do?action=cancel"
//一定会去
#define LY_MY_ORDER_GO @"lyOrderAction.do?action=custom"

//收藏的店铺
#define LY_MY_BAR_LIST @"userStoreAction.do?action=list"
//点赞的店铺
#define LY_MY_BAR_ZANG @"userPraisedAction.do?action=list"

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

//获取用户收藏的酒吧
#define LY_GETUSERCOLLECTJIUBAR @"userStoreAction.do?action=list"

//获取用户赞的酒吧
#define LY_GETUSERZANGJIUBA @"userPraisedAction.do?action=list"

//判断手机是否注册过
#define LY_YZM_THIRDLOGIN @"registerAction.do?action=login"
//绑定qq
#define LY_TIE_OPENID @"osregisterAction.do?action=cancel"

//绑定qq 已登陆情况
#define LY_TIE_OPENID2 @"usersAction.do?action=expand"

//openId登录
#define LY_OPENID_LOGIN @"accountAction.do?action=login"

//获取用户的推送配置
#define LY_USERNOTIFITION @"userPushAction.do?action=list"
//扫描述二维码加好友或订单验码
#define LY_QRCODE_SCAN @"lyQRCodeAction.do?action=custom"

//修改用户的推送配置
#define LY_USERCHANGENOTIFICATION @"userPushAction.do?action=update"
//根据用户ID，获取好友详情
#define LY_GET_USERINFO @"lyQRCodeAction.do?action=expand"
//传入消费码以及订单号进行速核
#define LY_QUICK_CHECK @"lyQRCodeAction.do?action=update"
//专属经理直接核对消费码
#define LP_CHECK_CONSUMERID @"lyOrderAction.do?action=update"
//根据用户ID获取粉丝或关注列表
#define LP_GET_FANSORCARESLIST @"lyMomentAttentionAction.do?action=list"
//添加关注或取关
#define LP_ADD_CARE @"lyMomentAttentionAction.do?action=add"
//获取话题列表
#define LP_GET_TOPICLIST @"lyTopicTypeAction.do?action=list"

//获取专属经理状态
#define LP_GET_ZSJLSTATUS @"lyUsersVipApplyAction.do?action=expand"

//专属经理验证微信
#define LP_CHECK_WECHAT @"smOrderAction.do?action=login"
//获取
#define LP_GET_UNPASSEDDATA @"lyUsersVipApplyAction.do?action=list"

//取消或者删除免费订台
#define LY_DELETE_FREEORDER @"lyOrderFreeAction.do?action=delete"

//预留卡座或者对订台表示满意或者不满意
#define LY_CHANGE_FREEORDER @"lyOrderFreeAction.do?action=update"

//获取定位城市的相关信息
#define LY_LOCATION_GETSTATUS @"lieAction.do?action=custom"
//获取钱包里数据
#define LY_GETBALANCE_COIN @"managerAccountAction.do?action=expand"
//钱包里面的充值
#define LY_RECHARGE_MONEYBAG @"lyRechargeAction.do?action=add"
//娱币兑换余额
#define LY_COINCHANGE_BALANCE @"dailyCoinAction.do?action=save"
//余额兑换娱币（娱币充值）
#define LY_RECHARGE_COIN @"dailyCoinAction.do?action=add"
//娱客帮数据获取
#define LY_GET_YUKEBANG @"app/api/yukegroup/groupList"
//娱客帮获取二维码字符串
#define LY_GET_YUKEBANGQRCODE @"/lieyu//app/api/yukegroup/getShareUrl?1=1"
//普通用户绑定提现账户
#define LY_BOUND_ACCOUNT @"dailyCoinAction.do?action=expand"
//玩友推荐
#define LY_RECOMMEND_FRIEND @"/lieyu//app/api/user/activeUser?1=1"

#endif
