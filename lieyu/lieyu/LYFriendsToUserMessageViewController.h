//
//  LYFriendsToUserMessageViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYFriendsToUserMessageViewController : LYBaseViewController{
      NSString *_useridStr;
    NSMutableArray *_dataArray;
}
@property (nonatomic,copy) NSString *friendsId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)getData;
- (void)reloadTableViewAndSetUpProperty;
- (void)addTableViewHeader;
- (void)setupTableViewFresh;
@end
