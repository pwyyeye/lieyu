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
#import "LYHotJiuBarViewController.h"
#import "LYCloseMeViewController.h"
#import "bartypeslistModel.h"
#import "LYNavigationController.h"
#import "HuoDongViewController.h"
#import "LYCacheDefined.h"
#import "LYCache+CoreDataProperties.h"
#import "LYUserHttpTool.h"
#import "LYFriendsHttpTool.h"
#import "HomeBarCollectionViewCell.h"
#import "HomeMenuCollectionViewCell.h"
#import "LYHotBarViewController.h"
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
    UIButton *_cityChooseBtn,*_searchBtn;
    UIButton *_titleImageView;
    CGFloat _scale;
    NSInteger _index;//区分夜店和酒吧
    NSMutableArray *_dataArray,*_recommendedBarArray;//酒吧数组 推荐酒吧数组
    NSInteger _currentPage_YD,_currentPage_Bar;//当前夜店的请求起始个数 当前酒吧的请求起始个数
    HotMenuButton *_btn_yedian,*_btn_bar;//夜店按钮 酒吧按钮
    UIView *_lineView;//夜店 酒吧按钮下滑线
    UIVisualEffectView *_navView,*_menuView;//导航 菜单的背景view
    NSArray *_fiterArray;//过滤数字
    
    CGFloat _contentOffSet_Height_YD,_contentOffSet_Height_BAR,_contentOffSetWidth;//夜店表的偏移量 酒吧的表的偏移量
    UICollectionView *_collectView;
    BOOL _isCollectView;//区分大的collectview 和 cell内部的collectview
    
    JiuBaModel *_recommendedBar;//推荐酒吧的Model
    RecommendedTopic *_recommendedTopic;//推荐话题  ？？？？
    NSMutableArray *_newbannerListArray;//AD数组
    
    JiuBaModel *_recommendedBar2;
    RecommendedTopic *_recommendedTopic2;
    NSMutableArray *_newbannerListArray2;

    BOOL _isGetDataFromNet_YD,_isGetDataFromNet_BAR;//判断是否从服务器获取夜店  酒吧的数据
    BOOL _isDragScrollToTop;//是否拖拽至顶部
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList2;
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
    _contentOffSet_Height_BAR = 1;
    _contentOffSet_Height_YD = 1;
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:2];
    _newbannerListArray = [[NSMutableArray alloc]initWithCapacity:2];
    _newbannerListArray2 = [[NSMutableArray alloc]initWithCapacity:2];
    _recommendedBarArray= [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    [_collectView registerNib:[UINib nibWithNibName:@"LYHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYHomeCollectionViewCell"];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    _collectView.scrollsToTop = NO;
    _collectView.pagingEnabled = YES;
    _collectView.bounces = NO;
    _collectView.backgroundColor = [UIColor whiteColor];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_collectView];
    //本地加载数据
    [self getDataLocalAndReload];
    //获取夜店数据
    [self getDataWith:0];
    
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isDragScrollToTop = YES;
    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    switch (_index) {
        case 0:
        {
            _contentOffSet_Height_YD = cell.collectViewInside.contentOffset.y;
        }
            break;
        case 1:
        {
            _contentOffSet_Height_BAR = cell.collectViewInside.contentOffset.y;
        }
            break;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _collectView){
        
            CGFloat offsetWidth = _collectView.contentOffset.x;
            CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
            _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
    }else{
        _menuView.center = _menuView.center;
        if (!_isDragScrollToTop) return;
        LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
        if (_index) {//酒吧下拉超过35菜单显示
            if (-cell.collectViewInside.contentOffset.y + _contentOffSet_Height_BAR > 35) {
                [self showMenuView];
            }else if(cell.collectViewInside.contentOffset.y - _contentOffSet_Height_BAR > 35) {//酒吧上拉超过35菜单隐藏
                if(cell.collectViewInside.contentOffset.y < - 91) return;
                [self hideMenuView];
            }
        }else{
                if (-cell.collectViewInside.contentOffset.y + _contentOffSet_Height_YD > 35) {//夜店下拉超过35菜单显示
                    [self showMenuView];
                }else if(cell.collectViewInside.contentOffset.y - _contentOffSet_Height_YD > 35) {//夜店下拉超过35菜单隐藏
                    if(cell.collectViewInside.contentOffset.y < - 91) return;
                    [self hideMenuView];
                }
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
    _index = (NSInteger)_collectView.contentOffset.x/SCREEN_WIDTH;
    //LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (_dataArray.count) {
        switch (_index) {//判断酒吧 夜店左右切换是否去服务器加载数据
            case 0:{
                if (_isGetDataFromNet_YD) {
                    _isGetDataFromNet_YD = NO;
                    [self getDataWith:0];
                }
            }
                break;
                
            case 1:{
                if (_isGetDataFromNet_BAR) {
                    _isGetDataFromNet_BAR = NO;
                    [self getDataWith:1];
                }
            }
                break;
        }
    }
    
    if (scrollView == _collectView) {
        if (_index) {//酒吧按钮被选择
            _btn_bar.isHomePageMenuViewSelected = YES;
            _btn_yedian.isHomePageMenuViewSelected = NO;
            _lineView.center = CGPointMake(_btn_bar.center.x, _lineView.center.y);
        }else{
            _btn_bar.isHomePageMenuViewSelected = NO;
            _btn_yedian.isHomePageMenuViewSelected = YES;
            _lineView.center = CGPointMake(_btn_yedian.center.x, _lineView.center.y);
        }
    }
    
    _isDragScrollToTop = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//    if (_menuView.center.y < 45) {
//            [cell.collectViewInside setContentInset:COLLECTVIEWEDGETOP];
//    }else{
//            [cell.collectViewInside setContentInset:COLLECTVIEWEDGEDOWN];
//    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//    if (_menuView.center.y < 45) {
//        [cell.collectViewInside setContentInset:COLLECTVIEWEDGETOP];
//    }else{
//        [cell.collectViewInside setContentInset:COLLECTVIEWEDGEDOWN];
//    }

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
    [_cityChooseBtn setTitle:@"上海" forState:UIControlStateNormal];
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
    
    //夜店按钮
    _btn_yedian = [[HotMenuButton alloc]init];
    _btn_yedian.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn_yedian.isHomePageMenuViewSelected = YES;
    [_btn_yedian setTitle:@"夜店" forState:UIControlStateNormal];
    [_menuView addSubview:_btn_yedian];
    [_btn_yedian addTarget:self action:@selector(yedianClick) forControlEvents:UIControlEventTouchUpInside];
    _btn_yedian.frame = CGRectMake(SCREEN_WIDTH/2.f - 44 - 22, _menuView.frame.size.height - 16 - 4.5, 44, 16);
    
    
    //酒吧按钮
    _btn_bar = [[HotMenuButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f + 22, _menuView.frame.size.height - 16 - 4.5, 44, 16)];
    [_btn_bar setTitle:@"酒吧" forState:UIControlStateNormal];
    _btn_bar.isHomePageMenuViewSelected = NO;
    [_btn_bar addTarget:self action:@selector(barClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_btn_bar];
    
    //按钮下滑线
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [_menuView addSubview:_lineView];
    _lineView.frame = CGRectMake(0, _menuView.frame.size.height - 2, 42, 2);
    _lineView.center = CGPointMake(_btn_yedian.center.x, _lineView.center.y);
    
    if (_index) {
        _btn_bar.isHomePageMenuViewSelected = YES;
        _btn_yedian.isHomePageMenuViewSelected = NO;
        _lineView.center = CGPointMake(_btn_bar.center.x, _lineView.center.y);
    }
    [_menuView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

//kvo监听导航的上下改变cell内部collecview的contentInset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIVisualEffectView *effectView = (UIVisualEffectView *)object;
    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    
    if (effectView.center.y == 8) {//上面
        if(cell.collectViewInside.contentInset.top == 91) [cell.collectViewInside setContentInset:COLLECTVIEWEDGETOP];
    }else if (effectView.center.y == 45){
        if(cell.collectViewInside.contentInset.top == 91-40)  [cell.collectViewInside setContentInset:COLLECTVIEWEDGEDOWN];
    }
}

#pragma mark －夜店action
- (void)yedianClick{
    _index = 0;
    [_collectView setContentOffset:CGPointZero animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_yedian.currentTitle]];
    _btn_yedian.isHomePageMenuViewSelected = YES;
    _btn_bar.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        NSArray *array = _dataArray[0];
        if (array.count == 0) {
            [self getDataWith:0];
        }
    }

}

#pragma mark －酒吧action
- (void)barClick{
    _index = 1;
    [_collectView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_bar.currentTitle]];
    _btn_bar.isHomePageMenuViewSelected = YES;
    _btn_yedian.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        if (_isGetDataFromNet_BAR) {
            _isGetDataFromNet_BAR = NO;
            [self getDataWith:1];
        }
    }
}

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];
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
    [_btn_yedian removeFromSuperview];
    [_btn_bar removeFromSuperview];
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

- (void)getDataLocalAndReload{
    NSArray *array = [self getDataFromLocal];
  //  LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (array.count == 2) {
        NSDictionary *dataDic1 = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
         NSDictionary *dataDic2 = ((LYCache *)((NSArray *)array[1]).firstObject).lyCacheValue;
        NSArray *array_YD = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic1[@"barlist"]]] ;
        NSArray *array_BAR = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic2[@"barlist"]]] ;
        _fiterArray = [dataDic1 valueForKey:@"filterImages"];
         NSDictionary *recommendedBarDic1 = [dataDic1 valueForKey:@"recommendedBar"];
                 NSDictionary *recommendedBarDic2 = [dataDic2 valueForKey:@"recommendedBar"];
        if (_index==0) {
            _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic1];
            self.newbannerList = dataDic1[@"newbanner"];

        }else{
            _recommendedBar2 = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic2];
            self.newbannerList2 = dataDic2[@"newbanner"];

        }
        if (_index == 0) {
            [_dataArray replaceObjectAtIndex:0 withObject:array_YD];
        }else{
            [_dataArray replaceObjectAtIndex:1 withObject:array_BAR];
        }
        [_collectView reloadData];
    
        _isGetDataFromNet_BAR = YES;
        _isGetDataFromNet_YD = YES;
    }
}

#pragma mark 获取数据
-(void)getDataWith:(NSInteger)tag{
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeListWith:tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
//         NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@------getData--------@@@@@@@@@@@@@@@@@@@");
         if (Req_Success == ermsg.state)
         {
             //             UICollectionView *collectView = _collectViewArray[_index];
             if (barList.count == PAGESIZE)
             {
                 //                 weakSelf.curPageIndex = 2;
                 switch (tag) {
                     case 0:
                         _currentPage_YD = 2;
                         break;
                     case 1:
                         _currentPage_Bar = 2;
                         break;
                 }
                 
             }else{
                 LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
                 [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
                 //collectView.mj_footer.hidden = YES;
                 //                 [collectView.mj_footer endRefreshingWithNoMoreData];
             }
         }
     }];
}

- (void)loadHomeListWith:(NSInteger)tag block:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block
{
//    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@------loadHomeListWith--------@@@@@@@@@@@@@@@@@@@");
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    //    if (![MyUtil isEmptyString:_cityBtn.titleLabel.text]) {
    //     //  hList.city = _cityBtn.titleLabel.text;
    //    }
    hList.need_page = @(1);
    switch (tag) {
        case 0:
        {
            hList.p = @(_currentPage_YD);
        }
            break;
        case 1:
        {
            hList.p = @(_currentPage_Bar);
        }
            break;
    }
    
    hList.per = @(PAGESIZE);
    if (tag == 0) {
        hList.subids = @"2";
//        hList.bannertypeid=5;
//        hList.bannerTypeName=@"我要玩";

    }else{
        hList.subids = @"1,6,7";
        hList.bannerTypeName=@"一起玩";
    }
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList2:hList pageIndex:_index results:^(LYErrorMessage * ermsg,HomePageModel *homePageM){
//         [_emptyView removeFromSuperview];
        if (ermsg.state == Req_Success)
        {
            if(tag >= 2) return;
            
//            NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@------loadHomeListWithSuccess--------@@@@@@@@@@@@@@@@@@@");
            //            UICollectionView *collectView = _collectViewArray[tag];
            NSMutableArray *array = _dataArray[tag];
            if((tag == 0 && _currentPage_YD == 1) || (tag == 1 && _currentPage_Bar == 1)) {
                [array removeAllObjects];
                weakSelf.bannerList = homePageM.banner.mutableCopy;
                if (_index==0) {
                    weakSelf.newbannerList = homePageM.newbanner.mutableCopy;
                }else{
                    weakSelf.newbannerList2 = homePageM.newbanner.mutableCopy;
                }
                
                weakSelf.bartypeslistArray = homePageM.bartypeslist;
                _fiterArray = homePageM.filterImages;
            }
            if (_index==0) {
                _recommendedBar = homePageM.recommendedBar;
                _recommendedTopic = homePageM.recommendedTopic;
            }else{
                _recommendedBar2 = homePageM.recommendedBar;
                _recommendedTopic2 = homePageM.recommendedTopic;
            }
            
            [array addObjectsFromArray:homePageM.barlist.mutableCopy] ;
            
            LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
            [cell.collectViewInside reloadData];
            
        }
        block !=nil? block(ermsg,homePageM.banner,homePageM.barlist):nil;
    }];   
}

#pragma mark 本地获取数据
- (NSArray *)getDataFromLocal{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_YD];
    NSPredicate *pre_Bar = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE_BAR];
    NSArray *array_YD = [[LYCoreDataUtil shareInstance]getCoreData:@"LYCache" withPredicate:pre];
    NSArray *array_Bar = [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" withPredicate:pre_Bar];
    NSArray *array = @[array_YD,array_Bar];
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
    if(collectionView == _collectView){
        return _dataArray.count;
    }else{
//        NSArray *array =_dataArray[_index];
        LYHomeCollectionViewCell *hcell = (LYHomeCollectionViewCell *)[[collectionView superview] superview];
        if (hcell.jiubaArray.count) {
            return hcell.jiubaArray.count + 4;
        }else{
            //WTT
            return 10;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /* if(indexPath.row >= 2 && indexPath.row <= 5){
     return CGSizeMake((SCREEN_WIDTH - 9)/2.f, (SCREEN_WIDTH - 9)/2.f * 9 / 16);
     }else if(indexPath.row == 0){
     return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16);
     }else{
     return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16);
     } */
    if (collectionView == _collectView) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        if (!_recommendedTopic.id&&_index==0) {
            if (indexPath.item == 3) {
                return CGSizeZero;
            }
        }
        
        if (!_recommendedTopic2.id&&_index==1) {
            if (indexPath.item == 3) {
                return CGSizeZero;
            }
        }
        
        if (indexPath.item==2) {
            return CGSizeMake(SCREEN_WIDTH - 6, ((SCREEN_WIDTH-9)/2)*95/183*2+3);
        }
        return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 /16);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _collectView) {
        return 0;
    }else{
        return 3;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _collectView) {
        return 0;
    }else{
        return 3;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (collectionView == _collectView) {
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(3, 3, 3, 3);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collectView) {//为cell里的collectview注册单元格 以及增加上下拉刷新控件
      __weak LYHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYHomeCollectionViewCell" forIndexPath:indexPath];
        cell.collectViewInside.dataSource = self;
        cell.collectViewInside.delegate = self;
        [cell.collectViewInside registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
        [cell.collectViewInside registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [cell.collectViewInside registerNib:[UINib nibWithNibName:@"HomeMenusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenusCollectionViewCell"];
        cell.collectViewInside.alwaysBounceHorizontal = NO;
        cell.collectViewInside.alwaysBounceVertical = YES;
        cell.collectViewInside.contentInset = UIEdgeInsetsMake(90, 0, 0, 0);
    __weak HomePageINeedPlayViewController *weakSelf = self;
        cell.collectViewInside.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        switch (indexPath.item) {
            case 0:
            {
                _currentPage_YD = 1;
            }
                break;
            case 1:
            {
                _currentPage_Bar = 1;
            }
                break;
        }
        
        [weakSelf loadHomeListWith:_index block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
         {
             if (Req_Success == ermsg.state)
             {
                 if (Req_Success == ermsg.state)
                 {
                     switch (_index) {
                         case 0:
                         {
                             _currentPage_YD = 2;                                                  }
                             break;
                         case 1:{
                             _currentPage_Bar = 2;
                         }
                             break;
                     }
//                         cell.collectViewInside.mj_footer.hidden = NO;
                     [cell.collectViewInside.mj_footer resetNoMoreData];
                     }else{
                         // collectView.mj_footer.hidden = YES;
                         [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
                     }
                     [cell.collectViewInside.mj_header endRefreshing];
             }
                 [cell.collectViewInside.mj_header endRefreshing];
         }];

    
    }];

    MJRefreshGifHeader *header=(MJRefreshGifHeader *)cell.collectViewInside.mj_header;
    [self initMJRefeshHeaderForGif:header];
        
        
        
    cell.collectViewInside.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
            //        switch (indexPath.item) {
            //            case 0:
            //            {
            //                [weakSelf getDataWith:0];
            //            }
            //                break;
            //            case 1:
            //            {
            //                [weakSelf getDataWith:1];
            //            }
            //                break;
            //        }
            
            [weakSelf loadHomeListWith:_index block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
                if (Req_Success == ermsg.state) {
                    if (barList.count == PAGESIZE)
                    {
                        cell.collectViewInside.mj_footer.hidden = NO;
                    }
                    else
                    {
                        // collectView.mj_footer.hidden = YES;
                    }
                    switch (_index) {
                        case 0:
                        {
                            _currentPage_YD ++;
                        }
                            break;
                        case 1:{
                            _currentPage_Bar ++;
                        }
                            break;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(barList.count) [cell.collectViewInside.mj_footer endRefreshing];
                        else [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
                    });
                }
        }];
    }];
        MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)cell.collectViewInside.mj_footer;
        [self initMJRefeshFooterForGif:footer];
        
        return cell;
    }else{
//        LYHomeCollectionViewCell *homeCell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//          LYHomeCollectionViewCell *homeCell = (LYHomeCollectionViewCell *)[[collectionView superview] superview];
        
//        NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@------cellATIndex--------@@@@@@@@@@@@@@@@@@@");
        switch (indexPath.item) {
                case 0:
                {
                    UICollectionViewCell *spaceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                    NSMutableArray *bannerList=[NSMutableArray new];
//                    [cycleScrollView removeFromSuperview];
                   
                    for (NSDictionary *dic in _index==0?self.newbannerList:self.newbannerList2) {
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
                    if (_recommendedTopic.id&&_index==0) {
                    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16)];
                    imageV.layer.cornerRadius = 2;
                    imageV.layer.masksToBounds = YES;
                    imgV.tag = 10010;
                        [imgV sd_setImageWithURL:[NSURL URLWithString: _recommendedTopic.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
                    [cell addSubview:imgV];
                    }
                    
                    if (_recommendedTopic2.id&&_index==1) {
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
                
               /* HomeBarCollectionViewCell *cell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
                return cell; */
            }
                break;
        }
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    if (collectionView != _collectView) {
        
//        NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@------willDisplayCell--------@@@@@@@@@@@@@@@@@@@");
        if (indexPath.item==1) {
            if (_recommendedBar&&_index==0) {
                ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBar;
            }
//            if (_recommendedBar2&&_index==1) {
//                ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBar2;
//            }
                //WTT
            else if (_recommendedBar2&&_index==1) {
                ((HomeBarCollectionViewCell *)cell).jiuBaM =_recommendedBar2;
            }else{
                [((HomeBarCollectionViewCell *)cell).imgView_bg  setImage:[UIImage imageNamed:@"empyImageBar16_9"]];
            }
        }else if(indexPath.item == 2){
            HomeMenusCollectionViewCell *menucell = (HomeMenusCollectionViewCell *)cell;
            if(_fiterArray.count == 4){
            for (int i = 0;i < 4;i++) {
                UIButton *btn = menucell.btnArray[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:_fiterArray[i]] forState:UIControlStateNormal];
//                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [btn addTarget:self action:@selector(menusClickCell:) forControlEvents:UIControlEventTouchUpInside];
            }
            }
            //WTT
            else{
                for (int i = 0;i < 4;i++) {
                    UIButton *btn = menucell.btnArray[i];
                    [btn setImage:[UIImage imageNamed:@"empyImage16_9"] forState:UIControlStateNormal];
                }
            }
        }else if (indexPath.item > 3) {
//            array = _dataArray[_index];
            LYHomeCollectionViewCell *hcell = (LYHomeCollectionViewCell *)[[collectionView superview] superview];
            HomeBarCollectionViewCell *homeCell = (HomeBarCollectionViewCell *)cell;
            if (indexPath.item - 4 >= hcell.jiubaArray.count) {
                [homeCell.imgView_bg setImage:[UIImage imageNamed:@"empyImageBar16_9"]];
                return;
            }
            JiuBaModel *jiubaM = hcell.jiubaArray[indexPath.item - 4];
            homeCell.jiuBaM = jiubaM;
        }
    }else{
        LYHomeCollectionViewCell *hcell = (LYHomeCollectionViewCell *)cell;
        //WTT
        if (_dataArray.count < indexPath.item) {
            return;
        }
        //WTT
        hcell.jiubaArray = _dataArray[indexPath.item];
        if (hcell.collectViewInside) {
            if (_menuView.center.y == 8) {
                [hcell.collectViewInside setContentInset:COLLECTVIEWEDGETOP];
            }else{
                [hcell.collectViewInside setContentInset:COLLECTVIEWEDGEDOWN];
            }
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *jiuBaM = nil;
    NSArray *array = nil;
    if (_dataArray.count) {
        array = _dataArray[_index];
    }
    if(indexPath.item == 1){
        jiuBaM =_index==0? _recommendedBar:_recommendedBar2;
    }else if(indexPath.item == 3){
        if (_index==0) {
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
    }else if(indexPath.item >= 4){
        if(array.count) jiuBaM = array[indexPath.item - 4];
    }else /*if(indexPath.item >= 2&& indexPath.item <= 5)*/ if (indexPath.item == 2){
        return;
        //        LYHotBarViewController *hotJiuBarVC = [[LYHotBarViewController alloc]init];
        LYHotBarsViewController *hotBarVC = [[LYHotBarsViewController alloc]init];
        hotBarVC.contentTag = indexPath.item - 2;
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
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:picNameArray[indexPath.item - 2]]];
        [self.navigationController pushViewController:hotBarVC animated:YES];
        return;
        //        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:titleArray[indexPath.item - 2]]];
    }else{
        return;  
    }
    

    //BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
    if(!jiuBaM.barid) return;
    controller.beerBarId = @(jiuBaM.barid);
    [self.navigationController pushViewController:controller animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
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

#pragma mark 跳转热门酒吧界面
- (void)hotJiuClick:(UIButton *)button{
    LYHotJiuBarViewController *hotJiuBarVC = [[LYHotJiuBarViewController alloc]init];
    NSMutableArray *titleArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0;  i < self.bartypeslistArray.count; i ++) {
        bartypeslistModel *bartypeModel = self.bartypeslistArray[i];
        [titleArray addObject:bartypeModel.name];
    }
    hotJiuBarVC.titleArray = titleArray;
    hotJiuBarVC.middleStr = titleArray[button.tag];
    hotJiuBarVC.bartypeArray = self.bartypeslistArray;
    hotJiuBarVC.subidStr = ((bartypeslistModel *)self.bartypeslistArray[button.tag]).subids;
    [self.navigationController pushViewController:hotJiuBarVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:titleArray[button.tag]]];
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
    NSDictionary *dic =_index==0? _newbannerList [index]:_newbannerList2 [index];
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
