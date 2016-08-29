//
//  ZSBirthdayManagerViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ZSBirthdayManagerViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *todayBirthdayWishList;

@end
