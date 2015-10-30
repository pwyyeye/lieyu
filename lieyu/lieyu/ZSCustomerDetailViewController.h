//
//  ZSCustomerDetailViewController.h
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "CustomerModel.h"
@interface ZSCustomerDetailViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *juliLal;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLal;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (retain, nonatomic)  CustomerModel *customerModel;
- (IBAction)liaotianAct:(UIButton *)sender;
- (IBAction)phoneAct:(UIButton *)sender;

@end
