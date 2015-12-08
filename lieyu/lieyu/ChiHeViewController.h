//
//  ChiHeViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaiXuanBtn.h"

@interface ChiHeViewController : UIViewController

@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn1;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn2;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn3;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn4;
@property (weak, nonatomic) IBOutlet ShaiXuanBtn *sxBtn5;

@property (assign, nonatomic) int barid;
@property (copy, nonatomic) NSString *barName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)sxBtnClick:(ShaiXuanBtn *)sender;


@end
