//
//  DaShangView.m
//  lieyu
//
//  Created by 狼族 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DaShangView.h"
#import "DaShangViewCell.h"
#import "LYFriendsHttpTool.h"
#import "DaShangGiftModel.h"

static NSString *daShangCellID = @"dashangCellID";

@implementation DaShangView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) layoutSubviews{
    [self setupSubviews];
    self.sendGiftButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.sendGiftButton.layer.borderWidth = 1.f;
}

-(void)setupSubviews{
    _number = 0;
    _chooseTag = 10;
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    self.giftCollectionView.backgroundColor = [UIColor clearColor];
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"DaShangViewCell" bundle:nil] forCellWithReuseIdentifier:daShangCellID];
    _dataArr = [NSMutableArray arrayWithCapacity:100];
    [LYFriendsHttpTool getDaShangListParms:nil complete:^(NSArray *giftArray) {
        _dataArr = [NSMutableArray arrayWithArray:giftArray];
        [self.giftCollectionView reloadData];
        DaShangGiftModel *model = _dataArr[0];
        NSString *reward = [NSString stringWithFormat:@"%ld",model.rewardValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"sendGift" object:nil userInfo:@{@"value":reward,@"image":model.rewardImg,@"gifType":model.rewordType,@"giftName":model.rewardName}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        });
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:daShangCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    DaShangGiftModel *model = _dataArr[indexPath.row];
    [cell.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.rewardImg]];
    cell.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.giftImageView.userInteractionEnabled = YES;
    cell.giftNameLabel.text = model.rewardName;
    cell.YuBiLabel.text = [NSString stringWithFormat:@"%ld娱币", (long)model.rewardValue];
    if (indexPath.row == 0) {
        cell.DSChooseImage.hidden = NO;
    } else {
        cell.DSChooseImage.hidden = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    _giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _giftButton.frame = cell.bounds;
    _giftButton.backgroundColor = [UIColor clearColor];
    _giftButton.tag = model.rewardValue;
    if (_type == textTypeWhite) {
        cell.giftNameLabel.textColor = [UIColor whiteColor];
        cell.YuBiLabel.textColor = [UIColor whiteColor];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return cell;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 4 - 10 , self.frame.size.height / 3 - 10);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.DSChooseImage.hidden) {
        cell.DSChooseImage.hidden = NO;
    }
    if (indexPath.row != 0) {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:0];
        DaShangViewCell *cell_old = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:temp];
        cell_old.DSChooseImage.hidden = YES;
    }
    DaShangGiftModel *model = _dataArr[indexPath.row];
    NSString *reward = [NSString stringWithFormat:@"%ld",model.rewardValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"sendGift" object:nil userInfo:@{@"value":reward,@"image":model.rewardImg,@"gifType":model.rewordType,@"giftName":model.rewardName}];
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    });
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.DSChooseImage.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView  == self.giftCollectionView) {
        NSInteger pageInt = scrollView.contentOffset.x / scrollView.frame.size.width <= 0 ? 0 : 1;
        _pageControl.currentPage = pageInt;
    }
}

//获取控制器
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
