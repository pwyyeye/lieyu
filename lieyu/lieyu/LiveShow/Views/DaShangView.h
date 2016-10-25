//
//  DaShangView.h
//  lieyu
//
//  Created by 狼族 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, textType) {
    textTypeBlack  = 0,
    textTypeWhite     = 1,
};
@interface DaShangView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *sendGiftButton;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UIButton *giftButton;
@property (assign, nonatomic) NSInteger chooseTag;
@property (assign, nonatomic) NSInteger number;

@property (nonatomic, assign) textType type;

@end
