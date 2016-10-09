//
//  MineBoundAccountViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@protocol MineBoundAccountDelegate <NSObject>

- (void)mineBoundAccountWithType:(NSString *)type Account:(NSString *)account;

@end

@interface MineBoundAccountViewController : LYBaseViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *withdrawButtons;

- (IBAction)withdrawButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextField;
@property (weak, nonatomic) IBOutlet UILabel *seperateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (nonatomic, assign) id<MineBoundAccountDelegate> delegate;

@end
