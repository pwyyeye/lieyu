//
//  LYFriendsChooseLocationViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"

@protocol PullLocationInfo <NSObject>

- (void)getLocationInfo:(NSString *)city Location:(NSString *)location;

@end

@interface LYFriendsChooseLocationViewController : LYBaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id<PullLocationInfo> delegate;
@end
