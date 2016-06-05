//
//  LYHotsCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotsCollectionViewCell.h"
#import "HomeBarCollectionViewCell.h"
#import "JiuBaModel.h"

@interface LYHotsCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{

}

@end

@implementation LYHotsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _collectViewInside.dataSource = self;
    _collectViewInside.delegate = self;
    [_collectViewInside registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
    _collectViewInside.contentInset = UIEdgeInsetsMake(90, 0, 0, 0);
    
}


- (void)setJiubaArray:(NSArray *)jiubaArray{
    _jiubaArray = jiubaArray;
    [_collectViewInside reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    NSArray *array = _dataArray[collectionView.tag];
    //    return array.count;
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
     HomeBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
    //    cell.layer.cornerRadius = 2;
    //    cell.layer.masksToBounds = YES;
//        JiuBaModel *jiubaM = _jiubaArray[indexPath.item];
//        cell.jiuBaM = jiubaM;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBarCollectionViewCell *cell2=(HomeBarCollectionViewCell *)cell;
            JiuBaModel *jiubaM = _jiubaArray[indexPath.item];
            cell2.jiuBaM = jiubaM;



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
}

@end
