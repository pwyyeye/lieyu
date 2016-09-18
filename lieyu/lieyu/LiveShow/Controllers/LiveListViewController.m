//
//  LiveListViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveListViewController.h"
#import "LiveShowListCell.h"
#import "LiveShowViewController.h"
#import "WatchLiveShowViewController.h"
#import "LYFriendsHttpTool.h"
#import "LYLiveShowListModel.h"
#import "roomHostUser.h"
#import "HotMenuButton.h"
#import "LiveShowListCell.h"


static NSString *liveShowListID = @"liveShowListID";
@interface LiveListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    BOOL _friendsBtnSelect;//按钮选择状态
    HotMenuButton *_hotBtn,*_newBtn;//最热按钮 最新按钮
    UIView *_lineView;//导航按钮下划线
    UIButton *_chooseButton;//筛选
    UIScrollView *_scrollViewForTableView;//表的基成视图
    
    UIVisualEffectView *_effectView;//开始直播按钮
    int _type;
    UIButton *_registerLiveButton;
    int _oldScrollOffectY;
    UILabel *_kongLabel;
    BOOL isDisturb;
    NSInteger _currentHotPage, _currentRencentPage;
    UITableView *_hotTableView, *_newTablwView;
    int _chooseType;//0全部，1美女，2帅哥，3娱乐顾问，4玩友
}
@property (nonatomic, strong) UIView *chooseView;//筛选界面
@property (nonatomic,unsafe_unretained) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *hotDataArray;
@property (nonatomic, strong) NSMutableArray *rencentDataArray;

@end

@implementation LiveListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _pageNum = 2;
    _chooseType = 0;
    
    _tableViewArray = [NSMutableArray array];
    _hotDataArray = [NSMutableArray array];
    _rencentDataArray = [NSMutableArray array];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTableView];//配置表
    [self initMJFooterAndHeader];
    [self setMenuView];
    [self initReleaseWishButton];
    self.title = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = 0;
    if (!_index) {//0热门
        _friendsBtnSelect = YES;
    } else {
        _friendsBtnSelect = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_hotBtn removeFromSuperview];
    [_chooseButton removeFromSuperview];
    [_newBtn removeFromSuperview];
    [_lineView removeFromSuperview];
    [_scrollViewForTableView removeFromSuperview];
    [_effectView removeFromSuperview];
    [_chooseView removeFromSuperview];
    
    
    _chooseView = nil;
    _effectView = nil;
    _scrollViewForTableView = nil;
    _hotBtn = nil;
    _newBtn = nil;
    _chooseButton = nil;
}


#pragma mark -- 配置导航栏
-(void)setMenuView{
    CGFloat buttonWidth = SCREEN_WIDTH / 6;
    UIView *mavMenuView = [[UIView alloc] initWithFrame:(CGRectMake((SCREEN_WIDTH - buttonWidth*2 - 40)/2.f, 0, buttonWidth * 2 + 80, 44))];
    [self.navigationController.navigationBar addSubview:mavMenuView];
    
    _hotBtn = [[HotMenuButton alloc]initWithFrame:CGRectMake(0, 12, buttonWidth, 20)];
    [_hotBtn setTitle:@"热门" forState:UIControlStateNormal];
    _hotBtn.titleLabel.textColor = RGBA(255, 255, 255, 1);
    [_hotBtn addTarget:self action:@selector(hotButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mavMenuView addSubview:_hotBtn];
    _newBtn = [[HotMenuButton alloc]initWithFrame:CGRectMake(buttonWidth + 20, 12, buttonWidth, 20)];
    [_newBtn setTitle:@"最新" forState:UIControlStateNormal];
    _newBtn.titleLabel.textColor = RGBA(255, 255, 255, 1);
    [_newBtn addTarget:self action:@selector(newButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mavMenuView addSubview:_newBtn];
    if(_friendsBtnSelect) {//按钮选择状态
        _newBtn.isLiveListMenuSelected = NO;
        _hotBtn.isLiveListMenuSelected = YES;
    }else{
        _newBtn.isLiveListMenuSelected = YES;
        _hotBtn.isLiveListMenuSelected = NO;
    }
    
    _lineView = [[UIView alloc]init];
    _lineView.bounds = CGRectMake(0,0,42, 2);
    if (_friendsBtnSelect) {
        _lineView.center = CGPointMake(_hotBtn.center.x, mavMenuView.frame.size.height - 1);
    }else{
        _lineView.center = CGPointMake(_newBtn.center.x, mavMenuView.frame.size.height - 1);
    }
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [mavMenuView addSubview:_lineView];
    
    //筛选按钮
    _chooseButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 44)];
    [_chooseButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_chooseButton addTarget:self action:@selector(chooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_chooseButton];
    
    _chooseView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 40))];
    NSArray *array = @[@"筛选",@"全部",@"美女",@"帅哥",@"娱乐顾问",@"玩友"];
    for (int i = 0; i<6; i++) {
        UIButton *butt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        butt.frame = CGRectMake(SCREEN_WIDTH / 6 * i, 0, SCREEN_WIDTH/6, 40) ;
        butt.tag = 99 +i;//100全部
        [butt setTitle:array[i] forState:(UIControlStateNormal)];
        [butt setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        butt.backgroundColor = [UIColor whiteColor];
        if (!i) {
            butt.titleLabel.font = [UIFont systemFontOfSize:17];
            butt.userInteractionEnabled = NO;
        }else {
            butt.titleLabel.font = [UIFont systemFontOfSize:11];
            [butt addTarget:self action:@selector(chooseTypeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        if (i== 1) {
            [butt setTitleColor:RGB(187, 40, 217) forState:(UIControlStateNormal)];
        }
        [_chooseView addSubview:butt];
    }
    _chooseView.backgroundColor = [UIColor whiteColor];
    _chooseView.alpha = 0.6f;
    [self.view addSubview:_chooseView];
    _chooseView.hidden = YES;
    
}

#pragma mark - 空界面
- (void)initKongView{
    _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 4 - 45, SCREEN_WIDTH, 20)];
    [_kongLabel setText:@"抱歉小主，搜索不到！"];
    [_kongLabel setTextAlignment:NSTextAlignmentCenter];
    [_kongLabel setFont:[UIFont systemFontOfSize:14]];
    [_kongLabel setTextColor:RGBA(186, 30, 227, 1)];
    _kongLabel.layer.zPosition = 3;
    [self.view addSubview:_kongLabel];
}

-(void) hideEmptyView{
    [_kongLabel removeFromSuperview];
}

#pragma mark -- 上方按钮事件
-(void)chooseButtonAction{
    if (_chooseView.hidden) {
        _chooseView.hidden = NO;
    } else {
        _chooseView.hidden = YES;
    }
}

-(void)hotButtonClick{
    _friendsBtnSelect = YES;
    _index = 0;
    [self refreshData];
    _hotBtn.isLiveListMenuSelected = YES;
    _newBtn.isLiveListMenuSelected = NO;
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.center = CGPointMake(_hotBtn.center.x, _lineView.center.y);
    }];
}

-(void)newButtonClick{
    _friendsBtnSelect = NO;
    _index = 1;
    [self refreshData];
    _hotBtn.isLiveListMenuSelected = NO;
    _newBtn.isLiveListMenuSelected = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.center = CGPointMake(_newBtn.center.x, _lineView.center.y);
    }];
}

-(void)chooseTypeButtonAction:(UIButton *)sender{
    UIButton *but1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *but2 = (UIButton *)[self.view viewWithTag:101];
    UIButton *but3 = (UIButton *)[self.view viewWithTag:102];
    UIButton *but4 = (UIButton *)[self.view viewWithTag:103];
    UIButton *but5 = (UIButton *)[self.view viewWithTag:104];
    switch (sender.tag) {
        case 100://全部
            _chooseType = 0;
            [but1 setTitleColor:RGB(217, 40, 187) forState:(UIControlStateNormal)];
            [but2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but4 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but5 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            break;
        case 101:
            _chooseType = 1;
            [but2 setTitleColor:RGB(217, 40, 187) forState:(UIControlStateNormal)];
            [but1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but4 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but5 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            break;
        case 102:
            _chooseType = 2;
            [but3 setTitleColor:RGB(217, 40, 187) forState:(UIControlStateNormal)];
            [but2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but4 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but5 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            break;
        case 103:
            _chooseType = 3;
            [but4 setTitleColor:RGB(217, 40, 187) forState:(UIControlStateNormal)];
            [but2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but5 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            break;
        case 104:
            _chooseType = 4;
            [but5 setTitleColor:RGB(217, 40, 187) forState:(UIControlStateNormal)];
            [but2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [but4 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
    [self refreshData];
}

#pragma mark -- 配置表
-(void)setTableView{
    _scrollViewForTableView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollViewForTableView.contentSize = CGSizeMake(SCREEN_WIDTH * _pageNum, SCREEN_HEIGHT);
    [self initKongView];
    _scrollViewForTableView.pagingEnabled = YES;
    _scrollViewForTableView.delegate = self;
    _scrollViewForTableView.scrollsToTop = NO;
    [self.view addSubview:_scrollViewForTableView];
    [self.view sendSubviewToBack:_scrollViewForTableView];
    _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _hotTableView.tag = 0;
    _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _hotTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [_tableViewArray addObject:_hotTableView];
    [_scrollViewForTableView addSubview:_hotTableView];
    _hotTableView.delegate = self;
    _hotTableView.dataSource  = self;
    [_hotTableView registerNib:[UINib nibWithNibName:@"LiveShowListCell" bundle:nil] forCellReuseIdentifier:liveShowListID];
    _newTablwView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _newTablwView.tag = 1;
    _newTablwView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _newTablwView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [_tableViewArray addObject:_newTablwView];
    _newTablwView.scrollsToTop = NO;
    [_scrollViewForTableView addSubview:_newTablwView];
    _newTablwView.delegate = self;
    _newTablwView.dataSource  = self;
    [_newTablwView registerNib:[UINib nibWithNibName:@"LiveShowListCell" bundle:nil] forCellReuseIdentifier:liveShowListID];
    
    [self refreshData];
    
}



#pragma mark - 关于数据获取与刷新
- (void)initMJFooterAndHeader{
    for (UITableView *tableView in _tableViewArray) {
        __weak __typeof(self)weakSelf = self;
        tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        MJRefreshGifHeader *header = (MJRefreshGifHeader *)tableView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        
        tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            [weakSelf getMoreData];
        }];
        MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)tableView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
    }
}

- (void)refreshData{
        [_hotDataArray removeAllObjects];
        _currentHotPage = 1;
        [self getDataWithType:@"hot" AndPage:@"1"];
        [_rencentDataArray removeAllObjects];
        _currentRencentPage = 1;
        [self getDataWithType:@"recent" AndPage:@"1"];
}

- (void)getMoreData{
    if (_friendsBtnSelect) {
        _currentHotPage += 1;
        [self getDataWithType:@"hot" AndPage:[NSString stringWithFormat:@"%ld", _currentHotPage]];
    } else{
        _currentRencentPage += 1;
        [self getDataWithType:@"recent" AndPage:[NSString stringWithFormat:@"%ld", _currentRencentPage]];
    }
}

#pragma mark -- 获取数据
-(void)getDataWithType:(NSString *)sort AndPage:(NSString *)page{
    NSDictionary *dict = @{@"cityCode":@"310000",@"livetype":@"live",@"sort":sort,@"page":page};
    [LYFriendsHttpTool getLiveShowlistWithParams:dict complete:^(NSArray *Arr) {
        if ([sort isEqualToString:@"hot"]) {
            UITableView *hotTableView = (UITableView *)_tableViewArray[0];
            for (LYLiveShowListModel *model in Arr) {
                roomHostUser *user = model.roomHostUser;
                switch (_chooseType) {
                    case 0://全部
                        [self.hotDataArray addObject:model];
                        break;
                    case 1://美女
                        if (user.sex == 0) {
                        [self.hotDataArray addObject:model];
                        }
                        break;
                    case 2://帅哥
                        if (user.sex == 1) {
                        [self.hotDataArray addObject:model];
                        }
                        break;
                    case 3://娱乐顾问
                        if (user.roleid != 1) {
                        [self.hotDataArray addObject:model];
                        }
                        break;
                    case 4://玩友
                        if (user.roleid == 1) {
                        [self.hotDataArray addObject:model];
                        }
                        break;
                    default:
                        break;
                }
                
            }
            [self hideEmptyView];
            if (_hotDataArray.count <= 0) {
                if (_hotDataArray.count <= 0) {
                    [self initKongView];
                    [hotTableView.mj_header endRefreshing];
                }else{
                    if(_currentHotPage == 1){
                        [hotTableView.mj_header endRefreshing];
                    }else{
                        [hotTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }else{
                [hotTableView.mj_footer endRefreshing];
                [hotTableView.mj_header endRefreshing];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hotTableView reloadData];
            });
        } else {
            UITableView *newTableView = (UITableView *)_tableViewArray[1];
            for (LYLiveShowListModel *model in Arr) {
                roomHostUser *user = model.roomHostUser;
                switch (_chooseType) {
                    case 0://全部
                        [self.rencentDataArray addObject:model];
                        break;
                    case 1://美女
                        if (user.sex == 0) {
                            [self.rencentDataArray addObject:model];
                        }
                        break;
                    case 2://帅哥
                        if (user.sex == 1) {
                            [self.rencentDataArray addObject:model];
                        }
                        break;
                    case 3://娱乐顾问
                        if (user.roleid != 1) {
                            [self.rencentDataArray addObject:model];
                        }
                        break;
                    case 4://玩友
                        if (user.roleid == 1) {
                            [self.rencentDataArray addObject:model];
                        }
                        break;
                    default:
                        break;
                }
            }
            [self hideEmptyView];
            if (_rencentDataArray.count <= 0) {
                if (_rencentDataArray.count <= 0) {
                    [self initKongView];
                    [newTableView.mj_header endRefreshing];
                }else{
                    if(_currentRencentPage == 1){
                        [newTableView.mj_header endRefreshing];
                    }else{
                        [newTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }else{
                [newTableView.mj_footer endRefreshing];
                [newTableView.mj_header endRefreshing];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [newTableView reloadData];
            });
        }
            }];
    if (!_index) {
        [_scrollViewForTableView setContentOffset:CGPointZero];
    } else {
        [_scrollViewForTableView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(_scrollViewForTableView != scrollView){
        if (scrollView.contentOffset.y > _oldScrollOffectY) {
            if (scrollView.contentOffset.y <= 0.f) {
                if (_type == 0) {
                    _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 140, 60, 60);
                }else if (_type == 1){
                    _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
                }
            }else{
                [UIView animateWithDuration:0.4 animations:^{
                    _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT, 60, 60);
                }];
            }
        }else{
            if (CGRectGetMaxY(_effectView.frame) > SCREEN_HEIGHT - 5) {
                [UIView animateWithDuration:.4 animations:^{
                    if (_type == 0) {
                        _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 143, 60, 60);
                    }else if (_type == 1){
                        _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
                    }
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        if (_type == 0) {
                            _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 140, 60, 60);
                        }else if (_type == 1){
                            _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 144, 60, 60);
                        }
                    }];
                }];
            }
        }
    }else{
        if (!_index) {
            _hotBtn.isLiveListMenuSelected = YES;
        }else{
            _hotBtn.isLiveListMenuSelected = NO;
        }
        _newBtn.isLiveListMenuSelected = !_hotBtn.isLiveListMenuSelected;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_scrollViewForTableView  != scrollView){
        _contentOffSetY = scrollView.contentOffset.y;//拖拽结束获取偏移量
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _oldScrollOffectY = scrollView.contentOffset.y;

    if(scrollView == _scrollViewForTableView){
        _index = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        [_tableViewArray enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.scrollsToTop = NO;
        }];
        UITableView *tableView = _tableViewArray[_index];
        tableView.scrollsToTop = YES;
        
        if (_index == 1) {
            _newBtn.isLiveListMenuSelected = YES;
            _hotBtn.isLiveListMenuSelected = NO;
            [UIView animateWithDuration:0.1 animations:^{
                _lineView.center = CGPointMake(_newBtn.center.x, _lineView.center.y);
            }];
//            [self getDataWithType:@"recent" AndPage:@"1"];
        }else{
            _newBtn.isLiveListMenuSelected = NO;
            _hotBtn.isLiveListMenuSelected = YES;
            [UIView animateWithDuration:0.1 animations:^{
                _lineView.center = CGPointMake(_hotBtn.center.x, _lineView.center.y);
            }];
        }
    }
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == (UITableView *)_tableViewArray[0]) {//热门
        return _hotDataArray.count;
    } else {
        return _rencentDataArray.count;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:liveShowListID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LiveShowListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:liveShowListID];
    }
    LYLiveShowListModel *model = [LYLiveShowListModel new];
    if (tableView == (UITableView *)_tableViewArray[0]) {//热门
        model = _hotDataArray[indexPath.row];
    } else {
        model = _rencentDataArray[indexPath.row];
    }
    
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
    
    if (tableView == (UITableView *)_tableViewArray[0]) {//热门
        model = _hotDataArray[indexPath.row];
    } else {
        model = _rencentDataArray[indexPath.row];
    }
    NSString *roomId = [NSString stringWithFormat:@"%d",model.roomId];
    NSDictionary *dict = @{@"roomid":roomId};
    __weak LiveListViewController *weakSelf = self;
    [LYFriendsHttpTool getLiveShowRoomWithParams:dict complete:^(NSDictionary *Arr) {
        if ([Arr[@"roomType"] isEqualToString:@"live"]) {
            watchLiveVC.contentURL = Arr[@"liveRtmpUrl"];
            watchLiveVC.chatRoomId = Arr[@"chatroomid"];
        } else {
            watchLiveVC.contentURL = Arr[@"playbackURL"];
            watchLiveVC.chatRoomId = nil;
        }
        watchLiveVC.hostUser = Arr[@"roomHostUser"];
        watchLiveVC.shareIamge = model.roomImg;
        [weakSelf presentViewController:watchLiveVC animated:YES completion:NULL];
    }];
    
}

#pragma mark - 发送愿望按钮
- (void)initReleaseWishButton{
    //26-47
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [_effectView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 60, 60, 60)];
    
    _effectView.layer.cornerRadius = 30;
    _effectView.layer.masksToBounds = YES;
    [self.view addSubview:_effectView];
    [self.view bringSubviewToFront:_effectView];
    
    _registerLiveButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 15, 36, 30)];
    [_registerLiveButton setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
    [_registerLiveButton addTarget:self action:@selector(registerLiveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_effectView addSubview:_registerLiveButton];
    
    [UIView animateWithDuration:.4 animations:^{
        if (_type == 0) {
            _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 143, 60, 60);
        }else if (_type == 1){
            _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            if (_type == 0) {
                _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 140, 60, 60);
            }else if (_type == 1){
                _effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
            }
        }];
    }];
}

#pragma mark -- 点击开始直播按钮
-(void)registerLiveButtonAction{
    LiveShowViewController *registerPushRoomVC = [[LiveShowViewController alloc] init];
    [self presentViewController:registerPushRoomVC animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
