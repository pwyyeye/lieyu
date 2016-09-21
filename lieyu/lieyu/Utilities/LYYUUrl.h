//
//  LYYUUrl.h
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#ifndef LYYUUrl_h
#define LYYUUrl_h

#define LY_YU_ORDERSHARE @"lyOrderShareAction.do?action=list"

#define LY_YU_YUMODEL @"lyOrderShareAction.do?action=expand"

#define LY_YU_GETTAG @"lyRequireAction.do?action=importExcel" //获取所有需求标签

#define LY_YU_SENDMYTHEME @"lyRequireAction.do?action=add" //发布个人需求
#define LY_YU_WISHES @"lyRequireAction.do?action=list"
#define LY_YU_FINISH @"lyRequireAction.do?action=update"
#define LY_YU_DELETE @"lyRequireAction.do?action=delete"
#define LY_YU_JUBAO @"versionAction.do?action=list"

#define LY_YU_CHATROOM_REMOVE @"friendAction.do?action=expand"//聊天室踢人

#define LY_YU_REPLY @"lyRequireAction.do?action=save"

#define LY_YU_CHATOOM_ALLSTAFF @"lyRequireAction.do?action=expand"//聊天室成员

#define LY_YU_QUNZU_CUSTOM  @"groupAction.do?action=custom"//同步用户群信息

#define LY_YU_QUNZU_CREAT @"lyGroupManageAction.do?action=custom"//创建群

#define LY_YU_QUNZU_JOIN @"groupAction.do?action=save"//加入群

#define LY_YU_QUNZU_QUIT @"groupAction.do?action=update"//退出群

#define LY_YU_QUNZU_DISMISS  @"groupAction.do?action=cancel"//解散群

#define LY_YU_QUNZU_REFREASH  @"groupAction.do?action=delete"//  刷新群信息

#define LY_YU_QUNZU_LIST  @"lyGroupManageAction.do?action=login"//获取群组成员

#define LY_YU_QUNZU_LOGIN  @"groupAction.do?action=login"//添加禁言成员

#define LY_YU_QUNZU_LOGOUT @"groupAction.do?action=logout"//移除禁言群成员

#define LY_YU_QUNZU_EXPAND  @"lyGroupManageAction.do?action=logout"//查询被禁言群成员

#define LY_YU_QUNZU_BARMANNGER  @"lyGroupManageAction.do?action=expand"//申请成为群主

#endif /* LYYUUrl_h */
