//
//  LYFriendsToUserMessageViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "EmojisView.h"
@interface LYFriendsToUserMessageViewController : LYBaseViewController<emojiClickDelegate>
{
      NSString *_useridStr;
    NSMutableArray *_dataArray;
}
@property (nonatomic,copy) NSString *friendsId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)getData;
- (void)reloadTableViewAndSetUpProperty;
- (void)addTableViewHeader;
- (void)setupTableViewFresh;
#pragma mark - 点击动态中话题文字
- (void)topicNameClick:(UIButton *)button;
#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index;
#pragma mark - 动态头像点击
- (void)messageHeaderImgClick:(UIButton *)button;
@end
