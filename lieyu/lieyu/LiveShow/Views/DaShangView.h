//
//  DaShangView.h
//  lieyu
//
//  Created by 狼族 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, textType) {
    textType_Moment  = 0,
    textType_Live     = 1,
};
@interface DaShangView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UIButton *closeButton;
@property (strong, nonatomic)  UICollectionView *giftCollectionView;
@property (strong, nonatomic)  UIButton *sendGiftButton;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *timeButton;//倒计时

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger chooseTag;
@property (assign, nonatomic) NSInteger number;

@property (nonatomic, assign) textType type;

@end
