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

//7牛token
#define LY_QINIUTOKEN  @"fileServerAction.do?action=cancel"



//专属经理套餐列表
#define ZS_TAOCANLIST  @"lySetMealAction.do?action=list"
//专属经理拼客套餐列表
#define ZS_PINKELIST  @"lyPinkerAction.do?action=list"
//专属经理单品列表
#define ZS_DANPINLIST  @"lyProductAction.do?action=list"
//专属经理库存列表
#define ZS_KUCUNLIST  @"lyItemProductAction.do?action=list"

//专属经理库存添加
#define ZS_KUCUN_ADD  @"lyItemProductAction.do?action=add"


//专属经理 设置某天卡座满座
#define ZS_KAZUO_ADD  @"lySetDeckFullAction.do?action=add"
//专属经理 设置某天卡座(未)满座
#define ZS_KAZUO_DEL  @"lySetDeckFullAction.do?action=delete"


//专属经理 我的客户
#define ZS_USERS_FRIEND  @"lyUsersFriendAction.do?action=list"

//一周卡座是否满座
#define ZS_KUZUOISFULL  @"lySetDeckFullAction.do?action=list"

#endif
