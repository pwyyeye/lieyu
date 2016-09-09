//
//  HomePageINeedPlayViewController.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYAdshowCell.h"
#import "HomePageINeedPlayViewController.h"
#import "MJRefresh.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "JiuBaModel.h"
#import "LYPlayTogetherMainViewController.h"
#import "DWTaoCanXQViewController.h"
#import "MyCollectionViewController.h"
#import "LYCityChooseViewController.h"
#import "LYHomeSearcherViewController.h"
#import "bartypeslistModel.h"
#import "LYNavigationController.h"
#import "HuoDongViewController.h"
#import "LYCacheDefined.h"
#import "LYCache+CoreDataProperties.h"
#import "LYUserHttpTool.h"
#import "LYFriendsHttpTool.h"
#import "HomeBarCollectionViewCell.h"
#import "HomeMenuCollectionViewCell.h"
#import "HomePageModel.h"
#import "SDCycleScrollView.h"
#import "HotMenuButton.h"
#import "LYHotBarsViewController.h"
#import "UIButton+WebCache.h"
#import "BeerNewBarViewController.h"
#import "HuoDongLinkViewController.h"
#import "HomeMenusCollectionViewCell.h"
#import "LYHomeCollectionViewCell.h"
#import "recommendedTopic.h"
#import "ActionPage.h"
#import "ActionDetailViewController.h"
#import "ZSMaintViewController.h"
#import "ChiHeViewController.h"
#import "ZujuViewController.h"
#import "LYGuWenPersonCollectionViewCell.h"
#import "LYGuWenListViewController.h"
#import "LYHomeGuWenCollectionViewCell.h"
#import "LYGuWenVideoViewController.h"
#import "LYGuWenBannerCollectionViewCell.h"
#import "LYMyFriendDetailViewController.h"
#import "LYGuWenListViewController.h"

#import "AlertBlock.h"
#import "EScrollerView.h"
#import "HomepageLiveTableViewCell.h"
#import "LiveShowListCell.h"
#import "HomepageHotBarsTableViewCell.h"
#import "HomePageCollectionViewCell.h"
#import "HomepageBarDetailTableViewCell.h"
#import "HomepageMenuTableViewCell.h"
#import "HomepageActiveTableViewCell.h"
#import "HomepageBannerModel.h"
#import "LYLiveShowListModel.h"
#import "LiveListViewController.h"
#import "StrategyListViewController.h"
#import "WatchLiveShowViewController.h"
#import "LYFriendsTopicsViewController.h"
#import "LYYUHttpTool.h"
#import "BarGroupChatViewController.h"
#import "IQKeyboardManager.h"
#import "ActivityMainViewController.h"
#import "TopicModel.h"

#define PAGESIZE 20
#define HOMEPAGE_MTA @"HOMEPAGE"
#define HOMEPAGE_TIMEEVENT_MTA @"HOMEPAGE_TIMEEVENT"

#define COLLECTVIEWEDGETOP UIEdgeInsetsMake(91 - 40, 0, 49, 0)
#define COLLECTVIEWEDGEDOWN UIEdgeInsetsMake(91, 0, 49, 0)

#define MENUVIEWCENTERTOP 8
#define MENUVIEWCENTERDOWN 45

@interface HomePageINeedPlayViewController ()
<EScrollerViewDelegate,SDCycleScrollViewDelegate,
UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,EScrollerViewDelegate,LYBarCommentSuccessDelegate>{
    UIButton *_searchBtn;
    UIButton *_titleImageView;
    UIActivityIndicatorView *_refreshView;
    CGFloat _scale;
    NSInteger _index;//区分夜店和酒吧
    NSMutableArray *_dataArray,*_recommendedBarArray;//酒吧数组 推荐酒吧数组
    NSMutableArray *_menuBtnArray;//夜店按钮 酒吧按钮
    UIView *_lineView;//夜店 酒吧按钮下滑线
    UIVisualEffectView *_navView,*_menuView;//导航 菜单的背景view
    NSMutableArray *_fiterArray;//过滤数字
    
    CGFloat _contentOffSetWidth;//夜店表的偏移量 酒吧的表的偏移量
    float offsetY[3];//3个界面的y方向偏移量
    NSString *_guWenBannerImgUrl;//顾问界面中间的banner；
    UICollectionView *_collectView;
    BOOL _isCollectView;//区分大的collectview 和 cell内部的collectview
    
    RecommendedTopic *_recommendedTopic;//推荐话题  ？？？？
    NSMutableArray *_newbannerListArray;//AD数组
    
    RecommendedTopic *_recommendedTopic2;
    
    BOOL _isGetDataFromNet_YD,_isGetDataFromNet_BAR;//判断是否从服务器获取夜店  酒吧的数据
    BOOL _isDragScrollToTop;//是否拖拽至顶
    NSMutableArray *_collectionArray;
    UIScrollView *_bgScrollView;
    NSString *_userLocation;//当前定位的城市
    
    BOOL isFirstTimeGetin;//第一次进页面
    
    NSInteger _currentPage_YD,_currentPage_Bar,_currentPage_Live;//当前夜店的请求起始个数 当前酒吧的请求起始个数
    NSMutableArray *_firstEnterPage;
    NSMutableArray *_currentPageArray;
    
    BOOL _refreshingData;
    NSMutableArray *_refreshingArray;
    
    UIButton *_clickedButton;//点击进行评论，点赞的按钮
}
@property (nonatomic,strong) UIButton *cityChooseBtn;//定位城市按钮
@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (nonatomic,strong) NSArray *bartypeslistArray;
@property(nonatomic,assign) NSInteger curPageIndex;
@property (nonatomic,strong) NSArray *hotJiuBarTitle;

@property (nonatomic, assign) NSInteger indexExistsType;//0:表示只有直播 1:表示有夜店和直播 2：表示有酒吧和直播 3:表示有酒吧、夜店和直播

@property (nonatomic, assign) NSInteger tableViewAmount;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *scrollViewArray;

@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableArray *dataList;//所有的列表数据都装在这里
@property (nonatomic, strong) NSMutableArray *pageTopData;//所有页面顶部的信息

@property (nonatomic, strong) NSMutableDictionary *ydDict;
@property (nonatomic, strong) NSMutableDictionary *barDict;
@property (nonatomic, strong) NSMutableDictionary *liveDict;

@end

@implementation HomePageINeedPlayViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self createNavButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNavButtonAndImageView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLocationCity) name:@"locationCityThisTime" object:nil];
    //初始化
    [self changeLocationCity];
}

- (void)setupData{
    _dataList = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i = 0 ; i < 3 ; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataList addObject:array];
    }
    _ydDict = [[NSMutableDictionary alloc]init];
    _barDict = [[NSMutableDictionary alloc]init];
    _liveDict = [[NSMutableDictionary alloc]init];
    _pageTopData = [[NSMutableArray alloc]initWithCapacity:3];
    _firstEnterPage = [[NSMutableArray alloc]initWithArray:@[@"0", @"0", @"0"]];
    _refreshingArray = [[NSMutableArray alloc]initWithArray:@[@"0", @"0", @"0"]];
    _currentPageArray = [[NSMutableArray alloc]initWithArray:@[@1, @1, @1]];
}

#pragma mark - 是否改变城市
- (void)changeLocationCity{
    __weak __typeof(self)weakSelf = self;
    if (![MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"LocationCityThisTime"]] &&
        ![[USER_DEFAULT objectForKey:@"LocationCityThisTime"] isEqualToString:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]]) {
        //这次定位到的城市不为空并且和上次选择的城市不一样,让选择是否跳转
        [[[AlertBlock alloc]initWithTitle:nil message:[NSString stringWithFormat:@"系统定位到您在%@,需要切换到%@吗？",[USER_DEFAULT objectForKey:@"LocationCityThisTime"],[USER_DEFAULT objectForKey:@"LocationCityThisTime"]] cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                //不跳转，以上次选择城市获取数据与排界面
                [weakSelf createUI];
            }else if (buttonIndex == 1){
                [USER_DEFAULT setObject:[USER_DEFAULT objectForKey:@"LocationCityThisTime"] forKey:@"ChooseCityLastTime"];
                [USER_DEFAULT setObject:[USER_DEFAULT objectForKey:@"ThisTimeHasBar"] forKey:@"LastCityHasBar"];
                [USER_DEFAULT setObject:[USER_DEFAULT objectForKey:@"ThisTimeHasNightClub"] forKey:@"LastCityHasNightClub"];
                //跳转。获取数据&&排布页面根据当前页面
                [weakSelf emptyUserDefault];
                [weakSelf createUI];
            }
        }]show];
    }else if ([MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"LocationCityThisTime"]]){
        //为空，以上此为准
        [self createUI];
    }else if ([[USER_DEFAULT objectForKey:@"LocationCityThisTime"] isEqualToString:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]]){
        //不为空，但要重新更新数据。
        [USER_DEFAULT setObject:[USER_DEFAULT objectForKey:@"ThisTimeHasBar"] forKey:@"LastCityHasBar"];
        [USER_DEFAULT setObject:[USER_DEFAULT objectForKey:@"ThisTimeHasNightClub"] forKey:@"LastCityHasNightClub"];
        [self emptyUserDefault];
        [self createUI];
    }
}

- (void)emptyUserDefault{
    [USER_DEFAULT setObject:@"" forKey:@"LocationCityThisTime"];
    [USER_DEFAULT setObject:@"" forKey:@"ThisTimeHasBar"];
    [USER_DEFAULT setObject:@"" forKey:@"ThisTimeHasNightClub"];
}

- (NSArray *)imagesArray{
    NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
    for (int i = 1 ; i < 5 ; i ++) {
        [imagesArray addObject:[NSString stringWithFormat:@"%d_retina.jpg",i]];
    }
    return imagesArray;
}

#pragma mark - 创建主界面
- (void)createUI{
    //看好有什么，没有什么。
    //0:表示只有直播 1:表示有夜店和直播 2：表示有酒吧和直播 3:表示有夜店、酒吧和直播
    if([[USER_DEFAULT objectForKey:@"LastCityHasNightClub"] isEqualToString:@"1"] && [[USER_DEFAULT objectForKey:@"LastCityHasBar"] isEqualToString:@"1"]){
        _indexExistsType = 3;
        _tableViewAmount = 3;
    }else if ([[USER_DEFAULT objectForKey:@"LastCityHasNightClub"] isEqualToString:@"0"] && [[USER_DEFAULT objectForKey:@"LastCityHasBar"] isEqualToString:@"1"]){
        _indexExistsType = 2;
        _tableViewAmount = 2;
    }else if ([[USER_DEFAULT objectForKey:@"LastCityHasNightClub"] isEqualToString:@"1"] && [[USER_DEFAULT objectForKey:@"LastCityHasBar"] isEqualToString:@"0"]){
        _indexExistsType = 1;
        _tableViewAmount = 2;
    }else if ([[USER_DEFAULT objectForKey:@"LastCityHasNightClub"] isEqualToString:@"0"] && [[USER_DEFAULT objectForKey:@"LastCityHasBar"] isEqualToString:@"0"]){
        _indexExistsType = 0;
        _tableViewAmount = 1;
    }
    
    if (_bgScrollView) {
        [_bgScrollView removeFromSuperview];
    }
    //最底部的scrollView的初始化
    _bgScrollView = [[UIScrollView alloc]init];
    _bgScrollView.scrollsToTop = NO;
    _bgScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _bgScrollView.backgroundColor = [UIColor clearColor];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.bounces = NO;
    [_bgScrollView setContentSize:CGSizeMake(_tableViewAmount * SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_bgScrollView];
    _tableViewArray = [[NSMutableArray alloc]init];
    _scrollViewArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _tableViewAmount; i ++) {
        
        //初始化好各个表
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (i == 0) {
            if (_indexExistsType == 0) {
                tableView.tag = 2;
            }else if (_indexExistsType == 1 || _indexExistsType == 3){
                tableView.tag = 0;
            }else{
                tableView.tag = 1;
            }
        }else if (i == 1){
            if (_indexExistsType == 1 || _indexExistsType == 2) {
                tableView.tag = 2;
            }else{
                tableView.tag = 1;
            }
        }else if (i == 2){
            tableView.tag = 2;
        }
        //为tableview注册好cell      ＊＊＊＊＊＊＊＊＊待写＊＊＊＊＊＊＊＊＊＊
        [tableView registerNib:[UINib nibWithNibName:@"LiveShowListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"liveShowListID"];
        [tableView registerNib:[UINib nibWithNibName:@"HomepageLiveTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomepageLiveTableViewCell"];
        if (_tableViewAmount > 1){
            //有酒吧或夜店列表
            [tableView registerNib:[UINib nibWithNibName:@"HomepageActiveTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomepageActiveTableViewCell"];
            [tableView registerNib:[UINib nibWithNibName:@"HomepageMenuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomepageMenuTableViewCell"];
            [tableView registerNib:[UINib nibWithNibName:@"HomepageHotBarsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomepageHotBarsTableViewCell"];
            [tableView registerNib:[UINib nibWithNibName:@"HomepageBarDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomepageBarDetailTableViewCell"];
        }
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [_bgScrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
        [tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.width / 16 * 9 + 90)];
        tableView.tableHeaderView = headerView;
        
        UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        [headerView addSubview:spaceView];
        
        EScrollerView *eScrollView = [[EScrollerView alloc]initWithFrame:CGRectMake(0, 90, headerView.frame.size.width, headerView.frame.size.height - 90)];
        //        EScrollerView *eScrollView = [[EScrollerView alloc]initWithFrameRect:CGRectMake(0, 90, headerView.frame.size.width, headerView.frame.size.height - 90) scrolArray:[self imagesArray] needTitile:NO];
        //        [eScrollView configureImagesArray:[self imagesArray]];
        eScrollView.delegate = self;
        [headerView addSubview:eScrollView];
        [_scrollViewArray addObject:eScrollView];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        
        
        __weak __typeof(self) weakSelf = self;
        tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            //刷新，加载更多数据
            int page = [[_currentPageArray objectAtIndex:tableView.tag] intValue];
            [_currentPageArray replaceObjectAtIndex:tableView.tag withObject:@(++page)];
            
            NSString *subids;
            if (tableView.tag == 1 || tableView.tag == 0) {
                if (tableView.tag == 0) {
                    subids = @"2";
                }else if (tableView.tag == 1){
                    subids = @"1,6,7";
                }
            }
            
            [weakSelf getDataArray:tableView.tag subids:subids];
        }];
        MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)tableView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
    }
    
    
    //获取数据
    [self lineViewAnimation];
    
    
    [self removeNavButtonAndImageView];
    [self createNavButton];
    
}


#pragma mark 创建导航的按钮(选择城市和搜索)
- (void)createNavButton{
    _menuBtnArray = [[NSMutableArray alloc]init];
    
    UIBlurEffect *effectExtraLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.alpha = 5;
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    //城市搜索
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 6 + 20, 60, 30)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitleColor:RGBA(1, 1, 1, 1) forState:UIControlStateNormal];
    _cityChooseBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    [_cityChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_cityChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_cityChooseBtn];
    
    //搜索按钮
    CGFloat searchBtnWidth = 24;
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(65, 20 , SCREEN_WIDTH - 130, searchBtnWidth + 20)];
    [_searchBtn setImage:[UIImage imageNamed:@"HomepageSearch"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_searchBtn];
    
    //刷新控件
    _refreshView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_refreshView setCenter:CGPointMake(SCREEN_WIDTH - 32, 42)];
    _refreshView.hidesWhenStopped = YES;
    _refreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_menuView addSubview:_refreshView];
    
    [self createMenuButtons];
}

- (void)createMenuButtons{
    NSArray *btnTitleArray;
    //0:表示只有直播 1:表示有夜店和直播 2：表示有酒吧和直播 3:表示有酒吧、夜店和直播
    if (_indexExistsType == 3) {
        btnTitleArray = @[@"夜店",@"酒吧",@"直播"];
    }else if (_indexExistsType == 0){
        btnTitleArray = @[@"直播"];
    }else if (_indexExistsType == 2){
        btnTitleArray = @[@"酒吧",@"直播"];
    }else if (_indexExistsType == 1){
        btnTitleArray = @[@"夜店",@"直播"];
    }
    for (int i = 0; i < btnTitleArray.count; i ++) {
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0) btn.isHomePageMenuViewSelected = YES;
        else btn.isHomePageMenuViewSelected = NO;
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [_menuView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/btnTitleArray.count * i, _menuView.frame.size.height - 16 - 4.5, SCREEN_WIDTH/btnTitleArray.count, 16);
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_menuBtnArray addObject:btn];
    }
    //按钮下滑线
    HotMenuButton *firstBtn = _menuBtnArray.firstObject;
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [_menuView addSubview:_lineView];
    _lineView.frame = CGRectMake(0, _menuView.frame.size.height - 2, 42, 2);
    _lineView.center = CGPointMake(firstBtn.center.x, _lineView.center.y);
    
    if (_index) {
        HotMenuButton *firstBtn = _menuBtnArray.firstObject;
        firstBtn.isHomePageMenuViewSelected = NO;
        
        HotMenuButton *btn = _menuBtnArray[_index];
        btn.isHomePageMenuViewSelected = YES;
        
        _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
    }
    [_menuView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"locationCityThisTime" object:nil];
}

#pragma mark - scrollview的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [_collectionArray enumerateObjectsUsingBlock:^(UICollectionView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if (_menuView.center.y == 8) {
    //            [obj setContentInset:COLLECTVIEWEDGETOP];
    //        }else{
    //            [obj setContentInset:COLLECTVIEWEDGEDOWN];
    //        }
    //    }];
    //
    //
    //    _isDragScrollToTop = YES;
    //    UICollectionView *collectView = _collectionArray[_index];
    //    offsetY[_index] = collectView.contentOffset.y;
}

- (void)lineViewAnimation{
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    //如果这个页面在刷新数据，则显示刷新控件，否则隐藏
    if ([[_refreshingArray objectAtIndex:tableView.tag] isEqualToString:@"1"]) {
        [_refreshView startAnimating];
    }else if ([[_refreshingArray objectAtIndex:tableView.tag] isEqualToString:@"0"]){
        [_refreshView stopAnimating];
    }
    
    //第一次进入页面要刷新数据
    if ([[_firstEnterPage objectAtIndex:tableView.tag] isEqualToString:@"0"]) {
        [_firstEnterPage replaceObjectAtIndex:tableView.tag withObject:@"1"];
        [self getDataWith];
    }
    
    //改变菜单按钮
    [_menuBtnArray enumerateObjectsUsingBlock:^(HotMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isHomePageMenuViewSelected = NO;
    }];
    HotMenuButton *button = (HotMenuButton *)[_menuBtnArray objectAtIndex:_index];
    button.isHomePageMenuViewSelected = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.center = CGPointMake(button.center.x, _lineView.center.y);
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _bgScrollView) {
        _index = (scrollView.contentOffset.x + (scrollView.frame.size.width / 2))/ scrollView.frame.size.width;
        [self lineViewAnimation];
    }else{
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        if (scrollView == tableView) {
            if (scrollView.contentOffset.y < -100) {
                if ([[_refreshingArray objectAtIndex:tableView.tag] isEqualToString:@"0"]) {
                    [_refreshingArray replaceObjectAtIndex:tableView.tag withObject:@"1"];
                    [_refreshView startAnimating];
                    [_currentPageArray replaceObjectAtIndex:tableView.tag withObject:@(1)];
                    [self getDataWith];
                }
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _bgScrollView) {
        _index = (scrollView.contentOffset.x + (scrollView.frame.size.width / 2))/ scrollView.frame.size.width;
        [self lineViewAnimation];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bgScrollView) {
        _index = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
        [self lineViewAnimation];
    }else{
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        if (scrollView == tableView) {
            EScrollerView *eScrollView = [_scrollViewArray objectAtIndex:_index];
            eScrollView.isDragVertical = NO;
            NSLog(@"scrollViewDidEndDecelerating:%f",scrollView.contentOffset.y);
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _bgScrollView){
        
    }else{
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        if (scrollView == tableView) {
            CGFloat imageHeight = tableView.tableHeaderView.frame.size.height - 90;
            CGFloat imageWidth = tableView.tableHeaderView.frame.size.width;
            //图片上下偏移量
            CGFloat imageOffsetY = scrollView.contentOffset.y;
            
            if (imageOffsetY < 0) {
                CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
                CGFloat bili = totalOffset / imageHeight * 1.0;
                EScrollerView *eScrollView = [_scrollViewArray objectAtIndex:_index];
                eScrollView.isDragVertical = YES;
                [eScrollView setScrollViewFrame:CGRectMake((imageWidth - imageWidth * bili) / 2, imageOffsetY, SCREEN_WIDTH * bili, totalOffset)];
            }
//            if (imageOffsetY < -50) {
//                if ([[_refreshingArray objectAtIndex:tableView.tag] isEqualToString:@"0"]) {
//                    [_refreshingArray replaceObjectAtIndex:tableView.tag withObject:@"1"];
//                    [_refreshView startAnimating];
//                    [_currentPageArray replaceObjectAtIndex:tableView.tag withObject:@(1)];
//                    [self getDataWith];
//                }
//            }
        }
    }
}



//显示菜单
- (void)showMenuView{
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.center = CGPointMake(_menuView.center.x,45);
        _titleImageView.alpha = 1.0;
        _cityChooseBtn.alpha = 1.f;
        _searchBtn.alpha = 1.f;
    }completion:^(BOOL finished) {
        
    }];
}

//隐藏菜单
- (void)hideMenuView{
    [UIView animateWithDuration:0.2 animations:^{
        _menuView.center = CGPointMake( _menuView.center.x,8);
        _titleImageView.alpha = 0.0;
        _cityChooseBtn.alpha = 0.f;
        _searchBtn.alpha = 0.f;
    } completion:^(BOOL finished) {
        
    }];
}



//kvo监听导航的上下改变cell内部collecview的contentInset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIVisualEffectView *effectView = (UIVisualEffectView *)object;
    UICollectionView *collectionView = _collectionArray[_index];
    
    if (effectView.center.y == 8) {//上面
        if(collectionView.contentInset.top == 91) [collectionView setContentInset:COLLECTVIEWEDGETOP];
    }else if (effectView.center.y == 45){
        if(collectionView.contentInset.top == 91-40)  [collectionView setContentInset:COLLECTVIEWEDGEDOWN];
    }
}

#pragma mark - tableView的代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 2) {
        return 2;
    }else if (tableView.tag == 1){
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            return 4;
        }else{
            return 3;
        }
    }else if (tableView.tag == 0){
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            return 4;
        }else{
            return 3;
        }
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return ((NSMutableArray *)[_liveDict objectForKey:@"liveList"]).count;
        }else{
            return 0;
        }
    }else if (tableView.tag == 1){
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            if (section == 0 || section == 1 || section == 2) {
                return 1;
            }else if (section == 3){
                return ((NSMutableArray *)[_barDict objectForKey:@"barList"]).count;
            }else{
                return 0;
            }
        }else{
            if (section == 0 || section == 1) {
                return 1;
            }else if (section == 2){
                return ((NSMutableArray *)[_barDict objectForKey:@"barList"]).count;
            }else{
                return 0;
            }
        }
    }else if (tableView.tag == 0){
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            if (section == 0 || section == 1 || section == 2) {
                return 1;
            }else if (section == 3){
                return ((NSMutableArray *)[_ydDict objectForKey:@"barList"]).count;
            }else{
                return 0;
            }
        }else{
            if (section == 0 || section == 1) {
                return 1;
            }else if (section == 2){
                return ((NSMutableArray *)[_ydDict objectForKey:@"barList"]).count;
            }else{
                return 0;
            }
        }
    }else{
        return 0;
    }
}

- (void)cellAddTarget:(HomepageBarDetailTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    cell.collectButton.tag = indexPath.row;
    [cell.collectButton addTarget:self action:@selector(collectBar:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tag = indexPath.row;
    [cell.commentButton addTarget:self action:@selector(commentBar:) forControlEvents:UIControlEventTouchUpInside];
    cell.communicateButton.tag = indexPath.row;
    [cell.communicateButton addTarget:self action:@selector(communicateBar:) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2) {
        //直播
        if (indexPath.section == 0) {
            HomepageLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageLiveTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.hotButton addTarget:self action:@selector(gotoLiveList:) forControlEvents:UIControlEventTouchUpInside];
            [cell.recentButton addTarget:self action:@selector(gotoLiveList:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.section == 1) {
            LiveShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveShowListID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LYLiveShowListModel *model = [((NSMutableArray *)[_liveDict objectForKey:@"liveList"]) objectAtIndex:indexPath.row];
            cell.listModel = model;
            return cell;
        }else{
            return nil;
        }
    }else if (tableView.tag == 1){
        //酒吧
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {
                HomepageActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageActiveTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                RecommendedTopic *topic = [_barDict objectForKey:@"recommendedTopic"];
                cell.topicModel = topic;
                return cell;
            }else if (indexPath.section == 1){
                HomepageMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageMenuTableViewCell" forIndexPath:indexPath];
                NSArray *array = [_barDict objectForKey:@"filterImageList"];
                cell.imagesArray = array;
                [cell.hotButton addTarget:self action:@selector(jumpToHot) forControlEvents:UIControlEventTouchUpInside];
                [cell.recentButton addTarget:self action:@selector(jumpToRecent) forControlEvents:UIControlEventTouchUpInside];
                [cell.strategyButton addTarget:self action:@selector(jumpToStrategy) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.section == 2){
                HomepageHotBarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageHotBarsTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.barList = ((NSArray *)[_barDict objectForKey:@"recommendBarList"]);
                return cell;
            }else if (indexPath.section == 3){
                HomepageBarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageBarDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self cellAddTarget:cell IndexPath:indexPath];
                JiuBaModel *model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                cell.barModel = model;
                return cell;
            }else{
                return nil;
            }
        }else{
            if (indexPath.section == 0) {
                HomepageMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageMenuTableViewCell" forIndexPath:indexPath];
                NSArray *array = [_barDict objectForKey:@"filterImageList"];
                cell.imagesArray = array;
                [cell.hotButton addTarget:self action:@selector(jumpToHot) forControlEvents:UIControlEventTouchUpInside];
                [cell.recentButton addTarget:self action:@selector(jumpToRecent) forControlEvents:UIControlEventTouchUpInside];
                [cell.strategyButton addTarget:self action:@selector(jumpToStrategy) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.section == 1){
                HomepageHotBarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageHotBarsTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.barList = ((NSArray *)[_barDict objectForKey:@"recommendBarList"]);
                return cell;
            }else if (indexPath.section == 2){
                HomepageBarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageBarDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self cellAddTarget:cell IndexPath:indexPath];
                JiuBaModel *model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                cell.barModel = model;
                return cell;
            }else{
                return nil;
            }
        }
    }else if (tableView.tag == 0){
        //夜店
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {
                HomepageActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageActiveTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                RecommendedTopic *topic = [_ydDict objectForKey:@"recommendedTopic"];
                cell.topicModel = topic;
                return cell;
            }else if (indexPath.section == 1){
                HomepageMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageMenuTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *array = [_ydDict objectForKey:@"filterImageList"];
                cell.imagesArray = array;
                [cell.hotButton addTarget:self action:@selector(jumpToHot) forControlEvents:UIControlEventTouchUpInside];
                [cell.recentButton addTarget:self action:@selector(jumpToRecent) forControlEvents:UIControlEventTouchUpInside];
                [cell.strategyButton addTarget:self action:@selector(jumpToStrategy) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (indexPath.section == 2){
                HomepageHotBarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageHotBarsTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.barList = ((NSArray *)[_ydDict objectForKey:@"recommendBarList"]);
                return cell;
            }else if (indexPath.section == 3){
                HomepageBarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageBarDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self cellAddTarget:cell IndexPath:indexPath];
                JiuBaModel *model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                cell.barModel = model;
                return cell;
            }else{
                return nil;
            }
        }else{
            if (indexPath.section == 0) {
                HomepageMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageMenuTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *array = [_ydDict objectForKey:@"filterImageList"];
                cell.imagesArray = array;
                [cell.hotButton addTarget:self action:@selector(jumpToHot) forControlEvents:UIControlEventTouchUpInside];
                [cell.recentButton addTarget:self action:@selector(jumpToRecent) forControlEvents:UIControlEventTouchUpInside];
                [cell.strategyButton addTarget:self action:@selector(jumpToStrategy) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (indexPath.section == 1){
                HomepageHotBarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageHotBarsTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.barList = ((NSArray *)[_ydDict objectForKey:@"recommendBarList"]);
                return cell;
            }else if (indexPath.section == 2){
                HomepageBarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageBarDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self cellAddTarget:cell IndexPath:indexPath];
                JiuBaModel *model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                cell.barModel = model;
                return cell;
            }else{
                return nil;
            }
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2) {
        if (indexPath.section == 0) {
            return 67;
        }else if (indexPath.section == 1){
            return SCREEN_WIDTH * 0.71;
        }else{
            return 0;
        }
    }else if (tableView.tag == 1){
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {
                return 160;
            }else if (indexPath.section == 1){
                return 138;
            }else if (indexPath.section == 2){
                return 284;
            }else if (indexPath.section == 3){
                return SCREEN_WIDTH / 16 * 9 + 57;
            }else{
                return 0;
            }
        }else{
            if (indexPath.section == 0) {
                return 138;
            }else if (indexPath.section == 1){
                return 284;
            }else if (indexPath.section == 2){
                return SCREEN_WIDTH / 16 * 9 + 57;
            }else{
                return 0;
            }
        }
    }else if (tableView.tag == 0){
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {
                return 160;
            }else if (indexPath.section == 1){
                return 138;
            }else if (indexPath.section == 2){
                return 284;
            }else if (indexPath.section == 3){
                return SCREEN_WIDTH / 16 * 9 + 57;
            }else{
                return 0;
            }
        }else{
            if (indexPath.section == 0) {
                return 138;
            }else if (indexPath.section == 1){
                return 284;
            }else if (indexPath.section == 2){
                return SCREEN_WIDTH / 16 * 9 + 57;
            }else{
                return 0;
            }
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2) {
        if (section == 0 || section == 1) {
            return 6;
        }else{
            return 0;
        }
    }else if (tableView.tag == 1){
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            if (section == 0) {
                return 3;
            }else{
                return 6;
            }
        }else{
            return 6;
        }
    }else if (tableView.tag == 0){
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            if (section == 0) {
                return 3;
            }else{
                return 6;
            }
        }else{
            return 6;
        }
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        if (((RecommendedTopic *)[_ydDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {//活动
//                RecommendedTopic *topic = [_ydDict objectForKey:@"recommendedTopic"];
                ActivityMainViewController *activityMainVC = [[ActivityMainViewController alloc]init];
                [self.navigationController pushViewController:activityMainVC animated:YES];
//                ActionPage *aPage = [[ActionPage alloc]init];
//                aPage.ActionImage = ((HomepageActiveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).topicImage.image;
//                if(!topic.id) return;
//                aPage.topicid = topic.id;
//                [self.navigationController pushViewController:aPage animated:YES];
            }else if (indexPath.section == 3){//酒吧
                JiuBaModel *model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
                if(!model.barid) return;
                controller.beerBarId = @(model.barid);
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            if (indexPath.section == 2) {//酒吧
                JiuBaModel *model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
                if(!model.barid) return;
                controller.beerBarId = @(model.barid);
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else if (tableView.tag == 1){
        if (((RecommendedTopic *)[_barDict objectForKey:@"recommendedTopic"]).name) {
            if (indexPath.section == 0) {//活动
//                RecommendedTopic *topic = [_barDict objectForKey:@"recommendedTopic"];
//                ActionPage *aPage = [[ActionPage alloc]init];
//                aPage.ActionImage = ((HomepageActiveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).topicImage.image;
//                if(!topic.id) return;
//                aPage.topicid = topic.id;
//                [self.navigationController pushViewController:aPage animated:YES];
                ActivityMainViewController *activityMainVC = [[ActivityMainViewController alloc]init];
                [self.navigationController pushViewController:activityMainVC animated:YES];
            }else if (indexPath.section == 3){//酒吧
                JiuBaModel *model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
                if(!model.barid) return;
                controller.beerBarId = @(model.barid);
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            if (indexPath.section == 2) {//酒吧
                JiuBaModel *model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:indexPath.row];
                BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
                if(!model.barid) return;
                controller.beerBarId = @(model.barid);
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else if (tableView.tag == 2){
        if (indexPath.section == 1) {
            LYLiveShowListModel *model = [[_liveDict objectForKey:@"liveList"] objectAtIndex:indexPath.row];
            WatchLiveShowViewController *watchLiveVC = [[WatchLiveShowViewController alloc] init];
            NSString *roomId = [NSString stringWithFormat:@"%d",model.roomId];
            NSDictionary *dict = @{@"roomid":roomId};
            __weak __typeof(self) weakSelf = self;
            [LYFriendsHttpTool getLiveShowRoomWithParams:dict complete:^(NSDictionary *Arr) {
                watchLiveVC.contentURL = Arr[@"liveRtmpUrl"];
                watchLiveVC.chatRoomId = Arr[@"chatroomid"];
                watchLiveVC.hostUser = Arr[@"roomHostUser"];
                [weakSelf presentViewController:watchLiveVC animated:YES completion:NULL];
            }];
        }
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGFloat height = tableView.sectionHeaderHeight;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//
//    view.layer.shadowColor = [[UIColor blackColor] CGColor];
//    view.layer.shadowOpacity = 0.3;
//    view.layer.shadowOffset = CGSizeMake(0, -1);
//    return view;
//}

#pragma mark - 菜单点击事件
- (void)menuClick:(HotMenuButton *)button{
    [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0)];
    _index = button.tag;
    [self lineViewAnimation];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:button.currentTitle]];
    if (_dataArray.count) {
        NSArray *array = _dataArray[button.tag];
        if (array.count == 0) {
            [self getDataWith];
        }
    }
}

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    cityChooseVC.userLocation = sender.currentTitle;
    
    __weak typeof (self)weekSelf = self;
    cityChooseVC.Location = ^(NSString *location) {
        _userLocation = location;
        [sender setTitle:_userLocation forState:UIControlStateNormal];
        NSDictionary *dict = @{@"city":location};
        [LYUserHttpTool lyLocationCityGetStatusWithParams:dict complete:^(NSDictionary *dict) {
            if (dict) {
                if ([[dict objectForKey:@"cityIsExist"] isEqualToString:@"1"]) {
                    [USER_DEFAULT setObject:[dict objectForKey:@"city"] forKey:@"LocationCityThisTime"];
                    [USER_DEFAULT setObject:[dict objectForKey:@"hasBar"] forKey:@"ThisTimeHasBar"];
                    [USER_DEFAULT setObject:[dict objectForKey:@"hasNightclub"] forKey:@"ThisTimeHasNightClub"];
                }else{
                    [USER_DEFAULT setObject:@"" forKey:@"LocationCityThisTime"];
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"locationCityThisTime" object:nil];
            [weekSelf setupData];
        }];
    };
    
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];
}


#pragma mark 移除导航的按钮和图片
- (void)removeNavButtonAndImageView{
    [_menuView removeObserver:self forKeyPath:@"center"];//移除kvo
    [_titleImageView removeFromSuperview];
    [_searchBtn removeFromSuperview];
    [_cityChooseBtn removeFromSuperview];
    //    [_btn_yedian removeFromSuperview];
    //    [_btn_bar removeFromSuperview];
    [_menuBtnArray enumerateObjectsUsingBlock:^(HotMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_menuBtnArray removeAllObjects];
    [_lineView removeFromSuperview];
    [_menuView removeFromSuperview];
}

//筛选，跳转，增加，删除，确认
#pragma mark 搜索action
- (void)searchClick:(UIButton *)sender {
    
    LYHomeSearcherViewController *homeSearchVC = [[LYHomeSearcherViewController alloc]init];
    if (_index != 2) {//_index != 0 /**/
        homeSearchVC.isSearchBar = YES;
        [self.navigationController pushViewController:homeSearchVC animated:YES];
        
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"搜索酒吧"]];
    }else{
        homeSearchVC.isSearchBar = NO;
        [self.navigationController pushViewController:homeSearchVC animated:YES];
        
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"搜索专属经理"]];
        
    }
}

#pragma mark - 本地加载数据
- (void)getDataLocalAndReload{
    NSMutableArray *array = [self getDataFromLocal].mutableCopy;
    if (array.count==0) {
        return;
    }
    //  LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (array.count == 3) {//顾问的数据
        /*
         NSArray *array_GW = array.firstObject;*/
        
        NSArray *array_GW = [array objectAtIndex:2];
        NSDictionary *dataDic_GW = ((LYCache *)array_GW.firstObject).lyCacheValue;
        if (dataDic_GW==nil) return;
        if (dataDic_GW[@"newbanner"]!=nil) {
            /*
             [_newbannerListArray replaceObjectAtIndex:0 withObject:dataDic_GW[@"newbanner"]];*/
            [_newbannerListArray replaceObjectAtIndex:2 withObject:dataDic_GW[@"newbanner"]];
        }
        
        NSArray *array_VipList = [[NSMutableArray alloc]initWithArray:[UserModel mj_objectArrayWithKeyValuesArray:dataDic_GW[@"viplist"]]];
        /*
         [_dataArray replaceObjectAtIndex:0 withObject:array_VipList];*/
        [_dataArray replaceObjectAtIndex:2 withObject:array_VipList];
        NSArray *bannerArray=dataDic_GW[@"banner"];
        if (bannerArray.count>0) {
            _guWenBannerImgUrl = dataDic_GW[@"banner"][0];
        }
        /*
         [_fiterArray replaceObjectAtIndex:0 withObject:[dataDic_GW valueForKey:@"filterImages"]];*/
        [_fiterArray replaceObjectAtIndex:2 withObject:[dataDic_GW valueForKey:@"filterImages"]];
        /*
         [array removeObjectAtIndex:0];*/
        [array removeObjectAtIndex:2];
        /*
         for (int i = 1; i < array.count+ 1; i ++) {//夜店，酒吧的数据*/
        for (int i = 0; i < array.count - 1; i ++) {
            /*
             NSDictionary *dataDic = ((LYCache *)((NSArray *)array[i-1]).firstObject).lyCacheValue;*/
            NSDictionary *dataDic = ((LYCache *)((NSArray *)array[i]).firstObject).lyCacheValue;
            if(dataDic==nil)continue;
            [_newbannerListArray replaceObjectAtIndex:i withObject:dataDic[@"newbanner"]];
            NSArray *array_Barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            [_fiterArray replaceObjectAtIndex:i withObject:[dataDic valueForKey:@"filterImages"]];
            
            NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
            [_recommendedBarArray replaceObjectAtIndex:i withObject:[JiuBaModel mj_objectWithKeyValues:recommendedBarDic]];
            [_dataArray replaceObjectAtIndex:i withObject:array_Barlist];
            
            /*if(i == 1){*/
            if(i == 0){
                _recommendedTopic = [RecommendedTopic mj_objectWithKeyValues:[dataDic valueForKey:@"recommendedTopic"]];
            }
            else{
                _recommendedTopic2 = [RecommendedTopic mj_objectWithKeyValues:[dataDic valueForKey:@"recommendedTopic"]];
            }
        }
        [_collectionArray enumerateObjectsUsingBlock:^(UICollectionView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj reloadData];
        }];
        
        _isGetDataFromNet_BAR = YES;
        _isGetDataFromNet_YD = YES;
    }
}

#pragma mark - 设置表头
- (void)setTableviewHeader:(NSInteger)tag{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    if (tag == 0) {
        NSArray *array = [_ydDict objectForKey:@"bannerList"];
        for (HomepageBannerModel *model in array) {
            [imageArray addObject:model.img_url];
        }
    }else if (tag == 1){
        NSArray *array = [_barDict objectForKey:@"bannerList"];
        for (HomepageBannerModel *model in array) {
            [imageArray addObject:model.img_url];
        }
    }else if (tag == 2){
        NSArray *array = [_liveDict objectForKey:@"bannerList"];
        for (HomepageBannerModel *model in array) {
            [imageArray addObject:model.img_url];
        }
    }
    EScrollerView *eScrollView = [_scrollViewArray objectAtIndex:_index];
    
    //    [eScrollView configureImagesArray:[self imagesArray]];
    [eScrollView configureImagesArray:imageArray];
}

#pragma mark 获取数据
-(void)getDataWith{
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    __weak __typeof(self) weakSelf = self;
    if (tableView.tag == 2) {
        NSDictionary *dic = @{@"interfaceTypeId":@"4"};
        [LYHomePageHttpTool getBannerListWith:dic complete:^(NSArray *bannerList) {
            [_liveDict setObject:bannerList forKey:@"bannerList"];
            [weakSelf setTableviewHeader:tableView.tag];
            [weakSelf getDataArray:tableView.tag subids:nil];
        }];
    }else if (tableView.tag == 0 || tableView.tag == 1){
        NSString *subids;
        if (tableView.tag == 0) {
            subids = @"2";
        }else if (tableView.tag == 1){
            subids = @"1,6,7";
        }
        NSDictionary *dict = @{@"subids":subids};
        [LYHomePageHttpTool getHomepageFirstScreenDataWith:dict complete:^(NSDictionary *result) {
            if (tableView.tag == 0) {
                [_ydDict setObject:[result objectForKey:@"bannerList"] forKey:@"bannerList"];
                [_ydDict setObject:[result objectForKey:@"recommendedTopic"] forKey:@"recommendedTopic"];
                [_ydDict setObject:[result objectForKey:@"filterImageList"] forKey:@"filterImageList"];
            }else if (tableView.tag == 1){
                [_barDict setObject:[result objectForKey:@"bannerList"] forKey:@"bannerList"];
                [_barDict setObject:[result objectForKey:@"recommendedTopic"] forKey:@"recommendedTopic"];
                [_barDict setObject:[result objectForKey:@"filterImageList"] forKey:@"filterImageList"];
            }
            [tableView reloadData];
            [weakSelf setTableviewHeader:tableView.tag];
            [weakSelf getDataArray:tableView.tag subids:subids];
        }];
    }
}

//获取列表数据
- (void)getDataArray:(NSInteger)tag subids:(NSString *)subids{
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    if (tag == 2) {
        //获取后来的列表
        NSDictionary *dict = @{@"cityCode":@"310000",
                               @"livetype":@"live",
                               @"sort":@"hot",
                               @"page":[_currentPageArray objectAtIndex:tag]};
        [LYFriendsHttpTool getLiveShowlistWithParams:dict complete:^(NSArray *Arr) {
            if ([[_currentPageArray objectAtIndex:tag] intValue] == 1) {
                [_refreshingArray replaceObjectAtIndex:tag withObject:@"0"];
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:Arr];
                [_liveDict setObject:array forKey:@"liveList"];
            }else{
                NSMutableArray *array = [_liveDict objectForKey:@"liveList"];
                [array addObjectsFromArray:Arr];
            }
            [_refreshView stopAnimating];
            if (Arr.count <= 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [tableView.mj_footer endRefreshing];
                [tableView reloadData];
            }
        }];
    }else if (tag == 0 || tag == 1){
        CLLocation *userPosition = [LYUserLocation instance].currentLocation;
        NSDictionary *dict = @{@"latitude":@(userPosition.coordinate.latitude).stringValue,
                               @"longitude":@(userPosition.coordinate.longitude).stringValue,
                               @"city":[USER_DEFAULT objectForKey:@"ChooseCityLastTime"],
                               @"subids":subids,
                               @"sort":@"popularitydesc",
                               @"need_page":@"1",
                               @"p":[_currentPageArray objectAtIndex:tag],
                               @"per":@(PAGESIZE).stringValue};
        [LYHomePageHttpTool getHomepageListDataWith:dict complete:^(NSDictionary *result) {
            if ([[_currentPageArray objectAtIndex:tag] intValue] == 1) {
                [_refreshingArray replaceObjectAtIndex:tag withObject:@"0"];
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"barList"]];
                if (tag == 0) {
                    [_ydDict setObject:[result objectForKey:@"recommendBarList"] forKey:@"recommendBarList"];
                    [_ydDict setObject:array forKey:@"barList"];
                }else{
                    [_barDict setObject:[result objectForKey:@"recommendBarList"] forKey:@"recommendBarList"];
                    [_barDict setObject:array forKey:@"barList"];
                }
            }else{
                NSMutableArray *array;
                if (tag == 0) {
                    array = [_ydDict objectForKey:@"barList"];
                }else if (tag == 1){
                    array = [_barDict objectForKey:@"barList"];
                }
                [array addObjectsFromArray:[result objectForKey:@"barList"]];
            }
            [_refreshView stopAnimating];
            if (((NSArray *)[result objectForKey:@"barList"]).count <= 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [tableView.mj_footer endRefreshing];
                [tableView reloadData];
            }
        }];
    }
}

#pragma mark 本地获取数据
- (NSArray *)getDataFromLocal{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_YD];
    NSPredicate *pre_Bar = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_BAR];
    NSPredicate *pre_GW = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_GUWEN];
    NSArray *array_YD = [[LYCoreDataUtil shareInstance]getCoreData:@"LYCache" withPredicate:pre];
    NSArray *array_Bar = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" withPredicate:pre_Bar];
    NSArray *arry_GW = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" withPredicate:pre_GW];
    /*
     NSArray *array = @[arry_GW,array_YD,array_Bar];*/
    NSArray *array = @[array_YD,array_Bar,arry_GW];
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (void)gotoLiveList:(UIButton *)button{
    LiveListViewController *liveListVC = [[LiveListViewController alloc]init];
    liveListVC.index = button.tag;
    [self.navigationController pushViewController:liveListVC animated:YES];
}

#pragma mark - banner跳转--EScrollView的代理方法
-(void)EScrollerViewDidClicked:(NSUInteger)index{
    UITableView *tableview = [_tableViewArray objectAtIndex:_index];
    NSArray *bannerArray;
    if (tableview.tag == 0) {
        bannerArray = [_ydDict objectForKey:@"bannerList"];
    }else if (tableview.tag == 1){
        bannerArray = [_barDict objectForKey:@"bannerList"];
    }else if (tableview.tag == 2){
        bannerArray = [_liveDict objectForKey:@"bannerList"];
    }
    HomepageBannerModel *bannerModel = [bannerArray objectAtIndex:index];
    NSInteger ad_type = [bannerModel.ad_type integerValue];
    NSInteger linkid = [bannerModel.linkid integerValue];
    //    "ad_type": 1,//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客 5：专题 6:专题活动
    //    "linkid": 1 //对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
    if(ad_type ==1){
        //酒吧
        BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
        controller.beerBarId = [[NSNumber alloc]initWithInteger:linkid];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图酒吧ID%ld",linkid];
        [self.navigationController pushViewController:controller animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if(ad_type ==2){
        //有活动内容才跳转
        if(![MyUtil isEmptyString:bannerModel.linkurl]){
            HuoDongLinkViewController *huodong2=[[HuoDongLinkViewController alloc] init];
            huodong2.linkUrl=bannerModel.linkurl;
            huodong2.title = bannerModel.title == nil ? @"活动详情" : bannerModel.title;
            [self.navigationController pushViewController:huodong2 animated:YES];
            
        }else if (bannerModel.content) {
            HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
            huodong.content = bannerModel.content;
            huodong.title = bannerModel.title == nil ? @"活动详情" : bannerModel.title;
            [self.navigationController pushViewController:huodong animated:YES];
        }
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"活动"]];
    }else if (ad_type ==3){
        //    套餐/3
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[dateFormatter stringFromDate:[NSDate new]];
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
        taoCanXQViewController.title=@"套餐详情";
        taoCanXQViewController.smid = linkid ;
        taoCanXQViewController.dateStr = dateStr;
        [self.navigationController pushViewController:taoCanXQViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图套餐详情ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type ==4){
        //    4：拼客
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        LYPlayTogetherMainViewController *playTogetherMainViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
        playTogetherMainViewController.title=@"我要拼客";
        playTogetherMainViewController.smid = (int)linkid;
        [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图我要拼客ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type ==5){//专题
        if (!linkid) {
            return;
        }
        ActivityMainViewController *activityMainVC = [[ActivityMainViewController alloc]init];
        [self.navigationController pushViewController:activityMainVC animated:YES];
    }else if (ad_type ==6){//专题活动
        if (!linkid) {
            return;
        }
        ActionDetailViewController *activityDetailVC = [[ActionDetailViewController alloc]initWithNibName:@"ActionDetailViewController" bundle:nil];
        activityDetailVC.actionID = [NSString stringWithFormat:@"%ld",linkid];
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }else if (ad_type ==7){//单品
        ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
        CHDetailVC.title=@"吃喝专场";
        CHDetailVC.barid=(int)linkid;
        CHDetailVC.barName=bannerModel.title==nil?[NSString stringWithFormat:@"酒吧%ld",linkid]:bannerModel.title;
        [self.navigationController pushViewController:CHDetailVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图吃喝专场ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type ==8){//组局
        ZujuViewController *zujuVC = [[ZujuViewController alloc]initWithNibName:@"ZujuViewController" bundle:nil];
        zujuVC.title = @"组局";
        zujuVC.barid = (int)linkid;
        [self.navigationController pushViewController:zujuVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图组局ID%ld",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }
}

#pragma mark 热门酒吧跳转
- (void)jumpToHot{
    [self menusClick:0];
}

- (void)jumpToRecent{
    [self menusClick:1];
}

- (void)jumpToStrategy{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        StrategyListViewController *strategyListVC = [[StrategyListViewController alloc]init];
        UITableView *tableview = [_tableViewArray objectAtIndex:_index];
        strategyListVC.type = [NSString stringWithFormat:@"%ld",tableview.tag];
        [self.navigationController pushViewController:strategyListVC animated:YES];
    }
}


- (void)menusClick:(NSInteger) index{
    LYHotBarsViewController *hotBarVC = [[LYHotBarsViewController alloc]init];
    hotBarVC.contentTag = index;
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    switch (tableView.tag) {
        case 0:
        {
            hotBarVC.subidStr = @"2";
            hotBarVC.titleText = @"夜店";
        }
            break;
        case 1:
        {
            hotBarVC.subidStr = @"1,6,7";
            hotBarVC.titleText = @"酒吧";
        }
            break;
    }
    NSArray *picNameArray = @[@"热门",@"附近"];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:picNameArray[index]]];
    [self.navigationController pushViewController:hotBarVC animated:YES];
}

- (void)menusClickCell:(UIButton *)button{
    LYHotBarsViewController *hotBarVC = [[LYHotBarsViewController alloc]init];
    hotBarVC.contentTag = button.tag;
    switch (_index) {
        case 0:
        {
            hotBarVC.subidStr = @"2";
            hotBarVC.titleText = @"夜店";
        }
            break;
        case 1:
        {
            hotBarVC.subidStr = @"1,6,7";
            hotBarVC.titleText = @"酒吧";
        }
            break;
    }
    NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:picNameArray[button.tag]]];
    [self.navigationController pushViewController:hotBarVC animated:YES];
}


#pragma mark 搜索代理
- (void)addCondition:(JiuBaModel *)model{
    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
    
    controller.beerBarId = @(model.barid);
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //    [self.navigationController setNavigationBarHidden:NO];
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    //        [viewController viewWillAppear:animated];
    
}

#pragma mark - cell里的点击按钮事件
- (void)collectBar:(UIButton *)button{
    NSLog(@"%ld",button.tag);
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        JiuBaModel *model ;
        if (tableView.tag == 0) {
            model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:button.tag];
        }else if (tableView.tag == 1){
            model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:button.tag];
        }
        
        NSDictionary * param = @{@"barid":[NSString stringWithFormat:@"%d",model.barid]};
        if (model.isLiked == 1) {
            [[LYHomePageHttpTool shareInstance] unLikeJiuBa:param compelete:^(bool result) {
                //收藏过
                if(result){
                    model.isLiked = 0;
                    model.like_num --;
                    [button setTitle:[NSString stringWithFormat:@"%d",model.like_num] forState:UIControlStateNormal];
                }
            }];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"喜欢" pageName:@"首页酒吧列表" titleName:model.barname]];
        }else{
            [[LYHomePageHttpTool shareInstance] likeJiuBa:param compelete:^(bool result) {
                if (result) {
                    model.isLiked = 1;
                    model.like_num ++;
                    [button setTitle:[NSString stringWithFormat:@"%d",model.like_num] forState:UIControlStateNormal];
                }
                [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"取消喜欢" pageName:@"首页酒吧列表" titleName:model.barname]];
            }];
        }
    }
}

- (void)commentBar:(UIButton *)button{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        _clickedButton = button;
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        JiuBaModel *model ;
        if (tableView.tag == 0) {
            model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:_clickedButton.tag];
        }else if (tableView.tag == 1){
            model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:_clickedButton.tag];
        }
        NSDictionary *dict = @{@"type":@"1",
                               @"barid":[NSString stringWithFormat:@"%d",model.barid]};
        __weak __typeof(self)weakSelf = self;
        [LYUserHttpTool getTopicList:dict complete:^(NSArray *dataList) {
            if (dataList.count) {
                TopicModel *topicModel = [dataList objectAtIndex:0];
                if (topicModel.id.length) {
                    LYFriendsTopicsViewController *friendTopicVC = [[LYFriendsTopicsViewController alloc]init];
                    friendTopicVC.topicTypeId = topicModel.id;
                    friendTopicVC.topicName = topicModel.name;
                    friendTopicVC.commentDelegate = weakSelf;
                    friendTopicVC.isFriendsTopic = NO;
                    friendTopicVC.isFriendToUserMessage = YES;
                    friendTopicVC.isTopic = YES;
                    [weakSelf.navigationController pushViewController:friendTopicVC animated:YES];
                }
            }
        }];
    }
}

- (void)lyBarCommentsSendSuccess{
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    JiuBaModel *model ;
    if (tableView.tag == 0) {
        model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:_clickedButton.tag];
    }else if (tableView.tag == 1){
        model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:_clickedButton.tag];
    }
    
    if (model.commentNum) {
        model.commentNum = model.commentNum + 1;
    }else{
        model.commentNum = 1;
    }
    [_clickedButton setTitle:[NSString stringWithFormat:@"%d条评论",model.commentNum] forState:UIControlStateNormal];
}

- (void)communicateBar:(UIButton *)button{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        UITableView *tableView = [_tableViewArray objectAtIndex:_index];
        JiuBaModel *model ;
        if (tableView.tag == 0) {
            model = [((NSMutableArray *)[_ydDict objectForKey:@"barList"]) objectAtIndex:button.tag];
        }else if (tableView.tag == 1){
            model = [((NSMutableArray *)[_barDict objectForKey:@"barList"]) objectAtIndex:button.tag];
        }
        __weak __typeof(self) weakSelf = self;
        if (!model.hasGroup) {//没有群组--创建
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setValue:[NSString stringWithFormat:@"%d",model.barid] forKey:@"groupId"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *imuserId = app.userModel.imuserId;
            [paraDic setValue:imuserId  forKey:@"userIds"];
            [paraDic setValue:model.barname forKey:@"groupName"];
            [LYYUHttpTool yuCreatGroupWith:paraDic complete:^(NSDictionary *data) {
                BarGroupChatViewController *barChatVC = [[BarGroupChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%d",model.barid]];
                barChatVC.title = [NSString stringWithFormat:@"%@",model.barname];
                barChatVC.groupManage = [model.groupManage componentsSeparatedByString:@","];
                [weakSelf.navigationController pushViewController:barChatVC animated:YES];
                [IQKeyboardManager sharedManager].enable = NO;
                [IQKeyboardManager sharedManager].isAdd = YES;
                
                barChatVC.navigationItem.leftBarButtonItem = [weakSelf getItem];
            }];
        } else {//加入群组
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setValue:[NSString stringWithFormat:@"%d",model.barid] forKey:@"groupId"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *imuserId = app.userModel.imuserId;
            [paraDic setValue:imuserId  forKey:@"userId"];
            [paraDic setValue:model.barname forKey:@"groupName"];
            [LYYUHttpTool yuJoinGroupWith:paraDic complete:^(NSDictionary *data) {
                
                //            NSString *code = data[@"code"];
                BarGroupChatViewController *barChatVC = [[BarGroupChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%d",model.barid]];
                barChatVC.title = [NSString stringWithFormat:@"%@",model.barname];
                barChatVC.groupManage = [model.groupManage componentsSeparatedByString:@","];
                [weakSelf.navigationController pushViewController:barChatVC animated:YES];
                [IQKeyboardManager sharedManager].enable = NO;
                [IQKeyboardManager sharedManager].isAdd = YES;
                
                barChatVC.navigationItem.leftBarButtonItem = [weakSelf getItem];
                
            }];
            
        }
    }
}



- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
