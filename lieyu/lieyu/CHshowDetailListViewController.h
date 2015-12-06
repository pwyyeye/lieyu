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
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *itemButton1;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *itemButton2;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *itemButton3;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *itemButton4;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *itemButton5;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;


@property (assign, nonatomic) int barid;
@property (copy, nonatomic) NSString *barName;
@end
