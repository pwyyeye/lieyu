//
//  DaShangView.h
//  lieyu
//
//  Created by 狼族 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaShangView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *sendGiftButton;

@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic) UIButton *giftButton;
@property (assign, nonatomic) int memony;

@end
