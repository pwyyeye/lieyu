//
//  ZSAddBirthdayViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "AddressBookModel.h"

//@protocol ZSAddBirthdayDelegate <NSObject>
//
//- (void)addBirthdayDelegate:(UserModel *)usermodel;
//
//@end

@interface ZSAddBirthdayViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *changeAvatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chooseSexButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseBirthdayButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

//@property (nonatomic, assign) id<ZSAddBirthdayDelegate> delegate;

@property (nonatomic, strong) AddressBookModel *editModel;//编辑时传来的参数
@property (nonatomic, strong) UIImage *headImage;

@end
