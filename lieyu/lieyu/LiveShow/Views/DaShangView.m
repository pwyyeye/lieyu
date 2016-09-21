//
//  DaShangView.m
//  lieyu
//
//  Created by 狼族 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DaShangView.h"
#import "DaShangViewCell.h"

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
    _chooseTag = 6666;
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    self.giftCollectionView.backgroundColor = [UIColor clearColor];
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"DaShangViewCell" bundle:nil] forCellWithReuseIdentifier:daShangCellID];
    _dataArr = @[@{@"giftIamge":@"rose.png",@"giftName":@"玫瑰花",@"giftValue":@"10娱币"},
                 @{@"giftIamge":@"gold.png",@"giftName":@"元宝",@"giftValue":@"2500娱币"},
                 @{@"giftIamge":@"biantai.png",@"giftName":@"风油精",@"giftValue":@"50娱币"},
                 @{@"giftIamge":@"apple.png",@"giftName":@"Iphone10",@"giftValue":@"6666娱币"},
                 @{@"giftIamge":@"book.png",@"giftName":@"金瓶梅",@"giftValue":@"100娱币"},
                 @{@"giftIamge":@"watch.png",@"giftName":@"百达翡丽",@"giftValue":@"39999娱币"},
                 @{@"giftIamge":@"chicken.png",@"giftName":@"烤鸡",@"giftValue":@"200娱币"},
                 @{@"giftIamge":@"airport.png",@"giftName":@"私人飞机",@"giftValue":@"222222娱币"},
  @{@"giftIamge":@"moreRose.png",@"giftName":@"玫瑰",@"giftValue":@"520娱币"},
                 @{@"giftIamge":@"ring.png",@"giftName":@"钻戒",@"giftValue":@"8888娱币"},
                 @{@"giftIamge":@"champagne.png",@"giftName":@"香槟",@"giftValue":@"680娱币"},
                 @{@"giftIamge":@"car.png",@"giftName":@"跑车",@"giftValue":@"88888娱币"},
                 @{@"giftIamge":@"lafei.png",@"giftName":@"拉菲",@"giftValue":@"1280娱币"},
                 @{@"giftIamge":@"ship.png",@"giftName":@"游艇",@"giftValue":@"131400娱币"},
                 @{@"giftIamge":@"huangjia.png",@"giftName":@"皇家礼炮",@"giftValue":@"1880娱币"},
                 @{@"giftIamge":@"house.png",@"giftName":@"别墅",@"giftValue":@"334400娱币"}
                 ];
    dispatch_async(dispatch_get_main_queue(), ^{
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"sendGift" object:nil userInfo:@{@"value":@"6666"}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    });
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:daShangCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *giftDic = _dataArr[indexPath.row];
    cell.giftImageView.image = [UIImage imageNamed:giftDic[@"giftIamge"]];
    cell.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.giftImageView.userInteractionEnabled = YES;
    cell.giftNameLabel.text = giftDic[@"giftName"];
    cell.YuBiLabel.text = giftDic[@"giftValue"];
    if (indexPath.row == 3) {
        cell.DSChooseImage.hidden = NO;
    } else {
        cell.DSChooseImage.hidden = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    _giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _giftButton.frame = cell.bounds;
    _giftButton.backgroundColor = [UIColor clearColor];
    _giftButton.tag = [giftDic[@"giftValue"] integerValue];
//    [_giftButton addTarget:self action:@selector(giftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [cell addSubview:_giftButton];
    if (_type == textTypeWhite) {
        cell.giftNameLabel.textColor = [UIColor whiteColor];
        cell.YuBiLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)giftButtonAction:(UIButton *)sender{
    DaShangViewCell *cellNew = (DaShangViewCell *)[sender superview];
    if (cellNew.DSChooseImage.hidden) {
        cellNew.DSChooseImage.hidden = NO;
        if (_chooseTag == sender.tag) {
            
        } else {
            DaShangViewCell *cellOld = (DaShangViewCell *)[_giftCollectionView viewWithTag:_chooseTag];
            cellOld.DSChooseImage.hidden = YES;
            _chooseTag = sender.tag;
        }
//        ++_number;
    } else {
//        cellNew.DSChooseImage.hidden = YES;
//        --_number;
    }
    NSString *value = [NSString stringWithFormat:@"%ld", sender.tag];
    NSString *number = [NSString stringWithFormat:@"%ld", _number];
    dispatch_async(dispatch_get_main_queue(), ^{
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"sendGift" object:nil userInfo:@{@"value":value,@"number":number}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    });
    
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
    if (indexPath.row != 3) {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:3 inSection:0];
        DaShangViewCell *cell_old = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:temp];
        cell_old.DSChooseImage.hidden = YES;
    }
    NSDictionary *giftDic = _dataArr[indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"sendGift" object:nil userInfo:@{@"value":giftDic[@"giftValue"]}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    });
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.DSChooseImage.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView  == self.giftCollectionView) {
        NSInteger pageInt = scrollView.contentOffset.x / scrollView.frame.size.width;
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
