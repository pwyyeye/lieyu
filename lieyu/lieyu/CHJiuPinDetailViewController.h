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
#import "chiheDetailCollectionCell.h"

@interface CHJiuPinDetailViewController : LYBaseViewController<RefreshGoodsNum>
{
    UIView  *_bgView;
    CHChooseNumView * numView;
    UIButton *surebutton;
}
- (IBAction)backAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)showShopCar:(UIButton *)sender;//进入购物车
- (IBAction)AddToShopCar:(UIButton *)sender;//加入购物车
- (IBAction)LYkefu:(UIButton *)sender;//猎娱客服
- (IBAction)buyNow:(UIButton *)sender;//立即下单


@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (nonatomic, assign) id<RefreshGoodsNum> refreshNumDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int shopid;
@end
