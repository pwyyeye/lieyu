//
//  LYResetPasswordViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol LYResetPasswordDelegate<NSObject>
- (void)resetPassword;

@end
@interface LYResetPasswordViewController : LYBaseViewController
- (IBAction)nextAct:(UIButton *)sender;
- (IBAction)getYZMAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *getPassWordTypeTex;
@property (weak, nonatomic) IBOutlet UITextField *yzmText;
@property (weak, nonatomic) IBOutlet UIButton *getYzmBtn;
@property(strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) int step;
@property (weak, nonatomic) IBOutlet UITextField *passWordTex;
@property (weak, nonatomic) IBOutlet UITextField *againPassWordTex;
- (IBAction)exitEdit:(UITextField *)sender;
@property (nonatomic, weak) id <LYResetPasswordDelegate> delegate;
@end
