//
//  LYUserDetailInfoViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/6.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface LYUserDetailInfoViewController : UIViewController
@property (nonatomic,unsafe_unretained) BOOL isAutoLogin;
@property (nonatomic,strong) UserModel *userM;
@end
