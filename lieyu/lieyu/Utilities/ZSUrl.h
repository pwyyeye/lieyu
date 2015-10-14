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
#define LY_SERVER @"http://121.40.229.133:8001/lieyu/"
#define QINIU_SERVER @"http://121.40.229.133:8001/portal/"
//URL地址
//IMtoken
#define LY_IMTOKEN  @"friendAction.do?action=custom"
//7牛token
#define LY_QINIUTOKEN  @"fileServerAction.do?action=cancel"
//获取验证码
#define LY_YZM  @"registerAction.do?action=custom"
//注册
#define LY_ZC  @"registerAction.do?action=add"
//找回密码
#define LY_GET_PW  @"registerAction.do?action=update"
//登录
#define LY_DL  @"accountAction.do?action=login"


//我的专属经理
#define LY_MY_ZSJL @"lyUsersVipStoreAction.do?action=list"
//申请专属经理
#define LY_APPLY_MANAGER @"lyUsersVipApplyAction.do?action=add"
//获取酒吧列表
#define LY_JIUBA_LIST  @"toPlayAction.do?action=list"

/***订单***/
//专属经理订单列表
#define ZS_ORDER_LIST  @"smOrderAction.do?action=list"
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


#endif
