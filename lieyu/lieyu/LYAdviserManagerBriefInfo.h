//
//  LYAdviserManagerBriefInfo.h
//  lieyu
//
//  Created by 狼族 on 16/6/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"userid":"专属经理id",
//"username":"名称",
//"avatar_img":"头像",
//"telephone":"电话",
//"introduction":"介绍",
//"imUserId":"imUserId",
//"barid": "酒吧ID",
//"barname": "酒吧名称",
//"age":"年龄",
//"usernick":"昵称"
@interface LYAdviserManagerBriefInfo : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *imUserId;
@property (nonatomic, strong) NSString *barid;
@property (nonatomic, strong) NSString *barname;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, assign) NSInteger sectionNumber;

@end
