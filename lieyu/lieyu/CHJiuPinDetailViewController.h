//
//  CHJiuPinDetailViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "NeedHideNavigationBar.h"
#import "CHChooseNumView.h"
@interface CHJiuPinDetailViewController : LYBaseViewController<NeedHideNavigationBar>{
    UIView  *_bgView;
    CHChooseNumView * numView;
    UIButton *surebutton;
}
- (IBAction)backAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)showShopCar:(UIButton *)sender;
- (IBAction)AddToShopCar:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int shopid;
@end
