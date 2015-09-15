//
//  ZSOrderViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ZSOrderViewController : LYBaseViewController
- (IBAction)backAct:(UIButton *)sender;
- (IBAction)timeChooseAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;
@property (weak, nonatomic) IBOutlet UIButton *xialaBtn;

@end
