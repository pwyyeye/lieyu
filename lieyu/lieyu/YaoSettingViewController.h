//
//  YaoSettingViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/30.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface YaoSettingViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
- (IBAction)settingAct:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hisBtn;
- (IBAction)hisAct:(UIButton *)sender;

@end
