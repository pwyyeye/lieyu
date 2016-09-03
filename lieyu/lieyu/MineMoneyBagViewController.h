//
//  MineMoneyBagViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface MineMoneyBagViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yubiLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)balanceClick:(UIButton *)sender;
- (IBAction)yubiClick:(UIButton *)sender;

@end
