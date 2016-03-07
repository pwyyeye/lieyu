
//
//  FindGameCenterViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindGameCenterViewController.h"
#import "FindGameCenterCollectionViewCell.h"

@interface FindGameCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_titleArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FindGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"酒吧小游戏";
    _titleArray = @[@"咬手鲨鱼牙",@"真心话大冒险",@"大话骰"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FindGameCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FindGameCenterCollectionViewCell"];
    
//    UIScreenEdgePanGestureRecognizer *ges = self.view.gestureRecognizers;
    NSLog(@"--------->%@",self.view.gestureRecognizers);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/3.f, SCREEN_WIDTH/3.f * 155/125.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FindGameCenterCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"FindGameCenterCollectionViewCell" forIndexPath:indexPath];
    cell.label_title.text = _titleArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:_titleArray[indexPath.row]];
    if (indexPath.row % 2 != 0) {
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
