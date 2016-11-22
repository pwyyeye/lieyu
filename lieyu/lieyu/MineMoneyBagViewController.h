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
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (weak, nonatomic) IBOutlet UIImageView *coinImage;
@property (weak, nonatomic) IBOutlet UILabel *coinDefault;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@property (weak, nonatomic) IBOutlet UILabel *seperateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperaterConstant;

- (IBAction)balanceClick:(UIButton *)sender;
- (IBAction)yubiClick:(UIButton *)sender;

@end
