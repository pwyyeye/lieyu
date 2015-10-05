//
//  LYRegistrationViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol LYRegistrationDelegate<NSObject>
- (void)registration;

@end
@interface LYRegistrationViewController : LYBaseViewController
- (IBAction)zcAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTex;
@property (weak, nonatomic) IBOutlet UITextField *yzmTex;
@property (weak, nonatomic) IBOutlet UIButton *getYzmBtn;
- (IBAction)getYzmAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWordTex;
@property (weak, nonatomic) IBOutlet UITextField *againPassWordTex;
@property(strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) int step;
- (IBAction)exitEdit:(UITextField *)sender;
@property (nonatomic, weak) id <LYRegistrationDelegate> delegate;
@end
