//
//  LYZSApplicationViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "unPassesModel.h"
@interface LYZSApplicationViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *jiubaLal;
- (IBAction)chooseJiuBaAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *jiubaButton;
- (IBAction)exitEdit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *wechatLbl;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chooseButtons;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *sfzTex;

@property (weak, nonatomic) IBOutlet UIView *viewLine2;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel2;
@property (weak, nonatomic) IBOutlet UITextField *yhkkhTex;

@property (weak, nonatomic) IBOutlet UIView *viewLine3;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel3;
@property (weak, nonatomic) IBOutlet UITextField *yhkKhmYhmTex;

@property (weak, nonatomic) IBOutlet UIView *viewLine4;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel4;
@property (weak, nonatomic) IBOutlet UITextField *yhkyhmTex;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextAct:(UIButton *)sender;

@property (nonatomic, strong) unPassesModel *checkModel;

@property (nonatomic, strong) NSString *subTitle;

@end
