//
//  LYMyFriendViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/28.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
@interface LYMyFriendViewController : LYBaseViewController
<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
    UIView  *_bgView;
    LYZSeditView *seditView;
    UIBarButtonItem *rightBtn;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSString *vipUserid;

@property (nonatomic, strong) UILabel *redTip;
@property (nonatomic, assign) int tipNum;
@property (nonatomic, assign) BOOL isOpen;

@end
