//
//  LYMyFriendLiveListViewController.m
//  lieyu
//
//  Created by 狼族 on 16/9/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFriendLiveListViewController.h"
#import "LiveShowListCell.h"
#import "LYFriendsHttpTool.h"
#import "WatchLiveShowViewController.h"

static NSString *liveShowListID = @"liveShowListID";

@interface LYMyFriendLiveListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mytableView;
    NSInteger _currentHotPage;
}

@property (nonatomic, strong) NSMutableArray *liveArray;
@end

@implementation LYMyFriendLiveListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = [NSString stringWithFormat:@"%@的直播列表",_userName];
    self.liveArray = [NSMutableArray arrayWithCapacity:2];
    [self setTableView];
    [self initMJFooterAndHeader];
    [self refreshData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _currentHotPage = 1 ;
    [_mytableView registerNib:[UINib nibWithNibName:@"LiveShowListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:liveShowListID];
}

#pragma mark -- 配置表
-(void)setTableView{
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
    _mytableView.dataSource = self;
    _mytableView.delegate = self;
    _mytableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView registerNib:[UINib nibWithNibName:@"LiveShowListCell" bundle:nil] forCellReuseIdentifier:liveShowListID];
    [self.view addSubview:_mytableView];
}

#pragma mark -- 配置刷新
- (void)initMJFooterAndHeader{
        __weak __typeof(self)weakSelf = self;
        _mytableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        MJRefreshGifHeader *header = (MJRefreshGifHeader *)_mytableView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        
        _mytableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            [weakSelf getMoreData];
        }];
        MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_mytableView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
}

- (void)refreshData{
    [_liveArray removeAllObjects];
    [self getDataWithUserID:_userID andPage:@"1"];
}

-(void)getMoreData{
    _currentHotPage ++;
    [self getDataWithUserID:_userID andPage:[NSString stringWithFormat:@"%ld",(long)_currentHotPage]];
}

#pragma mark --- 获取数据
-(void) getDataWithUserID: (NSString *)userID andPage:(NSString *)pages{
    NSDictionary *dictionary = @{@"cityCode":@"310000",@"livetype":@"",@"sort":@"",@"page":pages,@"userid":userID};
    [LYFriendsHttpTool getLiveShowlistWithParams:dictionary complete:^(NSArray *Arr) {
        if (Arr.count <= 0) {
            [_mytableView.mj_header endRefreshing];
            [_mytableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.liveArray addObjectsFromArray:Arr];
            [_mytableView.mj_footer endRefreshing];
            [_mytableView.mj_header endRefreshing];
        }
        [_mytableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liveArray.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LiveShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:liveShowListID forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[LiveShowListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:liveShowListID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    LiveShowListCell *cell = [_mytableView dequeueReusableCellWithIdentifier:liveShowListID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LYLiveShowListModel *model = [LYLiveShowListModel new];
    if (_liveArray.count > indexPath.row) {
        model = _liveArray[indexPath.row];
        cell.listModel = model;
    }
//    if ([_userID intValue] == self.userModel.userid) {
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 5 * 2 - 35, 50, 25)];
//        button.tag = indexPath.row;
//        [button addTarget:self action:@selector(deleteLiveRecord:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:@"删除" forState:UIControlStateNormal];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        button.titleLabel.shadowColor = RGBA(0, 0, 0, 1);
//        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
//        [cell addSubview:button];
//    }
    
//    [cell sendSubviewToBack:cell.backImageView];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT / 5 * 2;
//    return 50;
}

#pragma mark ---- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WatchLiveShowViewController *watchLiveVC = [[WatchLiveShowViewController alloc] init];
    LYLiveShowListModel *model = [LYLiveShowListModel new];
    model = _liveArray[indexPath.row];
    NSString *roomId = [NSString stringWithFormat:@"%d",model.roomId];
    NSDictionary *dict = @{@"roomid":roomId};
    __weak typeof(self) weakSelf = self;
    [LYFriendsHttpTool getLiveShowRoomWithParams:dict complete:^(NSDictionary *Arr) {
        if ([Arr[@"roomType"] isEqualToString:@"live"]) {
            watchLiveVC.contentURL = Arr[@"liveRtmpUrl"];
            watchLiveVC.chatRoomId = Arr[@"chatroomid"];
        } else {
            watchLiveVC.contentURL = Arr[@"playbackURL"];
            watchLiveVC.chatRoomId = nil;
        }
        watchLiveVC.hostUser = Arr[@"roomHostUser"];
        watchLiveVC.joinNum = [NSString stringWithFormat:@"%d",model.joinNum];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.roomImg]];
        watchLiveVC.shareIamge = [UIImage imageWithData:data];
        //        [weakSelf presentViewController:watchLiveVC animated:YES completion:NULL];
        [weakSelf.navigationController pushViewController:watchLiveVC animated:YES];
    }];
    
}

- (void)deleteLiveRecord:(UIButton *)button{
    [[[AlertBlock alloc]initWithTitle:nil message:@"确认删除该直播？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
        if ([_userID intValue] == self.userModel.userid && buttonIndex == 1) {
            //        editingStyle = UITableViewCellEditingStyleDelete;
            LYLiveShowListModel *model = [LYLiveShowListModel new];
            model = _liveArray[button.tag];
            NSDictionary *dict = @{@"roomid":[NSString stringWithFormat:@"%d",model.roomId]};
            __weak __typeof(self)weakSelf = self;
            [LYFriendsHttpTool deleteMyLiveRecord:dict complete:^(BOOL result) {
                if (result == YES) {
                    [weakSelf refreshData];
                }else{
                    [MyUtil showPlaceMessage:@"删除失败，请稍后重试！"];
                }
            }];
        }
    }] show];
}

#pragma mark - 定义cell的左滑事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_userID intValue] == self.userModel.userid && editingStyle == UITableViewCellEditingStyleDelete) {
//        editingStyle = UITableViewCellEditingStyleDelete;
        [[[AlertBlock alloc]initWithTitle:nil message:@"确认删除该直播？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
            if ([_userID intValue] == self.userModel.userid && buttonIndex == 1) {
                //        editingStyle = UITableViewCellEditingStyleDelete;
                LYLiveShowListModel *model = [LYLiveShowListModel new];
                model = _liveArray[indexPath.row];
                NSDictionary *dict = @{@"roomid":[NSString stringWithFormat:@"%d",model.roomId]};
                __weak __typeof(self)weakSelf = self;
                [LYFriendsHttpTool deleteMyLiveRecord:dict complete:^(BOOL result) {
                    if (result == YES) {
                        [weakSelf refreshData];
                    }else{
                        [MyUtil showPlaceMessage:@"删除失败，请稍后重试！"];
                    }
                }];
            }
        }] show];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_userID intValue] == self.userModel.userid) {
        return YES;
    }else{
        return NO;
    }
//    return NO;
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([_userID intValue] == self.userModel.userid) {
//        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//            LYLiveShowListModel *model = [LYLiveShowListModel new];
//            model = _liveArray[indexPath.row];
//            NSDictionary *dict = @{@"roomid":[NSString stringWithFormat:@"%d",model.roomId]};
//            __weak __typeof(self)weakSelf = self;
//            [LYFriendsHttpTool deleteMyLiveRecord:dict complete:^(BOOL result) {
//                if (result == YES) {
//                    [_mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    [weakSelf refreshData];
//                }else{
//                    [MyUtil showPlaceMessage:@"删除失败，请稍后重试！"];
//                }
//            }];
//        }];
//        return @[deleteAction];
//    }else{
//        return nil;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
