//
//  ChiHeViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaiXuanBtn.h"
#import "chiheDetailCollectionCell.h"
#import "chiheDetailCollectionCell.h"
#import "LYBaseViewController.h"

@interface ChiHeViewController : LYBaseViewController<RefreshGoodsNum>

@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn1;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn2;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn3;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn4;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn5;

@property (assign, nonatomic) int barid;
@property (copy, nonatomic) NSString *barName;

@property (nonatomic,strong) NSMutableDictionary *nowDic;
@property (nonatomic,unsafe_unretained) int pageCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)sxBtnClick:(ShaiXuanBtn *)sender;


@end
