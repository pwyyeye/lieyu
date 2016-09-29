//
//  ZSUrl.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#ifndef lieyu_ZSUrl_h
#define lieyu_ZSUrl_h
//服务器
//
#define LY_SERVER @"http://121.40.229.133:80/lieyu/"
#define QINIU_SERVER @"http://121.40.229.133:80/portal/"
#define RUIQIU_SERVER @"http://10.17.114.61/lieyu/"

///
//#define LY_SERVER @"http://www.lie98.com/lieyu/"
//#define QINIU_SERVER @"http://www.lie98.com/portal/"
//#define RUIQIU_SERVER @""

//直播的服务器
#define LY_LIVE_SERVER @"http://10.17.114.61/lieyu/"

//分享的
#define LY_LIVE_share @"liveroom/live?liveChatId="

//URL地址
//IMtoken
#define LY_IMTOKEN  @"friendAction.do?action=custom"
//7牛token
#define LY_QINIUTOKEN  @"fileServerAction.do?action=cancel"

//7牛视频上传token
#define LY_QINIU_MEDIA_TOKEN  @"fileServerAction.do?action=login"

//获取验证码
#define LY_YZM  @"registerAction.do?action=custom"

//获取忘记密码验证码
#define LY_RYZM  @"registerAction.do?action=list"

//注册
#define LY_ZC  @"registerAction.do?action=add"

//第三方注册
#define LY_THIRD_ZC  @"osregisterAction.do?action=cancel"

//找回密码
#define LY_GET_PW  @"registerAction.do?action=update"
//登录
#define LY_DL  @"accountAction.do?action=login"

//第三方登录
#define LY_DL_THIRD @"accountAction.do?action=login"

//登出
#define LY_LOGOUT  @"osregisterAction.do?action=logout"

//是否强制更新
#define LY_FORCED_UPDATE  @"toPlayAction.do?action=delete"

//获取des Key
#define LY_GET_DES  @"lyOrderAction.do?action=login"

/***个人中心设置－－－pwy***/
//请求用户标签列表
#define LY_GETUSERTAGS  @"brandAction.do?action=custom"
//请求修改用户信息
#define LY_SAVE_USERINFO  @"accountAction.do?action=save"



//我的专属经理
#define LY_MY_ZSJL @"lyUsersVipStoreAction.do?action=list"
//删除收藏的专属经理
#define LY_MY_ZSJL_DEL @"/lieyu//app/api/sns/removefollow?1=1"
//申请专属经理
#define LY_APPLY_MANAGER @"lyUsersVipApplyAction.do?action=add"
//申请专属经理更新
#define LY_APPLY_UPDATE @"lyUsersVipApplyAction.do?action=update"
//获取酒吧列表
#define LY_JIUBA_LIST  @"toPlayAction.do?action=list"

/***订单***/
//专属经理订单列表
#define ZS_ORDER_LIST  @"smOrderAction.do?action=list"

//订单详细
#define ZS_ORDER_DETAIL  @"smOrderAction.do?action=custom"
//专属经理订单-对码
#define ZS_DUIMA  @"lyOrderAction.do?action=managerConfirmOrder"
//专属经理-确认卡座
#define ZS_KAZUO_SURE @"lyOrderAction.do?action=managerConfirmSeat"
//专属经理-取消订单
#define ZS_KAZUO_CANCEL @"lyOrderAction.do?action=mangerCancel"



/***商铺管理***/
//专属经理套餐列表
#define ZS_TAOCANLIST  @"lySetMealAction.do?action=list"
//专属经理拼客套餐列表
#define ZS_PINKELIST  @"lyPinkerAction.do?action=list"
//专属经理单品列表
#define ZS_DANPINLIST  @"lyProductAction.do?action=list"
//专属经理库存列表
#define ZS_KUCUNLIST  @"lyItemProductAction.do?action=list"

//专属经理 单品下架
#define ZS_DANPIN_DEL @"lyProductAction.do?action=update"
//专属经理 套餐下架
#define ZS_TAOCAN_DEL @"lySetMealAction.do?action=update"
//专属经理 拼客下架
#define ZS_PINKE_DEL @"lyPinkerAction.do?action=update"

//专属经理套餐添加
#define ZS_TAOCAN_ADD  @"lySetMealAction.do?action=add"
//专属经理库存添加
#define ZS_KUCUN_ADD  @"lyItemProductAction.do?action=add"
//专属经理单品添加
#define ZS_DANPIN_ADD  @"lyProductAction.do?action=add"

//获取酒水分类列表
#define ZS_JIUSHUI_FENLEI_LIST  @"productcategoryAction.do?action=list"
//获取酒水品牌列表
#define ZS_JIUSHUI_BRAND_LIST  @"brandAction.do?action=list"

//专属经理 设置某天卡座满座
#define ZS_KAZUO_ADD  @"lySetDeckFullAction.do?action=add"
//专属经理 设置某天卡座(未)满座
#define ZS_KAZUO_DEL  @"lySetDeckFullAction.do?action=delete"


//专属经理 我的客户
#define ZS_USERS_FRIEND  @"lyUsersFriendAction.do?action=list"

//一周卡座是否满座
#define ZS_KUZUOISFULL  @"lySetDeckFullAction.do?action=list"
//获取账户余额记录
#define LY_GET_BALANCE @"managerAccountAction.do?action=expand"

//获取提现记录
#define LY_GET_TIXIANRECORD @"managerAccountAction.do?action=list"
//申请提现
#define LP_APPLICATION_WITHDRAW @"managerAccountAction.do?action=add"


#pragma mark - 生日管家
//导入通讯录和生日
#define ZS_IMPORT_ADDRESSBOOK @"lyPhonebookAction.do?action=importExcel"

//单条添加或更新好友生日
#define ZS_ADD_FRIENDBIRTHDAY @"lyPhonebookAction.do?action=add"

//生日管家（好友生日列表）
#define ZS_GET_FRIENDBIRTHDAY @"lyPhonebookAction.do?action=list"

//生日管家（删除好友生日）
#define ZS_DELETE_FRIENDBIRTHDAY @"lyPhonebookAction.do?action=delete"

//生日管家（今天好友生日列表）
#define ZS_TODY_FRIENDBIRTHDAY @"lyPhonebookAction.do?action=expand"

#endif
