//
//  LYAccountManager.h
//  lieyu
//
//  Created by pwy on 16/1/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseTableViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LYAccountManager : LYBaseTableViewController<UIActionSheetDelegate>
@property(strong,nonatomic) NSArray *data;
@property(strong,nonatomic) TencentOAuth *tencentOAuth;;
@end
