//
//  LYTagsViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/22.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagsViewController.h"
#import "LYTagCollectionViewCell.h"
#import "UserTagModel.h"
#import "LYUserHttpTool.h"

@interface LYTagsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSArray *_dataArray;
    UserTagModel *_tagModel;
    NSInteger _indexItem;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end
static NSString *cellIdentifier = @"cell";
@implementation LYTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_collectionView registerClass:[LYTagCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSure)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self getData];
}

- (void)getData{
    [[LYUserHttpTool shareInstance] getUserTags:nil block:^(NSMutableArray *result) {
        _dataArray = result;
        [self.collectionView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 32);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYTagCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UserTagModel *tagM = _dataArray[indexPath.row];
    UserTagModel *selectedTagM;
    if (_selectedTag.length) {
        selectedTagM.tagname = _selectedTag;
    }
    [cell deployCellWith:tagM selectedTagM:selectedTagM];
//    NSLog(@"--->%@----->%@",tagM.name,selectedTagM.tagname);
    if ([_selectedTag isEqualToString:tagM.name]) {
        cell.selected = YES;
        _indexItem = indexPath.item;
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    LYTagCollectionViewCell *cell = (LYTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LYTagCollectionViewCell *cell = (LYTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    UserTagModel *mod = _dataArray[indexPath.item];
    _tagModel = mod;
    
    if(_indexItem >= 0){
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:_indexItem inSection:0];
        LYTagCollectionViewCell *desCell = (LYTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexP];
        desCell.selected = NO;
        _indexItem = -1;
    }
}

-(void)makeSure{
    if (_tagModel) {
        if ([self.delegate respondsToSelector:@selector(userTagSelected:)]) {
            [self.delegate userTagSelected:_tagModel];

        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
