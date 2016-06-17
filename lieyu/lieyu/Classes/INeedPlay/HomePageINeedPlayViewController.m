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
#import "LYGuWenPersonDetailViewController.h"
#import "LYGuWenListViewController.h"
#import "LYHomeGuWenCollectionViewCell.h"
#import "LYGuWenDetailViewController.h"
#import "LYGuWenVideoViewController.h"
#import "LYGuWenBannerCollectionViewCell.h"
#import "LYMyFriendDetailViewController.h"
#import "LYGuWenListViewController.h"

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
,UIScrollViewDelegate>{
    UIButton *_searchBtn;
    UIButton *_titleImageView;
    CGFloat _scale;
    NSInteger _index;//区分夜店和酒吧
    NSMutableArray *_dataArray,*_recommendedBarArray;//酒吧数组 推荐酒吧数组
    NSInteger _currentPage_YD,_currentPage_Bar,_currentPage_GuWen;//当前夜店的请求起始个数 当前酒吧的请求起始个数
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
}
@property (nonatomic,strong) UIButton *cityChooseBtn;//定位城市按钮
@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (nonatomic,strong) NSArray *bartypeslistArray;
@property(nonatomic,assign) NSInteger curPageIndex;
@property (nonatomic,strong) NSArray *hotJiuBarTitle;
@end

@implementation HomePageINeedPlayViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    _currentPage_YD = 1;
    _currentPage_Bar = 1;
    _currentPage_GuWen = 1;
    for (int i = 0; i < 3; i ++) {
        offsetY[i] = 1;
    }
    
    _userLocation = @"上海";
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:3];
    _newbannerListArray = [[NSMutableArray alloc]initWithCapacity:3];
    _recommendedBarArray= [[NSMutableArray alloc]initWithCapacity:3];
    _menuBtnArray = [[NSMutableArray alloc]initWithCapacity:3];
    _fiterArray = [[NSMutableArray alloc]initWithCapacity:3];
    _collectionArray = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i = 0; i < 3; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
        [_newbannerListArray addObject:array];
        JiuBaModel *m = [[JiuBaModel alloc]init];
        [_recommendedBarArray addObject:m];
        [_fiterArray addObject:array];
    }
    
    [self createUI];//布局UI
    
    //本地加载数据
    [self getDataLocalAndReload];
    //获取夜店数据
    [self getDataWith:0];
    
    //加载娱乐顾问数据
    
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        //        self.edgesForExtendedLayout = UIRectEdgeNone;
//        //        self.extendedLayoutIncludesOpaqueBars = NO;
//        //        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
//    [self setupViewStyles];
    //    if (_collectViewArray.count) {
//            [self getDataLocalAndReload];
    //        UICollectionView *collectV = _collectViewArray[0];
    //        [collectV.mj_header beginRefreshing];
    //    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault] ;
}

- (void)createUI{
    _bgScrollView = [[UIScrollView alloc]init];
    _bgScrollView.scrollsToTop = NO;
    _bgScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    [self.view addSubview:_bgScrollView];
    
    for (int i = 0; i < 3; i ++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
        [collectView registerNib:[UINib nibWithNibName:@"LYGuWenBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYGuWenBannerCollectionViewCell"];
        [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [collectView registerNib:[UINib nibWithNibName:@"HomeMenusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenusCollectionViewCell"];
        [collectView registerNib:[UINib nibWithNibName:@"LYGuWenPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell"];
        [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectView.dataSource = self;
        collectView.delegate = self;
        collectView.contentInset = UIEdgeInsetsMake(90, 0, 49, 0);
        
        __weak HomePageINeedPlayViewController *weakSelf = self;
        collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            switch (i) {
                case 0:{
                    _currentPage_GuWen = 1;
                }
                    break;
                case 1:
                {
                    _currentPage_YD = 1;
                }
                    break;
                case 2:
                {
                    _currentPage_Bar = 1;
                }
                    break;
            }
            
            if(!i) {
                [weakSelf getDataWith:i];
            }else{
                [weakSelf getDataWith:i];
              /*  [weakSelf loadHomeListWith:i block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
                 {
                     if (Req_Success == ermsg.state)
                     {
                         if (Req_Success == ermsg.state)
                         {
                             switch (i) {
                                 case 1:
                                 {
                                     _currentPage_YD = 2;                                                  }
                                     break;
                                 case 2:{
                                     _currentPage_Bar = 2;
                                 }
                                     break;
                             }
                             //                         cell.collectViewInside.mj_footer.hidden = NO;
                             [collectView.mj_footer resetNoMoreData];
                         }else{
                             // collectView.mj_footer.hidden = YES;
                             [collectView.mj_footer endRefreshingWithNoMoreData];
                         }
                         [collectView.mj_header endRefreshing];
                     }
                     [collectView.mj_header endRefreshing];
                 }]; */
                
            }
        }];
        
        MJRefreshGifHeader *header=(MJRefreshGifHeader *)collectView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        
        
        
        collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            
            if (!i) {
                _currentPage_GuWen ++;
                [weakSelf getDataWith:i];
            }else{
                [weakSelf loadHomeListWith:i block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
                    if (Req_Success == ermsg.state) {
                        if (barList.count == PAGESIZE)
                        {
                            collectView.mj_footer.hidden = NO;
                        }
                        else
                        {
                            // collectView.mj_footer.hidden = YES;
                        }
                        switch (_index) {
                            case 0:{
                                _currentPage_GuWen ++;
                            }
                                break;
                            case 1:
                            {
                                _currentPage_YD ++;
                            }
                                break;
                            case 2:{
                                _currentPage_Bar ++;
                            }
                                break;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(barList.count) [collectView.mj_footer endRefreshing];
                            else [collectView.mj_footer endRefreshingWithNoMoreData];
                        });
                    }
                }];
            }
        }];
        MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)collectView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
        
        collectView.tag = i;
        collectView.backgroundColor = RGBA(245, 245, 245, 1);
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
        [_bgScrollView addSubview:collectView];
        [_collectionArray addObject:collectView];
    }
    
    [_bgScrollView setContentSize:CGSizeMake(3 * SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    UICollectionView *collectView = _collectionArray[_index];
    [_collectionArray enumerateObjectsUsingBlock:^(UICollectionView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_menuView.center.y == 8) {
            [obj setContentInset:COLLECTVIEWEDGETOP];
        }else{
            [obj setContentInset:COLLECTVIEWEDGEDOWN];
//            [obj setContentOffset:CGPointMake(0, -90)];
        }
    }];
    
    
    _isDragScrollToTop = YES;
    UICollectionView *collectView = _collectionArray[_index];
    offsetY[_index] = collectView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _bgScrollView){
        
//            CGFloat offsetWidth = _collectView.contentOffset.x;
//            CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
//            _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
    }else{
        _menuView.center = _menuView.center;
        if (!_isDragScrollToTop) return;
        UICollectionView *collectView = _collectionArray[_index];
                    if (-collectView.contentOffset.y + offsetY[_index] > 35) {
                        [self showMenuView];
                    }else if(collectView.contentOffset.y - offsetY[_index] > 35) {//酒吧上拉超过35菜单隐藏
                        if(collectView.contentOffset.y < - 91) return;
                        [self hideMenuView];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = (NSInteger)_bgScrollView.contentOffset.x/SCREEN_WIDTH;
    //LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (_dataArray.count) {
        NSArray *arr = _dataArray[_index];
        if (!arr.count) {
            switch (_index) {//判断酒吧 夜店左右切换是否去服务器加载数据
                case 0:{
                    
                }
                case 1:{
                    if (_isGetDataFromNet_YD) {
                        _isGetDataFromNet_YD = NO;
                        
                    }
                }
                    break;
                    
                case 2:{
                    if (_isGetDataFromNet_BAR) {
                        _isGetDataFromNet_BAR = NO;
                    }
                }
                    break;
            }
            [self getDataWith:_index];

        }
            }
    
    if (scrollView == _bgScrollView) {
        
        [_menuBtnArray enumerateObjectsUsingBlock:^(HotMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isHomePageMenuViewSelected = NO;
        }];
        HotMenuButton *btn = _menuBtnArray[_index];
        btn.isHomePageMenuViewSelected = YES;
        _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
        
        for (int i= 0;i < _collectionArray.count;i ++) {
            UICollectionView *collect = _collectionArray[i];
            collect.scrollsToTop = NO;
            if(_index == i) collect.scrollsToTop = YES;
        }
    }
    
    _isDragScrollToTop = NO;
}


#pragma mark 创建导航的按钮(选择城市和搜索)
- (void)createNavButton{
    
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
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 6 + 20, 40, 30)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:_userLocation forState:UIControlStateNormal];
    [_cityChooseBtn setTitleColor:RGBA(1, 1, 1, 1) forState:UIControlStateNormal];
    _cityChooseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cityChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 15, 0, 0)];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_cityChooseBtn];
    
    CGFloat searchBtnWidth = 24;
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH  -20- searchBtnWidth, 20 , searchBtnWidth + 20, searchBtnWidth + 20)];
    [_searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_searchBtn];
    
    //菜单logo
    CGFloat titleImgViewWidth = 40;
    _titleImageView = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - titleImgViewWidth)/2.f , 9.5 + 10, titleImgViewWidth, titleImgViewWidth)];
    [_titleImageView setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [_menuView addSubview:_titleImageView];
    
//    NSArray *btnArray = @[_btnGuWen,_btn_yedian,_btn_bar];
    NSArray *btnTitleArray = @[@"娱乐顾问",@"夜店",@"酒吧"];
    CGFloat btnWidth_2 = 26;
    for (int i = 0; i < btnTitleArray.count; i ++) {
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0) btn.isHomePageMenuViewSelected = YES;
        else btn.isHomePageMenuViewSelected = NO;
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [_menuView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/3.f * i + btnWidth_2 , _menuView.frame.size.height - 16 - 4.5, 2 * btnWidth_2, 16);
        [_menuBtnArray addObject:btn];
    }

    
    //按钮下滑线
    HotMenuButton *guWenBtn = _menuBtnArray.firstObject;
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [_menuView addSubview:_lineView];
    _lineView.frame = CGRectMake(0, _menuView.frame.size.height - 2, 42, 2);
    _lineView.center = CGPointMake(guWenBtn.center.x, _lineView.center.y);
    
    if (_index) {
        HotMenuButton *firstBtn = _menuBtnArray.firstObject;
        firstBtn.isHomePageMenuViewSelected = NO;
        
        HotMenuButton *btn = _menuBtnArray[_index];
        btn.isHomePageMenuViewSelected = YES;
        
        _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
    }
    [_menuView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
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

#pragma mark - 菜单点击事件
- (void)menuClick:(HotMenuButton *)button{
    [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0)];
    _index = button.tag;
    [_menuBtnArray enumerateObjectsUsingBlock:^(HotMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isHomePageMenuViewSelected = NO;
    }];
    button.isHomePageMenuViewSelected = YES;
    _lineView.center = CGPointMake(button.center.x, _lineView.center.y);
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:button.currentTitle]];
    if (_dataArray.count) {
        NSArray *array = _dataArray[button.tag];
        if (array.count == 0) {
            [self getDataWith:button.tag];
        }
    }
}

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    cityChooseVC.userLocation = sender.currentTitle;
    
    __weak typeof (self)weekSelf = self;
    cityChooseVC.Location = ^(NSString *location) {
//        [_cityChooseBtn setTitle:location forState:(UIControlStateNormal)];
        _userLocation = location;
        [weekSelf getDataWith:0];
    };
    
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    
//    LYGuWenListViewController *cityChooseVC = [[LYGuWenListViewController alloc]init];
//    cityChooseVC.contentTag = 1;
//    cityChooseVC.isGuWenListVC = YES;
//    cityChooseVC.subidStr = @"2";
//    cityChooseVC.filterSortFlag = 1;
//    [self.navigationController pushViewController:cityChooseVC animated:YES];
//
//    if (!self.userModel) {
//        [MyUtil showPlaceMessage:@"抱歉，请先登录！"];
//    }else{
//        LYGuWenVideoViewController *cityVC = [[LYGuWenVideoViewController alloc]init];
//        cityVC.isVideoListVC = YES;
//        [self.navigationController pushViewController:cityVC animated:YES];
//    }
    
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];

//    LYGuWenPersonDetailViewController *cityChooseVC = [[LYGuWenPersonDetailViewController alloc]initWithNibName:@"LYGuWenPersonDetailViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:cityChooseVC animated:YES];
    
//    LYGuWenDetailViewController *detailViewController = [[LYGuWenDetailViewController alloc]init];
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

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
    [self.navigationController pushViewController:homeSearchVC animated:YES];
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"搜索"]];
}

#pragma mark - 本地加载数据
- (void)getDataLocalAndReload{
    NSMutableArray *array = [self getDataFromLocal].mutableCopy;

  //  LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (array.count == 3) {//顾问的数据
        NSArray *array_GW = array.firstObject;

        NSDictionary *dataDic_GW = ((LYCache *)array_GW.firstObject).lyCacheValue;
        if (dataDic_GW==nil) return;
        if (dataDic_GW[@"newbanner"]!=nil) {
            [_newbannerListArray replaceObjectAtIndex:0 withObject:dataDic_GW[@"newbanner"]];
        }
        
        NSArray *array_VipList = [[NSMutableArray alloc]initWithArray:[UserModel mj_objectArrayWithKeyValuesArray:dataDic_GW[@"viplist"]]];
        [_dataArray replaceObjectAtIndex:0 withObject:array_VipList];
        NSArray *bannerArray=dataDic_GW[@"banner"];
        if (bannerArray.count>0) {
             _guWenBannerImgUrl = dataDic_GW[@"banner"][0];
        }
        
        [_fiterArray replaceObjectAtIndex:0 withObject:[dataDic_GW valueForKey:@"filterImages"]];
        
        
        [array removeObjectAtIndex:0];
        for (int i = 1; i < array.count+ 1; i ++) {//夜店，酒吧的数据
            NSDictionary *dataDic = ((LYCache *)((NSArray *)array[i-1]).firstObject).lyCacheValue;
            if(dataDic==nil)continue;
            [_newbannerListArray replaceObjectAtIndex:i withObject:dataDic[@"newbanner"]];
            NSArray *array_Barlist = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            [_fiterArray replaceObjectAtIndex:i withObject:[dataDic valueForKey:@"filterImages"]];
            
            NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
            [_recommendedBarArray replaceObjectAtIndex:i withObject:[JiuBaModel mj_objectWithKeyValues:recommendedBarDic]];
            [_dataArray replaceObjectAtIndex:i withObject:array_Barlist];
            
            if(i == 1) _recommendedTopic = [RecommendedTopic mj_objectWithKeyValues:[dataDic valueForKey:@"recommendedTopic"]];
            else _recommendedTopic2 = [RecommendedTopic mj_objectWithKeyValues:[dataDic valueForKey:@"recommendedTopic"]];
        }
        
//         NSDictionary *dataDic2 = ((LYCache *)((NSArray *)array[1]).firstObject).lyCacheValue;
//        NSArray *array_BAR = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic2[@"barlist"]]] ;
//        
//        [_fiterArray replaceObjectAtIndex:2 withObject:[dataDic1 valueForKey:@"filterImages"]];
//         NSDictionary *recommendedBarDic1 = [dataDic1 valueForKey:@"recommendedBar"];
//        
//        if (_index==0) {
//            _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic1];
//
//        }else{
//            _recommendedBar2 = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic2];
//
//        }
        
//        [_collectView reloadData];
        [_collectionArray enumerateObjectsUsingBlock:^(UICollectionView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj reloadData];
        }];
    
        _isGetDataFromNet_BAR = YES;
        _isGetDataFromNet_YD = YES;
    }
}

#pragma mark 获取数据
-(void)getDataWith:(NSInteger)tag{
    UICollectionView *collectionView = _collectionArray[tag];
    if (!tag) {//娱乐顾问数据
        CLLocation * userLocation = [LYUserLocation instance].currentLocation;
        NSDictionary *dic = @{@"city":_userLocation,@"p":[NSString stringWithFormat:@"%d",_currentPage_GuWen],@"per":@(PAGESIZE).stringValue,@"latitude":@(userLocation.coordinate.latitude).stringValue,@"longitude":@(userLocation.coordinate.longitude).stringValue};
        [LYHomePageHttpTool homePageGetGuWenDataWith:dic complete:^(HomePageModel *homePageM) {
            if (_currentPage_GuWen == 1) {
                [_dataArray.firstObject removeAllObjects];
            }
//            if(offsetY[0] == 1){
//                [_dataArray replaceObjectAtIndex:0 withObject:homePageM.viplist];
//            }else{
                [((NSMutableArray *)_dataArray.firstObject) addObjectsFromArray:homePageM.viplist];
//            }
//            _guWenBannerImgUrl = homePageM.banner.firstObject;
            if (homePageM.newbanner.count) {
                [_newbannerListArray replaceObjectAtIndex:tag withObject:homePageM.newbanner];
            }
//            [_newbannerListArray replaceObjectAtIndex:tag withObject:homePageM.newbanner];
            if (homePageM.filterImages.count) {
                [_fiterArray replaceObjectAtIndex:tag withObject:homePageM.filterImages];
            }
//            LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//            [cell.collectViewInside reloadData];
            
            
            if (!homePageM.viplist.count) {
                [collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [collectionView.mj_footer endRefreshing];
            }
            [collectionView.mj_header endRefreshing];
            [collectionView reloadData];
        }];
        return;
    }
    
    
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeListWith:tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (Req_Success == ermsg.state)
             {
                 switch (tag) {
                     case 1:
                     {
                         _currentPage_YD = 2;                                                  }
                         break;
                     case 2:{
                         _currentPage_Bar = 2;
                     }
                         break;
                 }
                 //                         cell.collectViewInside.mj_footer.hidden = NO;
                 [collectionView.mj_footer resetNoMoreData];
             }else{
                 // collectView.mj_footer.hidden = YES;
                 [collectionView.mj_footer endRefreshingWithNoMoreData];
             }
             [collectionView.mj_header endRefreshing];
         }
         [collectionView.mj_header endRefreshing];
     }];
    
}

- (void)loadHomeListWith:(NSInteger)tag block:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block
{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    hList.need_page = @(1);
    switch (tag) {
        case 1:
        {
            hList.p = @(_currentPage_YD);
        }
            break;
        case 2:
        {
            hList.p = @(_currentPage_Bar);
        }
            break;
    }
    
    hList.per = @(PAGESIZE);
    if (tag == 1) {
        hList.subids = @"2";

    }else{
        hList.subids = @"1,6,7";
        hList.bannerTypeName=@"一起玩";
    }
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList2:hList pageIndex:_index results:^(LYErrorMessage * ermsg,HomePageModel *homePageM){
        if (ermsg.state == Req_Success)
        {
            if(tag >= 3) return;
            NSMutableArray *array = _dataArray[tag];
            if((tag == 1 && _currentPage_YD == 1) || (tag == 2 && _currentPage_Bar == 1)) {
                [array removeAllObjects];
                weakSelf.bannerList = homePageM.banner.mutableCopy;
                
                [_newbannerListArray replaceObjectAtIndex:_index withObject:homePageM.newbanner.mutableCopy];
                weakSelf.bartypeslistArray = homePageM.bartypeslist;
                [_fiterArray replaceObjectAtIndex:tag withObject:homePageM.filterImages];
//                [_fiterArray replaceObjectAtIndex:2 withObject:homePageM.filterImages];
            }
            
            [_recommendedBarArray replaceObjectAtIndex:tag withObject:homePageM.recommendedBar];
            if (tag==1) {
                _recommendedTopic = homePageM.recommendedTopic;
            }else{
                _recommendedTopic2 = homePageM.recommendedTopic;
            }
            [array addObjectsFromArray:homePageM.barlist.mutableCopy] ;
            
//            LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//            [cell.collectViewInside reloadData];
            UICollectionView *collectView = _collectionArray[tag];
            [collectView reloadData];
        }
        block !=nil? block(ermsg,homePageM.banner,homePageM.barlist):nil;
    }];   
}

#pragma mark 本地获取数据
- (NSArray *)getDataFromLocal{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_YD];
    NSPredicate *pre_Bar = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_BAR];
    NSPredicate *pre_GW = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_GUWEN];
    NSArray *array_YD = [[LYCoreDataUtil shareInstance]getCoreData:@"LYCache" withPredicate:pre];
    NSArray *array_Bar = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" withPredicate:pre_Bar];
    NSArray *arry_GW = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" withPredicate:pre_GW];
    NSArray *array = @[arry_GW,array_YD,array_Bar];
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!collectionView.tag)    return ((NSArray *)_dataArray[collectionView.tag]).count + 3;
    else return ((NSArray *)_dataArray[collectionView.tag]).count + 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
        if(!collectionView.tag){
            if (!indexPath.item) {
                return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 /16);
            }else if(indexPath.item == 1){
                return CGSizeMake(SCREEN_WIDTH - 6, ((SCREEN_WIDTH-9)/2)*95/183*2+3);
            }else if(indexPath.item == 2){
                return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 118 /369);
            }else{
                return CGSizeMake(SCREEN_WIDTH - 6, 122);
            }
        }
        
        if ([MyUtil isEmptyString:_recommendedTopic.id]&&collectionView.tag==1) {
            if (indexPath.item == 3) {
                return CGSizeZero;
            }
        }
        
        if ([MyUtil isEmptyString:_recommendedTopic2.id]&&collectionView.tag==2) {
            if (indexPath.item == 3) {
                return CGSizeZero;
            }
        }
        
        if (indexPath.item==2) {
            return CGSizeMake(SCREEN_WIDTH - 6, ((SCREEN_WIDTH-9)/2)*95/183*2+3);
        }
        return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 /16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.item){
        UICollectionViewCell *spaceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NSMutableArray *bannerList=[NSMutableArray new];
        
        for (NSDictionary *dic in _newbannerListArray[collectionView.tag]) {
            if ([dic objectForKey:@"img_url"]) {
                [bannerList addObject:[dic objectForKey:@"img_url"]];
            }
        }
        
        UIImageView *imageV = [spaceCell viewWithTag:10010];
        if (imageV) {
            [imageV removeFromSuperview];
        }
        
        UIView *view= [spaceCell viewWithTag:1999];
        [view removeFromSuperview];
        view=nil;
        
        SDCycleScrollView *cycleScrollView  = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, ((SCREEN_WIDTH - 6) * 9) / 16) delegate:self placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
        cycleScrollView.tag=1999;
        cycleScrollView.imageURLStringsGroup =bannerList;// self.bannerList;
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_s"];
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_us"];
        [spaceCell addSubview:cycleScrollView];
        return spaceCell;
    }
    
    if (!collectionView.tag) {//娱乐顾问
        switch (indexPath.item) {
            case 0:
            {
                
            }
                break;
            case 1:{//菜单
                HomeMenusCollectionViewCell *menucell = [collectionView dequeueReusableCellWithReuseIdentifier:@
                                                             "HomeMenusCollectionViewCell"forIndexPath:indexPath];
                return menucell;
            }
                break;
            case 2://banner
            {
                LYGuWenBannerCollectionViewCell *guWenBannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenBannerCollectionViewCell" forIndexPath:indexPath];
//                [guWenBannerCell.imgView_banner sd_setImageWithURL:[NSURL URLWithString:_guWenBannerImgUrl] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
//                guWenBannerCell.imgView_banner.contentMode = UIViewContentModeScaleAspectFill;
                return guWenBannerCell;
            }
                break;
            case 3://活动
            {
                    LYGuWenPersonCollectionViewCell *guWenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell" forIndexPath:indexPath];
                    return guWenCell;
            }
                break;
            default:{
                    LYGuWenPersonCollectionViewCell *guWenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell" forIndexPath:indexPath];
                    return guWenCell;
            }
                break;
        }

    }else{//夜店，酒吧
        switch (indexPath.item) {
            case 0:
            {
            }
                break;
            case 1:{
                HomeBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
                    
                return cell;
            }
                break;
            case 2://菜单
            {
                HomeMenusCollectionViewCell *menucell = [collectionView dequeueReusableCellWithReuseIdentifier:@
                                                         "HomeMenusCollectionViewCell"forIndexPath:indexPath];
                return menucell;
                
            }
                break;
            case 3://活动
            {
                    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                    UIView *view= [cell viewWithTag:1999];
                    [view removeFromSuperview];
                    view=nil;
                    UIImageView *imageV = [cell viewWithTag:10010];
                    if (imageV) {
                        [imageV removeFromSuperview];
                    }
                    if (_recommendedTopic.id&&collectionView.tag==1) {
                        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16)];
                        imageV.layer.cornerRadius = 2;
                        imageV.layer.masksToBounds = YES;
                        imgV.tag = 10010;
                        [imgV sd_setImageWithURL:[NSURL URLWithString: _recommendedTopic.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
                        [cell addSubview:imgV];
                    }
                    if (_recommendedTopic2.id&&collectionView.tag==2) {
                        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16)];
                        imageV.layer.cornerRadius = 2;
                        imageV.layer.masksToBounds = YES;
                        imgV.tag = 10010;
                        [imgV sd_setImageWithURL:[NSURL URLWithString: _recommendedTopic2.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
                        [cell addSubview:imgV];
                    }
                    return cell;
            }
                break;
            default:{
                HomeBarCollectionViewCell *barCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
                return barCell;
            }
                break;
        }

    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!collectionView.tag) {//顾问
        if (indexPath.item == 1) {//菜单
            HomeMenusCollectionViewCell *menucell = (HomeMenusCollectionViewCell *)cell;
            NSArray *filterArray = _fiterArray.firstObject;
            if(filterArray.count == 4){
                for (int i = 0;i < menucell.btnArray.count;i++) {
                    UIButton *btn = menucell.btnArray[i];
                    [btn sd_setImageWithURL:[NSURL URLWithString:filterArray[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(filterGuWenClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else if(indexPath.item == 2){//banner
            
        }else if(indexPath.item >2) {//顾问列表
            NSArray *arr = _dataArray[collectionView.tag];
            if (arr.count) {
                UserModel *userM = arr[indexPath.item - 3];
                LYGuWenPersonCollectionViewCell *guWenCell = (LYGuWenPersonCollectionViewCell *)cell;
                guWenCell.vipModel = userM;
            }
        }
    }else{
        if(indexPath.item == 1){//推荐酒吧
            ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBarArray[collectionView.tag];
//            if (_recommendedBarArray.firstObject&&_index==1) {
//                ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBarArray.firstObject;
//            }else if (_recommendedBarArray[1]&&_index==2) {
//                ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBarArray[1];
//            }else{
//                [((HomeBarCollectionViewCell *)cell).imgView_bg  setImage:[UIImage imageNamed:@"empyImageBar16_9"]];
//            }
        }else if(indexPath.item == 2){//菜单
            HomeMenusCollectionViewCell *menucell = (HomeMenusCollectionViewCell *)cell;
            NSArray *filterArray = _fiterArray[collectionView.tag];
            if(filterArray.count == 4){
                for (int i = 0;i < menucell.btnArray.count;i++) {
                    UIButton *btn = menucell.btnArray[i];
                    [btn sd_setImageWithURL:[NSURL URLWithString:filterArray[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(menusClickCell:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else if(indexPath.item > 3){
            HomeBarCollectionViewCell *homeCell = (HomeBarCollectionViewCell *)cell;
            NSArray *arr = _dataArray[collectionView.tag];
            if (indexPath.item - 4 >= arr.count) {
                [homeCell.imgView_bg setImage:[UIImage imageNamed:@"empyImageBar16_9"]];
                return;
            }else{
                JiuBaModel *jiubaM = arr[indexPath.item - 4];
                homeCell.jiuBaM = jiubaM;
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!collectionView.tag) {//顾问界面点击
        if(indexPath.item > 2){
            NSArray *arr = _dataArray[collectionView.tag];
            if (arr.count) {
                UserModel *userM = arr[indexPath.item - 3];
//                LYGuWenDetailViewController *guWenDetailVC = [[LYGuWenDetailViewController alloc]init];
                LYMyFriendDetailViewController *guWenDetailVC = [[LYMyFriendDetailViewController alloc]init];
                guWenDetailVC.userID = [NSString stringWithFormat:@"%d",userM.userid];
                [self.navigationController pushViewController:guWenDetailVC animated:YES];
            }
        }
    }else{
        JiuBaModel *jiuBaM = nil;
        if(indexPath.item == 1){//推荐酒吧（夜店）
            jiuBaM =_recommendedBarArray[collectionView.tag];
        }else if(indexPath.item == 3){//活动
            if (collectionView.tag==1) {
                if(_recommendedTopic.id){
                    ActionPage *aPage = [[ActionPage alloc]init];
                    aPage.ActionImage = ((UIImageView *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:10010]).image;
                    aPage.topicid = _recommendedTopic.id;
                    [self.navigationController pushViewController:aPage animated:YES];
                }
            }else{
                if(_recommendedTopic2.id){
                    ActionPage *aPage = [[ActionPage alloc]init];
                    aPage.topicid = _recommendedTopic2.id;
                    aPage.ActionImage = ((UIImageView *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:10010]).image;
                    [self.navigationController pushViewController:aPage animated:YES];
                }
            }
            return;
        }else if (indexPath.item > 3){//酒吧列表
            NSArray *array = _dataArray[collectionView.tag];
            if(array.count) jiuBaM = array[indexPath.item - 4];
        }
        BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
        if(!jiuBaM.barid) return;
        controller.beerBarId = @(jiuBaM.barid);
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    
//    JiuBaModel *jiuBaM = nil;
//    NSArray *array = nil;
//    if (_dataArray.count) {
//        array = _dataArray[_index];
//    }
//    if(indexPath.item == 1){
//        jiuBaM =_recommendedBarArray[_index];
//    }else if(indexPath.item == 3){
//        if (_index==1) {
//            if(_recommendedTopic.id){
//                ActionPage *aPage = [[ActionPage alloc]init];
//                aPage.ActionImage = ((UIImageView *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:10010]).image;
//                aPage.topicid = _recommendedTopic.id;
//                [self.navigationController pushViewController:aPage animated:YES];
//            }
//        }else{
//            if(_recommendedTopic2.id){
//                ActionPage *aPage = [[ActionPage alloc]init];
//                aPage.topicid = _recommendedTopic2.id;
//                aPage.ActionImage = ((UIImageView *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:10010]).image;
//                [self.navigationController pushViewController:aPage animated:YES];
//            }
//        }
//        
//        return;
//    }else if(indexPath.item >= 4){
//        if(array.count) jiuBaM = array[indexPath.item - 4];
//    }else /*if(indexPath.item >= 2&& indexPath.item <= 5)*/ if (indexPath.item == 2){
//        return;
//        //        LYHotBarViewController *hotJiuBarVC = [[LYHotBarViewController alloc]init];
//        LYHotBarsViewController *hotBarVC = [[LYHotBarsViewController alloc]init];
//        hotBarVC.contentTag = indexPath.item - 2;
//        switch (_index) {
//            case 0:
//            {
//                hotBarVC.subidStr = @"2";
//                hotBarVC.titleText = @"热门夜店";
//            }
//                break;
//            case 1:
//            {
//                hotBarVC.subidStr = @"1,6,7";
//                hotBarVC.titleText = @"热门酒吧";
//            }
//                break;
//        }
//        NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
//        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:picNameArray[indexPath.item - 2]]];
//        [self.navigationController pushViewController:hotBarVC animated:YES];
//        return;
//        //        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:titleArray[indexPath.item - 2]]];
//    }else{
//        return;  
//    }
//    
//
//    //BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
//    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
//    if(!jiuBaM.barid) return;
//    controller.beerBarId = @(jiuBaM.barid);
//    [self.navigationController pushViewController:controller animated:YES];
//    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
}

#pragma mark - 顾问筛选界面跳转
- (void)filterGuWenClick:(UIButton *)button{
    if(button.tag < 3){
        LYGuWenListViewController *guWenListVC = [[LYGuWenListViewController alloc]init];
        guWenListVC.filterSortFlag = button.tag;
        guWenListVC.filterSexFlag = 2;
        guWenListVC.filterAreaFlag = 0;
        guWenListVC.cityName = @"上海";
        guWenListVC.isGuWenListVC = YES;
        guWenListVC.contentTag = button.tag;
//        guWenListVC.subidStr = @"2";
        [self.navigationController pushViewController:guWenListVC animated:YES];
    }else{
        if (!self.userModel) {
            [MyUtil showPlaceMessage:@"抱歉，请先登录！"];
        }else{
            LYGuWenVideoViewController *cityVC = [[LYGuWenVideoViewController alloc]init];
            cityVC.isVideoListVC = YES;
            [self.navigationController pushViewController:cityVC animated:YES];
        }
    }
    
}

#pragma mark 热门酒吧跳转
- (void)menusClickCell:(UIButton *)button{
    LYHotBarsViewController *hotBarVC = [[LYHotBarsViewController alloc]init];
    hotBarVC.contentTag = button.tag;
    switch (_index) {
        case 0:
        {
            hotBarVC.subidStr = @"2";
            hotBarVC.titleText = @"热门夜店";
        }
            break;
        case 1:
        {
            hotBarVC.subidStr = @"1,6,7";
            hotBarVC.titleText = @"热门酒吧";
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

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dic =_newbannerListArray[_index][index];
    NSNumber *ad_type=[dic objectForKey:@"ad_type"];
    NSNumber *linkid=[dic objectForKey:@"linkid"];
    //    "ad_type": 1,//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客 5：专题 6:专题活动
    //    "linkid": 1 //对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
    if(ad_type.intValue ==1){
        //酒吧
        BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
        
        controller.beerBarId = linkid;
        NSString *str = [NSString stringWithFormat:@"首页滑动视图酒吧ID%@",linkid];
        [self.navigationController pushViewController:controller animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if(ad_type.intValue ==2){
        //有活动内容才跳转
        if(![MyUtil isEmptyString:[dic objectForKey:@"linkurl"]]){
            HuoDongLinkViewController *huodong2=[[HuoDongLinkViewController alloc] init];
            huodong2.linkUrl=[dic objectForKey:@"linkurl"];
            huodong2.title=[dic objectForKey:@"title"]==nil?@"活动详情":[dic objectForKey:@"title"];
            [self.navigationController pushViewController:huodong2 animated:YES];
            
        }else if ([dic objectForKey:@"content"]) {
            HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
            huodong.content=[dic objectForKey:@"content"];
            huodong.title=[dic objectForKey:@"title"]==nil?@"活动详情":[dic objectForKey:@"title"];
            [self.navigationController pushViewController:huodong animated:YES];
        }
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"活动"]];
    }else if (ad_type.intValue ==3){
        //    套餐/3
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[dateFormatter stringFromDate:[NSDate new]];
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
        taoCanXQViewController.title=@"套餐详情";
        taoCanXQViewController.smid=linkid.intValue;
        taoCanXQViewController.dateStr=dateStr;
        [self.navigationController pushViewController:taoCanXQViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图套餐详情ID%@",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type.intValue ==4){
        //    4：拼客
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        LYPlayTogetherMainViewController *playTogetherMainViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
        playTogetherMainViewController.title=@"我要拼客";
        playTogetherMainViewController.smid=linkid.intValue;
        [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图我要拼客ID%@",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type.intValue ==5){//专题
        if (linkid==nil) {
            return;
        }
        ActionPage *actionPage=[[ActionPage alloc] initWithNibName:@"ActionPage" bundle:nil];
        actionPage.topicid=[linkid stringValue];
        [self.navigationController pushViewController:actionPage animated:YES];
    }else if (ad_type.intValue ==6){//专题活动
        if (linkid==nil) {
            return;
        }
        ActionDetailViewController *actionDetailVC = [[ActionDetailViewController alloc]init];
//        actionDetailVC.barActivity = aBarList;
        actionDetailVC.actionID=[linkid stringValue];
        [self.navigationController pushViewController:actionDetailVC animated:YES];
    }else if (ad_type.intValue ==7){//单品
        ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
        CHDetailVC.title=@"吃喝专场";
        CHDetailVC.barid=linkid.intValue;
        CHDetailVC.barName=[dic objectForKey:@"title"]==nil?[NSString stringWithFormat:@"酒吧%@",linkid]:[dic objectForKey:@"title"];
        [self.navigationController pushViewController:CHDetailVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图吃喝专场ID%@",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (ad_type.intValue ==8){//组局
        ZujuViewController *zujuVC = [[ZujuViewController alloc]initWithNibName:@"ZujuViewController" bundle:nil];
        zujuVC.title = @"组局";
        zujuVC.barid = linkid.intValue;
        [self.navigationController pushViewController:zujuVC animated:YES];
        NSString *str = [NSString stringWithFormat:@"首页滑动视图组局ID%@",linkid];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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

@end
