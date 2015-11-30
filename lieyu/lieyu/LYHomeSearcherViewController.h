//
//  LYHomeSearcherViewController.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHomeSearcherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnHistoryArray;
@property (weak, nonatomic) IBOutlet UIButton *btnClearHistory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
