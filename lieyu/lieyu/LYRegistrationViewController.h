//
//  LYRegistrationViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@class UserModel;

@protocol LYRegistrationDelegate<NSObject>
- (void)registration;

@end
@interface LYRegistrationViewController : UIViewController
- (IBAction)zcAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *textField_phone;
@property (weak, nonatomic) IBOutlet UIImageView *textField_YZM;
@property (weak, nonatomic) IBOutlet UIImageView *textField_psw;
@property (weak, nonatomic) IBOutlet UIImageView *textField_psw_little;


@property (weak, nonatomic) IBOutlet UITextField *phoneTex;
@property(nonatomic,strong) UserModel *userM;
@property (nonatomic,unsafe_unretained) BOOL isTheThirdLogin;
@property (weak, nonatomic) IBOutlet UITextField *yzmTex;
@property (weak, nonatomic) IBOutlet UIButton *getYzmBtn;
- (IBAction)getYzmAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWordTex;
@property (weak, nonatomic) IBOutlet UITextField *againPassWordTex;
@property(strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) int step;
- (IBAction)exitEdit:(UITextField *)sender;
@property (nonatomic, weak) id <LYRegistrationDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_regist;

+ (instancetype)shareRegist;
@end
