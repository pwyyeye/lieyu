//
//  LYHotsCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeCollectionViewCell.h"
#import "HomeBarCollectionViewCell.h"
#import "JiuBaModel.h"
#import "SDCycleScrollView.h"
#import "HomeMenusCollectionViewCell.h"
#import "UIButton+WebCache.h"

@interface LYHomeCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
}

@end

@implementation LYHomeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    _collectViewInside.dataSource = self;
//    _collectViewInside.delegate = self;
//    [_collectViewInside registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
//    [_collectViewInside registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [_collectViewInside registerNib:[UINib nibWithNibName:@"HomeMenusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenusCollectionViewCell"];
//    _collectViewInside.contentInset = UIEdgeInsetsMake(90, 0, 0, 0);
    
}


- (void)setJiubaArray:(NSArray *)jiubaArray{
    _jiubaArray = jiubaArray;
    
}
/*
- (void)setBannerList:(NSArray *)bannerList{
    _bannerList = bannerList;
    [_collectViewInside reloadData];
}

- (void)setRecommendedBar:(JiuBaModel *)recommendedBar{
    _recommendedBar = recommendedBar;
    [_collectViewInside reloadData];
}

- (void)setFiterArray:(NSArray *)fiterArray{
    _fiterArray = fiterArray;
    [_collectViewInside reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _jiubaArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 /16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.item) {
        case 0:
        {
            UICollectionViewCell *cell = [_collectViewInside dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, ((SCREEN_WIDTH - 6) * 9) / 16) delegate:self placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
            cycleScrollView.layer.cornerRadius = 2;
            cycleScrollView.layer.masksToBounds = YES;
            cycleScrollView.imageURLStringsGroup = self.bannerList;
            cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_s"];
            cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_us"];
            [cell addSubview:cycleScrollView];
            return cell;
        }
            break;
        case 1:
        {
            HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
            if(_recommendedBar){
                jiubaCell.jiuBaM = _recommendedBar;
            }
            return jiubaCell;
        }
            break;
        case 2://才当
        {
            HomeMenusCollectionViewCell *menucell = [collectionView dequeueReusableCellWithReuseIdentifier:@
                                                     "HomeMenusCollectionViewCell"forIndexPath:indexPath];
            for (int i = 0;i < 4;i++) {
                UIButton *btn = menucell.btnArray[i];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:_fiterArray[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(menusClickCell:) forControlEvents:UIControlEventTouchUpInside];
            }
            return menucell;
        }
            break;
        case 3:
        {
            HomeBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
            JiuBaModel *jiubaM = _jiubaArray[indexPath.item];
            cell.jiuBaM = jiubaM;
            return cell;
        }
            break;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_jiubaArray.count) {
        if (_jiubaArray.count) {
            JiuBaModel *jiuM = _jiubaArray[indexPath.item];
            if ([_delegate respondsToSelector:@selector(hotsCollectionViewCellClickWithJiubaModel:)]) {
                [_delegate hotsCollectionViewCellClickWithJiubaModel:jiuM];
            }
            // [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
        }
    }
} */

@end
