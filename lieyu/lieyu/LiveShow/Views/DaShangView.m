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

@interface DaShangView ()

@property (nonatomic, strong) UIImage *chooseImage;

@end

@implementation DaShangView 


- (void)drawRect:(CGRect)rect {
    if (_type == textType_Live) {
        _chooseImage = [UIImage imageNamed:@""];
    } else {
        _chooseImage = [UIImage imageNamed:@""];
        CGFloat x = CGRectGetMidX(self.superview.frame) - SCREEN_WIDTH / 30;
        CGFloat y = _sendGiftButton.center.y;
        _sendGiftButton.center = CGPointMake(x, y);
    }
    self.sendGiftButton.layer.cornerRadius = self.sendGiftButton.frame.size.height / 2;
    self.sendGiftButton.layer.masksToBounds = YES;
}

-(void) layoutSubviews{
    [self setupSubviews];
    
    self.sendGiftButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.sendGiftButton.layer.borderWidth = 1.f;
}

-(void)setupSubviews{
    _number = 0;
    _chooseTag = 10;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width / 4, (self.frame.size.height - 70) / 2);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.giftCollectionView  = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 70)) collectionViewLayout:flowLayout];
    self.giftCollectionView.backgroundColor = [UIColor clearColor];
    self.giftCollectionView.pagingEnabled = YES;
    self.giftCollectionView.directionalLockEnabled = YES;
    self.giftCollectionView.showsHorizontalScrollIndicator = NO;
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    [self addSubview: self.giftCollectionView];
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
    
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = COMMON_PURPLE_HALF;
    _pageControl.currentPageIndicatorTintColor = COMMON_PURPLE;
    CGFloat w = 50.f;
    CGFloat h = 23.f;
    CGFloat x;
    if (_type == textType_Live) {
        x = self.superview.center.x-25.f;
    } else {
        x = self.superview.center.x-25.f - SCREEN_WIDTH /30;
    }
    CGFloat y = self.frame.size.height - 67.f;
    _pageControl.frame = CGRectMake(x, y, w, h);
    [self addSubview:_pageControl];
    
    [_sendGiftButton setTitle:@"赏" forState:(UIControlStateNormal)];
    [_sendGiftButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    CGFloat w_1 = 65.f;
    CGFloat h_1 = 28.f;
    CGFloat x_1 = self.frame.size.width - 75.f;
    CGFloat y_1 = self.frame.size.height - 47.f;
    _sendGiftButton.frame = CGRectMake(x_1, y_1, w_1, h_1);
    [self addSubview:_sendGiftButton];
    
    [self.timeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.timeButton setTitle:@"30" forState:(UIControlStateNormal)];
    [self.timeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    CGFloat x_2 = self.frame.size.width - 50;
    CGFloat y_2 = self.frame.size.height - 50;
    self.timeButton.frame = CGRectMake(x_2, y_2, 45, 45);
    self.timeButton.layer.cornerRadius = 22.5;
    self.timeButton.layer.masksToBounds = YES;
    self.timeButton.hidden = YES;
    [self addSubview:self.timeButton];
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
    cell.YuBiLabel.textColor = [UIColor darkGrayColor];
    if (_type == textType_Live) {
        cell.giftNameLabel.textColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.layer.borderWidth = 0.3f;
        [cell.layer addSublayer:[self shadowAsInverse]];
    } else {
        cell.giftNameLabel.textColor = [UIColor blackColor];
    }
//    NSMutableString *text = [NSMutableString stringWithFormat:@"%ld", (long)model.rewardValue];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(227, 207, 87) range:NSMakeRange(0, userName.length + 1)];
//    self.textLabel.attributedText = AttributedStr;
    return cell;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 4, (self.frame.size.height - 70) / 2);
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0.f;
//}


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


//
- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    CGRect newGradientLayerFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.frame = newGradientLayerFrame;
    
    //添加渐变的颜色组合
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0]CGColor],
                            (id)[[[UIColor blackColor] colorWithAlphaComponent:0.1]CGColor],
                            (id)[[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor],
                            (id)[[UIColor blackColor] CGColor],
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:0.4],
                               [NSNumber numberWithFloat:0.9],
                               nil];
    
    gradientLayer.startPoint = CGPointMake(1,0);
    gradientLayer.endPoint = CGPointMake(0,1);
    return gradientLayer;
}

@end
