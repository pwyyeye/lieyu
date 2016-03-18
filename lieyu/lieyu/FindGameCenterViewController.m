
//
//  FindGameCenterViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindGameCenterViewController.h"
#import "FindGameCenterCollectionViewCell.h"
#import "GameList.h"
#import "LYHomePageHttpTool.h"
#import "GamePlayViewController.h"
#define FINDGAMENAME_MTA @"FINDGAMENAME"

@interface FindGameCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_titleArray,*_gameListArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FindGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"娱乐宝典";
    _titleArray = @[@"咬手鲨鱼牙",@"真心话大冒险",@"大话骰"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FindGameCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FindGameCenterCollectionViewCell"];
    [self getData];
}

- (void)getData{
//    NSDictionary *paraDic =
    __weak __typeof(self) weakSelf = self;
    [LYHomePageHttpTool getGameFromWith:nil complete:^(NSArray *gameListArray) {
        _gameListArray = gameListArray;
        [weakSelf.collectionView reloadData];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _gameListArray.count;
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
    GameList *gList = _gameListArray[indexPath.row];
    cell.label_title.text = gList.gameName;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:gList.gameIcon] placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
    if (indexPath.row % 2 != 0) {
        cell.lineView_right.hidden = YES;
    }else{
        cell.lineView_right.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_gameListArray.count <= indexPath.item) return;
    GameList *gList = _gameListArray[indexPath.item];
    GamePlayViewController *gamePlayVC = [[GamePlayViewController alloc]init];
    gamePlayVC.gameLink = gList.gameLink;
    [self presentViewController:gamePlayVC animated:YES completion:nil];
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:FINDGAMENAME_MTA titleName:gList.gameName]];
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
