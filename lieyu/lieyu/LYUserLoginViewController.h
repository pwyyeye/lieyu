//
//  LYUserLoginViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"


@protocol LoginDelegate <NSObject>

-(void)loginSuccess:(BOOL)isLoginSucces;

@end

@interface LYUserLoginViewController : LYBaseViewController


@property(strong,nonatomic) id<LoginDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTopConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBottomConstrant;

- (IBAction)forgetPassWordAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
- (IBAction)loginAct:(UIButton *)sender;
- (IBAction)zhuceAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWordTex;
@property (weak, nonatomic) IBOutlet UITextField *userNameTex;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

- (IBAction)exitEdit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_getBack;

@property(assign,nonatomic) NSInteger step;

@property(strong,nonatomic) NSTimer *timer;
- (void)autoLogin;
@end
