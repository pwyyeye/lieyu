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
    self.sendGiftButton.layer.cornerRadius = 3.f;
    self.sendGiftButton.layer.masksToBounds = YES;
}

-(void)setupSubviews{
    _memony = 888;
    self.giftCollectionView.backgroundColor = [UIColor whiteColor];
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"DaShangViewCell" bundle:nil] forCellWithReuseIdentifier:daShangCellID];
    _dataArr = @[@{@"giftIamge":@"moreRose.png",@"giftName":@"玫瑰",@"giftValue":@"520娱币"},
                 @{@"giftIamge":@"ring.png",@"giftName":@"钻戒",@"giftValue":@"8888娱币"},
                 @{@"giftIamge":@"champagne.png",@"giftName":@"香槟",@"giftValue":@"680娱币"},
                 @{@"giftIamge":@"car.png",@"giftName":@"跑车",@"giftValue":@"88888娱币"},
                 @{@"giftIamge":@"lafei.png",@"giftName":@"拉菲",@"giftValue":@"1280娱币"},
                 @{@"giftIamge":@"ship.png",@"giftName":@"游艇",@"giftValue":@"131400娱币"},
                 @{@"giftIamge":@"huangjia.png",@"giftName":@"皇家礼炮",@"giftValue":@"1880娱币"},
                 @{@"giftIamge":@"house.png",@"giftName":@"别墅",@"giftValue":@"334400娱币"},
                 @{@"giftIamge":@"rose.png",@"giftName":@"玫瑰花",@"giftValue":@"10娱币"},
                 @{@"giftIamge":@"gold.png",@"giftName":@"元宝",@"giftValue":@"2500娱币"},
                 @{@"giftIamge":@"biantai.png",@"giftName":@"风油精",@"giftValue":@"50娱币"},
                 @{@"giftIamge":@"apple.png",@"giftName":@"Iphone10",@"giftValue":@"6666娱币"},
                 @{@"giftIamge":@"book.png",@"giftName":@"金瓶梅",@"giftValue":@"100娱币"},
                 @{@"giftIamge":@"watch.png",@"giftName":@"百达翡丽",@"giftValue":@"39999娱币"},
                 @{@"giftIamge":@"chicken.png",@"giftName":@"烤鸡",@"giftValue":@"200娱币"},
                 @{@"giftIamge":@"airport.png",@"giftName":@"私人飞机",@"giftValue":@"222222娱币"}
                 ];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:daShangCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *giftDic = _dataArr[indexPath.row];
    cell.giftImageView.image = [UIImage imageNamed:giftDic[@"giftIamge"]];
    cell.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.giftImageView.userInteractionEnabled = YES;
    cell.giftNameLabel.text = giftDic[@"giftName"];
    cell.YuBiLabel.text = giftDic[@"giftValue"];
    cell.DSChooseImage.hidden = YES;
    
    _giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _giftButton.frame = cell.bounds;
    _giftButton.backgroundColor = [UIColor clearColor];
    _giftButton.tag = indexPath.row;
    [_giftButton addTarget:self action:@selector(giftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell addSubview:_giftButton];
    return cell;
    
}

-(void)giftButtonAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    DaShangViewCell *cellNew = (DaShangViewCell *)[sender superview];
    if (cellNew.DSChooseImage.hidden) {
        cellNew.DSChooseImage.hidden = NO;
    } else {
        cellNew.DSChooseImage.hidden = YES;
    }
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 4 - 10 , 90);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//直播界面不执行方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.DSChooseImage.hidden = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    DaShangViewCell *cell = (DaShangViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.DSChooseImage.hidden = YES;
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
