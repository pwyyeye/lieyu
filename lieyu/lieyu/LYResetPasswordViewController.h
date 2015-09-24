//
//  LYResetPasswordViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYResetPasswordViewController : LYBaseViewController
- (IBAction)nextAct:(UIButton *)sender;
- (IBAction)getYZMAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *getPassWordTypeTex;
@property (weak, nonatomic) IBOutlet UITextField *yzmText;

@end
