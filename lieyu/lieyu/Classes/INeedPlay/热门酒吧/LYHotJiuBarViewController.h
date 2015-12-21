//
//  LYHotJiuBarViewController.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageEntryConstant.h"
#import "LYBaseViewController.h"

@interface LYHotJiuBarViewController : LYBaseViewController
@property(nonatomic,assign)BaseEntry entryType;
@property(nonatomic,copy) NSMutableArray *titleArray;
@property (nonatomic,copy) NSString *middleStr;
@property (nonatomic,strong) NSArray *bartypeArray;
@property (nonatomic,copy) NSString *subidStr;
@end
