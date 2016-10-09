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
    // Do any additional setup after loading the view.
}

#pragma mark -- 配置表
-(void)setTableView{
    _mytableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _mytableView.dataSource = self;
    _mytableView.delegate = self;
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
    _currentHotPage +=1;
    [self getDataWithUserID:_userID andPage:[NSString stringWithFormat:@"%ld",(long)_currentHotPage]];
}

#pragma mark --- 获取数据
-(void) getDataWithUserID: (NSString *)userID andPage:(NSString *)pages{
    NSDictionary *dictionary = @{@"cityCode":@"310000",@"livetype":@"",@"sort":@"",@"page":pages,@"userid":userID};
    [LYFriendsHttpTool getLiveShowlistWithParams:dictionary complete:^(NSArray *Arr) {
        [self.liveArray addObjectsFromArray:Arr];
        if (_liveArray.count <= 0) {
            if (_liveArray.count <= 0) {
                [_mytableView.mj_header endRefreshing];
            }else{
                if(_currentHotPage == 1){
                    [_mytableView.mj_header endRefreshing];
                }else{
                    [_mytableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [_mytableView.mj_footer endRefreshing];
            [_mytableView.mj_header endRefreshing];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mytableView reloadData];
        });
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
    LiveShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:liveShowListID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LiveShowListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:liveShowListID];
    }
    LYLiveShowListModel *model = [LYLiveShowListModel new];
    model = _liveArray[indexPath.row];
    cell.listModel = model;
    
    [cell sendSubviewToBack:cell.backImageView];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT / 5 * 2;
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
