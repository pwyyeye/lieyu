//
//  LYGuWenListViewController.h
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarsViewController.h"
#import "LYGuWenDetailViewController.h"


@interface LYGuWenListViewController : LYHotBarsViewController

@property (nonatomic, assign) NSInteger filterSortFlag;//
@property (nonatomic, assign) NSInteger filterSexFlag;//2
@property (nonatomic, assign) NSInteger filterAreaFlag;//0

@property (nonatomic, strong) NSString *cityName;

@end
