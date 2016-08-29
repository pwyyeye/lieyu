//
//  MineYubiRechargeTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineYubiRechargeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yubiLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (nonatomic, assign) NSInteger index;
@end
