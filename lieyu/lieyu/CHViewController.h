//
//  CHViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaiXuanBtn.h"
#import "LYBaseViewController.h"

@interface CHViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *itemButton1;
@property (weak, nonatomic) IBOutlet UIButton *itemButton2;
@property (weak, nonatomic) IBOutlet UIButton *itemButton3;
@property (weak, nonatomic) IBOutlet UIButton *itemButton4;
@property (weak, nonatomic) IBOutlet UIButton *itemButton5;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (assign, nonatomic) int barid;
@property (copy, nonatomic) NSString *barName;


@end
