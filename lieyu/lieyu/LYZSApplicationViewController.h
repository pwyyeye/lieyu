//
//  LYZSApplicationViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYZSApplicationViewController : LYBaseViewController
- (IBAction)chooseJiuBaAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *zwjsTex;
@property (weak, nonatomic) IBOutlet UITextField *zfbzhTex;
@property (weak, nonatomic) IBOutlet UITextField *yhkkhTex;
@property (weak, nonatomic) IBOutlet UITextField *zfbTex;
@property (weak, nonatomic) IBOutlet UITextField *yhkKhmYhmTex;
- (IBAction)nextAct:(UIButton *)sender;

@end
