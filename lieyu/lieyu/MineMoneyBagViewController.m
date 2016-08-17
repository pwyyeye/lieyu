//
//  MineMoneyBagViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineMoneyBagViewController.h"
#import "MineMoneyBagCollectionViewCell.h"
#import "MineYubiViewController.h"
#import "MineBalanceViewController.h"

#define IDENTIFIER @"MineMoneyBagCollectionViewCell"

@interface MineMoneyBagViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *_dataArray;
}
@end

@implementation MineMoneyBagViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _dataArray = @[@{@"title":@"娱币商城",@"image":@"shopIcon"},
                   @{@"title":@"猎娱VIP",@"image":@"VIPIcon@3x"}];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MineMoneyBagCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MineMoneyBagCollectionViewCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
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
    }else if (indexPath.section == 0 && indexPath.item == 1){
        //进入猎娱VIP
    }
}

#pragma mark - 按钮事件
- (IBAction)balanceClick:(UIButton *)sender {
    MineBalanceViewController *mineBalanceVC = [[MineBalanceViewController alloc]initWithNibName:@"MineBalanceViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:mineBalanceVC animated:YES];
}

- (IBAction)yubiClick:(UIButton *)sender {
    MineYubiViewController *mineYubiVC = [[MineYubiViewController alloc]initWithNibName:@"MineYubiViewController" bundle:nil];
    [self.navigationController pushViewController:mineYubiVC animated:YES];
}
@end
