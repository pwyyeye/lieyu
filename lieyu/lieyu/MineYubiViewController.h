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

@end

@interface MineYubiViewController : LYBaseViewController

@property (nonatomic, strong) NSString *coinAmount;
@property (nonatomic, assign) id<MineYubiDelegate> delegate;

@end
