//
//  ChanPinListViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol ZSAddChanPinDelegate<NSObject>
- (void)addChanPin:(NSMutableArray *)arr;

@end
@interface ChanPinListViewController : LYBaseViewController{
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)sureAct:(UIButton *)sender;
@property (nonatomic, weak) id <ZSAddChanPinDelegate> delegate;
@end
