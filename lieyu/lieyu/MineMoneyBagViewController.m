//
//  MineMoneyBagViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineMoneyBagViewController.h"
#import "MineMoneyBagCollectionViewCell.h"
#import "MineYubiViewController.h"
#import "MineBalanceViewController.h"
#import "MineWithdrawListViewController.h"
#import "ZSTiXianRecordViewController.h"
#import "LYUserHttpTool.h"
#import "ZSBalance.h"

#define IDENTIFIER @"MineMoneyBagCollectionViewCell"

@interface MineMoneyBagViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MineYubiDelegate>
{
    NSArray *_dataArray;
}
@property (nonatomic, strong) ZSBalance *balanceModel;
@end

@implementation MineMoneyBagViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _dataArray = @[@{@"title":@"娱币商城",@"image":@"shopIcon"},
                   @{@"title":@"猎娱VIP",@"image":@"VIPIcon"}];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MineMoneyBagCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MineMoneyBagCollectionViewCell"];
}

- (void)getData{
    [LYUserHttpTool getMyMoneyBagBalanceAndCoinWithParams:nil complete:^(ZSBalance *balance) {
        _balanceModel = balance;
        [_balanceLabel setText:[NSString stringWithFormat:@"¥%@",_balanceModel.balances]];
        [_yubiLabel setText:[NSString stringWithFormat:@"%@娱币",_balanceModel.coin]];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    [self initRightItem];
    
    [self getData];
}

- (void)initRightItem{
    UIButton *listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [listButton setTitle:@"提现记录" forState:UIControlStateNormal];
    [listButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [listButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [listButton setTitleColor:NAVIGATIONBARTITLECOLOR forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(withdrawListClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)withdrawListClick:(UIButton *)button{
    //    MineWithdrawListViewController *mineWithdrawListVC = [[MineWithdrawListViewController alloc]init];
    ZSTiXianRecordViewController *mineWithdrawListVC = [[ZSTiXianRecordViewController alloc]init];
    [self.navigationController pushViewController:mineWithdrawListVC animated:YES];
}

#pragma mark - collectionview的代理事件
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineMoneyBagCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"MineMoneyBagCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.item];
    [cell setDict:dict];
    if (indexPath.item % 3 == 2) {
        cell.layerShadowRight.hidden = YES;
    }else{
        cell.layerShadowRight.hidden = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 3, 89);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.item == 0) {
        //进入娱币商城
        [MyUtil showPlaceMessage:@"娱币商城敬请期待！"];
    }else if (indexPath.section == 0 && indexPath.item == 1){
        //进入猎娱VIP
        [MyUtil showPlaceMessage:@"猎娱VIP敬请期待！"];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 按钮事件
- (IBAction)balanceClick:(UIButton *)sender {
    MineBalanceViewController *mineBalanceVC = [[MineBalanceViewController alloc]initWithNibName:@"MineBalanceViewController" bundle:[NSBundle mainBundle]];
    mineBalanceVC.balance = _balanceModel;
    [self.navigationController pushViewController:mineBalanceVC animated:YES];
}

- (IBAction)yubiClick:(UIButton *)sender {
    MineYubiViewController *mineYubiVC = [[MineYubiViewController alloc]initWithNibName:@"MineYubiViewController" bundle:nil];
    mineYubiVC.coinAmount = _balanceModel.coin;
    mineYubiVC.balance = _balanceModel.balances; 
    mineYubiVC.delegate = self;
    [self.navigationController pushViewController:mineYubiVC animated:YES];
}

- (void)MineYubiWithdrawDelegate:(double)amount{
    [self getData];
}

@end
