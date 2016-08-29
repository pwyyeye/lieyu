//
//  MineGroupViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface MineGroupViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *introButton;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupBriefLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
