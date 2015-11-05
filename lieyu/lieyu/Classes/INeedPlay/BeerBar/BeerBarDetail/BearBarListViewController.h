//
//  BearBarListViewController.h
//  lieyu
//
//  Created by newfly on 9/26/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageEntryConstant.h"
#import "LYBaseViewController.h"

@interface BearBarListViewController :LYBaseViewController

@property(nonatomic,assign)BaseEntry entryType;
@property(nonatomic,copy)NSString *cityStr;
@end
