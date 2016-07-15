//
//  GroupLeaderRegisterViewController.h
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface GroupLeaderRegisterViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) NSString *groupId;

@end
