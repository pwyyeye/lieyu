//
//  LYAddFriendViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "CustomerModel.h"
@interface LYAddFriendViewController : LYBaseViewController
- (IBAction)sendAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *messagetext;
@property (retain, nonatomic)  CustomerModel *customerModel;
@property (copy, nonatomic)  NSString *type;

@property (nonatomic, strong) NSString *userID;
@end
