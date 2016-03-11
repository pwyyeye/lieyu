//
//  LPUserLoginViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "LPLoginInView.h"
@interface LPUserLoginViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet LPLoginInView *CartoonView;
@property (weak, nonatomic) IBOutlet UIButton *loginInBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *rambleBtn;
- (IBAction)loginClick:(UIButton *)sender;
- (IBAction)registerClick:(UIButton *)sender;
- (IBAction)rambleClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartoonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CartoonTop;

@end
