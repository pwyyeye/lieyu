//
//  LYMyFriendDetailViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "CustomerModel.h"
@interface LYMyFriendDetailViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBGView;
@property (weak, nonatomic) IBOutlet UIButton *userimageBtn;
@property (weak, nonatomic) IBOutlet UILabel *namelal;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLal;
@property (weak, nonatomic) IBOutlet UILabel *xingzuo;
- (IBAction)sendMessageAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (retain, nonatomic)  CustomerModel *customerModel;
@property (copy, nonatomic)  NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;

- (IBAction)backForward:(UIButton *)sender;
- (IBAction)checkFans:(UIButton *)sender;
- (IBAction)checkCares:(UIButton *)sender;

@property (nonatomic, strong) NSString *userID;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *delLal;
@end
