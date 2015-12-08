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

@interface LYUserLoginViewController : UIViewController


@property(strong,nonatomic) id<LoginDelegate> delegate;

- (IBAction)forgetPassWordAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
- (IBAction)loginAct:(UIButton *)sender;
- (IBAction)zhuceAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWordTex;
@property (weak, nonatomic) IBOutlet UITextField *userNameTex;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
- (IBAction)otherAct:(UIButton *)sender;
- (IBAction)exitEdit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_getBack;
- (void)autoLogin;
@end
