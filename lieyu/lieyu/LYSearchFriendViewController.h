//
//  LYSearchFriendViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface LYSearchFriendViewController : LYBaseViewController<UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@end
