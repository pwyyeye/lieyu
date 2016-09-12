//
//  MineYubiViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@protocol MineYubiDelegate <NSObject>

- (void)MineYubiWithdrawDelegate:(double)amount;
- (void)MineYubiRechargeDelegate:(double)yubi balance:(double)balance;

@end

@interface MineYubiViewController : LYBaseViewController

@property (nonatomic, strong) NSString *coinAmount;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, assign) id<MineYubiDelegate> delegate;

@end
