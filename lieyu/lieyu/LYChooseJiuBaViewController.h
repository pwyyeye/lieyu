//
//  LYChooseJiuBaViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "JiuBaModel.h"
@protocol LYChooseJiuBaDelegate<NSObject>
- (void)chooseJiuBa:(JiuBaModel *)jiuBaModel;

@end
@interface LYChooseJiuBaViewController : LYBaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) id <LYChooseJiuBaDelegate> delegate;
@end
