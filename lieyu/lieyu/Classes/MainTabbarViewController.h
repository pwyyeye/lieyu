//
//  MainTabbarViewController.h
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYUserHttpTool.h"
#import "LYUserLoginViewController.h"

@interface MainTabbarViewController: UITabBarController<LoginDelegate>

@property(assign,nonatomic) NSInteger lastSelectIndex;

@end
