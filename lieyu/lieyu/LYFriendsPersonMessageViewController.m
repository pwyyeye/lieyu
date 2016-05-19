//
//  LYFriendsPersonMessageViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsPersonMessageViewController.h"


@interface LYFriendsPersonMessageViewController ()

@end

@implementation LYFriendsPersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友动态";
    self.pageNum = 1;
}

#pragma mark - 获取最新玩友圈数据
- (void)getDataWithType:(dataType)type{
    UITableView *tableView = nil;
    __block int pageStartCount;
    if (type == dataForFriendsMessage) {
        pageStartCount = _pageStartCountArray[0];
        tableView = _tableViewArray.firstObject;
    }else if(type == dataForMine){
        pageStartCount = _pageStartCountArray[1];
        tableView = [_tableViewArray objectAtIndex:1];
    }
    NSString *startStr = [NSString stringWithFormat:@"%d",pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%d",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_friendsId};
    __weak __typeof(self) weakSelf = self;
    if (type == dataForFriendsMessage) {
        __weak __typeof(self) weakSelf = self;
        [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic needLoading:YES compelte:^(FriendsUserInfoModel*userInfo, NSMutableArray *dataArray) {
            _userBgImageUrl = userInfo.friends_img;
            weakSelf.userM = userInfo;
            [weakSelf loadDataWith:tableView dataArray:dataArray pageStartCount:pageStartCount type:type];
            [weakSelf addTableViewHeader];
        }];
    }
}

#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage{
    
}

#pragma mark - 话题
- (void)addTableViewHeaderViewForTopic{
    
}

#pragma mark - 配置导航
- (void)setupMenuView{};

#pragma mark - 配置发布按钮
- (void)setupCarmerBtn{};

#pragma mark - 添加表头
- (void)addTableViewHeader{
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    _headerView.btn_newMessage.hidden = YES;
    _headerView.imageView_NewMessageIcon.hidden = YES;
    [self setupTableForHeaderForMinPage];//为我的界面添加表头
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
