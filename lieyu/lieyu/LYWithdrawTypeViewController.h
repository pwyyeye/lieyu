//
//  LYWithdrawTypeViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYWithdrawTypeViewController : LYBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *balance;

@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UITextField *textview;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chooseButtons;
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;

@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageLabel;


@end
