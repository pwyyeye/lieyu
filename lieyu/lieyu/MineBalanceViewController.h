//
//  MineBalanceViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "ZSBalance.h"

@protocol MineBalanceVCDelegate <NSObject>

- (void)MineBalanceDelegateRefreshData;

@end

@interface MineBalanceViewController : LYBaseViewController

@property (nonatomic, strong) ZSBalance *balance;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;

@property (nonatomic, assign) id<MineBalanceVCDelegate> delegate;

@end
