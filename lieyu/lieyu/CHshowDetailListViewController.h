//
//  CHshowDetailListViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "ShaiXuanBtn.h"
@interface CHshowDetailListViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *btnItem4;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *btnItem5;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *btnItem3;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *btnItem2;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *btnItem1;
- (IBAction)change:(ShaiXuanBtn *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) int barid;
@property (copy, nonatomic) NSString *barName;
@end
