//
//  LYAddFriendByAddressBookViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYAddFriendByAddressBookViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) BOOL isBirthday;

@end
