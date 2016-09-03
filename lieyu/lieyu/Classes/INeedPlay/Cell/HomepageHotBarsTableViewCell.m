//
//  HomepageHotBarsTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomepageHotBarsTableViewCell.h"
#import "HomePageCollectionViewCell.h"
#import "JiuBaModel.h"
#import "BeerNewBarViewController.h"

@interface HomepageHotBarsTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@end

@implementation HomepageHotBarsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    _shadowView.layer.shadowOpacity = 0.3;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBarList:(NSArray *)barList{
    _barList = barList;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomePageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HomePageCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _barList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCollectionViewCell" forIndexPath:indexPath];
    JiuBaModel *model = [_barList objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(295, 252);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *model = [_barList objectAtIndex:indexPath.section];
    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
    if(!model.barid) return;
    controller.beerBarId = @(model.barid);
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [app.navigationController pushViewController:controller animated:YES];
}

@end
