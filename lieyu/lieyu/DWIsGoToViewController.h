//
//  DWIsGoToViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol DateChoosegoTypeDelegate
@optional
-(void)changeType:(NSString *)goType;
@end
@interface DWIsGoToViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UIButton *noGoBtn;
- (IBAction)checkAct:(UIButton *)sender;

- (IBAction)sureAct:(UIButton *)sender;
@property (nonatomic,weak)id<DateChoosegoTypeDelegate>delegate;
@end
