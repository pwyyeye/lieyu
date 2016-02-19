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
#import "BeerBarDetailViewController.h"
#import "BearBarListViewController.h"
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

#define PAGESIZE 20
#define HOMEPAGE_MTA @"HOMEPAGE"
#define HOMEPAGE_TIMEEVENT_MTA @"HOMEPAGE_TIMEEVENT"

@interface HomePageINeedPlayViewController ()
<EScrollerViewDelegate,SDCycleScrollViewDelegate,
UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
,UIScrollViewDelegate>{
    UIButton *_cityChooseBtn,*_searchBtn;
    UIImageView *_titleImageView;
    CGFloat _scale;
    NSInteger _index;
    NSMutableArray *_dataArray,*_recommendedBarArray;
    NSInteger _currentPage_YD,_currentPage_Bar;
    HotMenuButton *_btn_yedian,*_btn_bar;
    UIView *_lineView;
    UIVisualEffectView *_navView,*_menuView;
    NSArray *_fiterArray;
    JiuBaModel *_recommendedBar;
    CGFloat _contentOffSet_Height_YD,_contentOffSet_Height_BAR,_contentOffSetWidth;
    UICollectionView *_collectView;
    BOOL _isCollectView;
    RecommendedTopic *_recommendedTopic;
    NSMutableArray *_newbannerListArray;
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (nonatomic,strong) NSArray *bartypeslistArray;
@property(nonatomic,assign) NSInteger curPageIndex;
@property (nonatomic,strong) NSArray *hotJiuBarTitle;
@end

@implementation HomePageINeedPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavButton];
    _currentPage_YD = 1;
    _currentPage_Bar = 1;
    _contentOffSet_Height_BAR = 1;
    _contentOffSet_Height_YD = 1;
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:2];
    _newbannerListArray = [[NSMutableArray alloc]initWithCapacity:2];
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
    _collectView.pagingEnabled = YES;
    _collectView.bounces = NO;
    _collectView.backgroundColor = [UIColor whiteColor];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_collectView];
    
    [self getDataWith:0];
    
    //    for (int i = 0; i < 2; i ++) {
    //
    //        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    //        collectView.backgroundColor = RGBA(243, 243, 243, 1);
    //        collectView.tag = i;
    //            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //            [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
    //            [collectView registerNib:[UINib nibWithNibName:@"HomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenuCollectionViewCell"];
    //        [collectView registerNib:[UINib nibWithNibName:@"HomeMenusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenusCollectionViewCell"];
    //        [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
    //        collectView.dataSource = self;
    //        collectView.delegate = self;
    //        [_collectViewArray addObject:collectView];
    //        [_scrollView addSubview:collectView];
    //        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _collectViewArray.count, 0)];
    //    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.extendedLayoutIncludesOpaqueBars = NO;
        //        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self setupViewStyles];
    //    if (_collectViewArray.count) {
    //        [self getDataLocalAndReload];
    //        UICollectionView *collectV = _collectViewArray[0];
    //        [collectV.mj_header beginRefreshing];
    //    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault] ;
    
    //     self.navigationController.delegate=self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
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
    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (_menuView.center.y < 45) {
        [UIView animateWithDuration:0.3 animations:^{
            
        [cell.collectViewInside setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [cell.collectViewInside setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _collectView){
        
            CGFloat offsetWidth = _collectView.contentOffset.x;
            CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
            _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
    }else{
        LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
        if (_index) {
            if (-cell.collectViewInside.contentOffset.y + _contentOffSet_Height_BAR > 90) {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    _menuView.center = CGPointMake(_menuView.center.x,45);
                    _titleImageView.alpha = 1.0;
                    _cityChooseBtn.alpha = 1.f;
                    _searchBtn.alpha = 1.f;
                }completion:nil];
            }else if(cell.collectViewInside.contentOffset.y - _contentOffSet_Height_BAR > 90) {
                [UIView animateWithDuration:0.3 animations:^{
                    _menuView.center = CGPointMake( _menuView.center.x,8 );
                    _titleImageView.alpha = 0.0;
                    _cityChooseBtn.alpha = 0.f;
                    _searchBtn.alpha = 0.f;
                } completion:nil];
            }
        }else{
                if (-cell.collectViewInside.contentOffset.y + _contentOffSet_Height_YD > 90) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _menuView.center = CGPointMake(_menuView.center.x,45);
                        _titleImageView.alpha = 1.0;
                        _cityChooseBtn.alpha = 1.f;
                        _searchBtn.alpha = 1.f;
                    }completion:^(BOOL finished) {
//                        cell.collectViewInside.contentInset = UIEdgeInsetsMake(91, 0, 0, 0);
                    }];
                }else if(cell.collectViewInside.contentOffset.y - _contentOffSet_Height_YD > 90) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _menuView.center = CGPointMake( _menuView.center.x,8 );
                        _titleImageView.alpha = 0.0;
                        _cityChooseBtn.alpha = 0.f;
                        _searchBtn.alpha = 0.f;
                    } completion:^(BOOL finished) {
//                            cell.collectViewInside.contentInset = UIEdgeInsetsMake(91 - 40, 0, 0, 0);
                    }];
                }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = (NSInteger)_collectView.contentOffset.x/SCREEN_WIDTH;
    LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    if (_dataArray.count) {
        NSArray *array = _dataArray[_index];
        if(!array.count) {
//            [cell.collectViewInside.mj_header beginRefreshing];
            [self getDataWith:_index];
        }
    }
    
    if (scrollView == _collectView) {
        if (_index) {
            _btn_bar.isHomePageMenuViewSelected = YES;
            _btn_yedian.isHomePageMenuViewSelected = NO;
            _lineView.center = CGPointMake(_btn_bar.center.x, _lineView.center.y);
        }else{
            _btn_bar.isHomePageMenuViewSelected = NO;
            _btn_yedian.isHomePageMenuViewSelected = YES;
            _lineView.center = CGPointMake(_btn_yedian.center.x, _lineView.center.y);
        }
    }
}


#pragma mark 创建导航的按钮(选择城市和搜索)
- (void)createNavButton{
    UIBlurEffect *effectExtraLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIBlurEffect *effectLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    /* UIVisualEffectView *bottomView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
     bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
     [self.view addSubview:bottomView]; */
    
    /* _navView = [[UIVisualEffectView alloc]initWithEffect:effect];
     _navView.alpha = 5;
     _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
     [self.navigationController.navigationBar addSubview:_navView];*/
    

    
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.alpha = 5;
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 6 + 20, 40, 30)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:@"上海" forState:UIControlStateNormal];
    [_cityChooseBtn setTitleColor:RGBA(1, 1, 1, 1) forState:UIControlStateNormal];
    _cityChooseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cityChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 15, 0, 0)];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_cityChooseBtn];
    
    CGFloat searchBtnWidth = 24;
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - searchBtnWidth, 10 + 20, searchBtnWidth, searchBtnWidth)];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_searchBtn];
    
    CGFloat titleImgViewWidth = 40;
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - titleImgViewWidth)/2.f , 9.5 + 10, titleImgViewWidth, titleImgViewWidth)];
    _titleImageView.image = [UIImage imageNamed:@"logo"];
    [_menuView addSubview:_titleImageView];
    
    __block HomePageINeedPlayViewController *weakSelf = self;
    _btn_yedian = [[HotMenuButton alloc]init];
    _btn_yedian.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn_yedian.isHomePageMenuViewSelected = YES;
    [_btn_yedian setTitle:@"夜店" forState:UIControlStateNormal];
    [_menuView addSubview:_btn_yedian];
    [_btn_yedian addTarget:self action:@selector(yedianClick) forControlEvents:UIControlEventTouchUpInside];
    _btn_yedian.frame = CGRectMake(SCREEN_WIDTH/2.f - 44 - 22, _menuView.frame.size.height - 16 - 4.5, 44, 16);
    
    _btn_bar = [[HotMenuButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f + 22, _menuView.frame.size.height - 16 - 4.5, 44, 16)];
    [_btn_bar setTitle:@"酒吧" forState:UIControlStateNormal];
    _btn_bar.isHomePageMenuViewSelected = NO;
    [_btn_bar addTarget:self action:@selector(barClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_btn_bar];
    
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
    
}

//- (void)homeScrollToTop{
//    UICollectionView *collectView = _collectViewArray[_index];
//    [collectView setContentOffset:CGPointZero animated:YES];
//}

#pragma mark －夜店action
- (void)yedianClick{
    _index = 0;
    [_collectView setContentOffset:CGPointZero animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_yedian.currentTitle]];
    _btn_yedian.isHomePageMenuViewSelected = YES;
    _btn_bar.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        NSArray *array = _dataArray[0];
        if (!array.count) {
            [self getDataWith:0];
        }
    }
    
    //    if (_menuView.center.y < 45) {
    //        for (UICollectionView *collectView in _collectViewArray) {
    //            [collectView setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
    //        }
    //    }else{
    //        for (UICollectionView *collectView in _collectViewArray) {
    //            [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
    //        }
    //    }
}

#pragma mark －酒吧action
- (void)barClick{
    _index = 1;
    [_collectView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_bar.currentTitle]];
    _btn_bar.isHomePageMenuViewSelected = YES;
    _btn_yedian.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        NSArray *array = _dataArray[1];
        if (!array.count) {
            [self getDataWith:1];
        }
    }
    //    if (CGRectGetMaxY(_menuView.frame) < 90) {
    //        for (UICollectionView *collectView in _collectViewArray) {
    //            //[collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0) ]  ;
    //        }
    //    }
    //
    //    if (_menuView.center.y < 45) {
    //        for (UICollectionView *collectView in _collectViewArray) {
    //            [collectView setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
    //        }
    //    }else{
    //        for (UICollectionView *collectView in _collectViewArray) {
    //            [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
    //        }
    //    }
}

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
   /* _index = 0;
    [_collectView setContentOffset:CGPointZero]; */
    [self createNavButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNavButtonAndImageView];
    
    self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
    //    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 移除导航的按钮和图片
- (void)removeNavButtonAndImageView{
    [_titleImageView removeFromSuperview];
    [_searchBtn removeFromSuperview];
    [_cityChooseBtn removeFromSuperview];
    //    [_navView removeFromSuperview];
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
    UICollectionView *collectView = nil;
    if (array.count == 2) {
        if (((NSArray *)array[0]).count) {
            NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
            NSArray *array_YD = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            self.bannerList = dataDic[@"banner"];
            self.newbannerList = dataDic[@"newbanner"];
            self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
            _fiterArray = [dataDic valueForKey:@"filterImages"];
            NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
            _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
            [_dataArray replaceObjectAtIndex:0 withObject:array_YD];
            //            collectView = _collectViewArray[0];
        }else if(((NSArray *)array[1]).count){
            NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
            NSArray *array_BAR = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            self.bannerList = dataDic[@"banner"];
            self.newbannerList = dataDic[@"newbanner"];
            self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
            _fiterArray = [dataDic valueForKey:@"filterImages"];
            NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
            _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
            [_dataArray replaceObjectAtIndex:1 withObject:array_BAR];
            //            collectView = _collectViewArray[1];
        }
        [collectView reloadData];
    }
}

#pragma mark 获取数据
-(void)getDataWith:(NSInteger)tag{
    if([MyUtil configureNetworkConnect] == 0){
        NSArray *array = [self getDataFromLocal];
        UICollectionView *collectView = nil;
        if (array.count == 2) {
            if (((NSArray *)array[0]).count) {
                NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
                NSArray *array_YD = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
                self.bannerList = dataDic[@"banner"];
                self.newbannerList = dataDic[@"newbanner"];
                self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
                _fiterArray = [dataDic valueForKey:@"filterImages"];
                NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
                _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
                [_dataArray replaceObjectAtIndex:0 withObject:array_YD];
                //                collectView = _collectViewArray[0];
            }else if(((NSArray *)array[1]).count){
                NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
                NSArray *array_BAR = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
                self.bannerList = dataDic[@"banner"];
                self.newbannerList = dataDic[@"newbanner"];
                self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
                _fiterArray = [dataDic valueForKey:@"filterImages"];
                NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
                _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
                [_dataArray replaceObjectAtIndex:1 withObject:array_BAR];
                //                collectView = _collectViewArray[1];
            }
            [collectView reloadData];
            /*[UIView transitionWithView:collectView
             duration: 0.6f
             options: UIViewAnimationOptionTransitionCrossDissolve
             animations: ^(void){
             [collectView reloadData];
             }completion: ^(BOOL isFinished){
             
             }]; */
            return;
        }
    }
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeListWith:tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
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
    }else{
        hList.subids = @"1,6,7";
    }
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList2:hList pageIndex:_index results:^(LYErrorMessage * ermsg,HomePageModel *homePageM){
        if (ermsg.state == Req_Success)
        {
            if(tag >= 2) return;
            //            UICollectionView *collectView = _collectViewArray[tag];
            NSMutableArray *array = _dataArray[tag];
            if((tag == 0 && _currentPage_YD == 1) || (tag == 1 && _currentPage_Bar == 1)) {
                [array removeAllObjects];
                weakSelf.bannerList = homePageM.banner.mutableCopy;
                weakSelf.newbannerList = homePageM.newbanner.mutableCopy;
                weakSelf.bartypeslistArray = homePageM.bartypeslist;
                _fiterArray = homePageM.filterImages;
            }
            _recommendedBar = homePageM.recommendedBar;
            _recommendedTopic = homePageM.recommendedTopic;
            [array addObjectsFromArray:homePageM.barlist.mutableCopy] ;
            
            LYHomeCollectionViewCell *cell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
            [cell.collectViewInside reloadData];
//            cell.recommendedBar = _recommendedBarArray[_index];
//            cell.recommendedBar = homePageM.recommendedBar;
//            cell.bannerList = homePageM.banner;
//            cell.fiterArray = _fiterArray;
            
            //            [collectView reloadData];
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

- (void)setupViewStyles
{
    [self installFreshEvent];
    
}

- (void)installFreshEvent
{
    /*  for (UICollectionView *collectView in _collectViewArray) {
     __weak HomePageINeedPlayViewController * weakSelf = self;
     collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
     ^{
     switch (collectView.tag) {
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
     [weakSelf loadHomeListWith:collectView.tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
     if (Req_Success == ermsg.state)
     {
     if (barList.count == PAGESIZE)
     {
     switch (collectView.tag) {
     case 0:
     {
     _currentPage_YD = 2;                                                  }
     break;
     case 2:{
     _currentPage_Bar = 2;
     }
     }
     collectView.mj_footer.hidden = NO;
     }else{
     // collectView.mj_footer.hidden = YES;
     [collectView.mj_footer endRefreshingWithNoMoreData];
     }
     [collectView.mj_header endRefreshing];
     }
     }];
     }];
     MJRefreshGifHeader *header=(MJRefreshGifHeader *)collectView.mj_header;
     [self initMJRefeshHeaderForGif:header];
     
     collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
     [weakSelf loadHomeListWith:collectView.tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
     if (Req_Success == ermsg.state) {
     if (barList.count == PAGESIZE)
     {
     collectView.mj_footer.hidden = NO;
     }
     else
     {
     // collectView.mj_footer.hidden = YES;
     }
     switch (collectView.tag) {
     case 0:
     {
     _currentPage_YD ++;
     }
     break;
     case 1:{
     _currentPage_Bar ++;
     }
     }
     if(barList.count) [collectView.mj_footer endRefreshing];
     else [collectView.mj_footer endRefreshingWithNoMoreData];
     }
     }];
     }];
     MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)collectView.mj_footer;
     [self initMJRefeshFooterForGif:footer];
     } */
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
            return 0;
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
        if (!_recommendedTopic.id) {
            if (indexPath.item == 3) {
                return CGSizeZero;
            }
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
        return UIEdgeInsetsMake(0,0,0,0);
    }else{
        return UIEdgeInsetsMake(3, 3, 3, 3);
    }
    
}

/*
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 if(indexPath.row == 0){
 UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
 [[cell viewWithTag:1999] removeFromSuperview];
 
 NSMutableArray *bigArr=[[NSMutableArray alloc]init];
 for (NSString *iconStr in self.bannerList) {
 NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
 [dicTemp setObject:iconStr forKey:@"ititle"];
 [dicTemp setObject:@"" forKey:@"mainHeading"];
 [bigArr addObject:dicTemp];
 }
 
 // UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(3, 0, SCREEN_WIDTH - 6, ((SCREEN_WIDTH - 6) * 9) / 16)];
 //        shadowView.tag = 10086;
 //        shadowView.layer.cornerRadius = 2;
 //        shadowView.layer.cornerRadius = 2;
 //        shadowView.layer.shadowColor = RGBA(0, 0, 0, .2).CGColor;
 //        shadowView.layer.shadowOffset = CGSizeMake(0, .5);
 //        shadowView.layer.shadowRadius = 1;
 //        shadowView.layer.shadowOpacity = 1;
 // [cell addSubview:shadowView];
 
 SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, ((SCREEN_WIDTH - 6) * 9) / 16) delegate:self placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
 cycleScrollView.layer.cornerRadius = 2;
 cycleScrollView.layer.masksToBounds = YES;
 
 cycleScrollView.imageURLStringsGroup = self.bannerList;
 cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_s"];
 cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_us"];
 [cell addSubview:cycleScrollView];
 
 //        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH * 9)/16)
 //                                                              scrolArray:[NSArray arrayWithArray:[bigArr copy]] needTitile:YES];
 //        scroller.delegate=self;
 //        scroller.tag=1999;
 //        [cell addSubview:scroller];
 
 return cell;
 }else if(indexPath.row == 1){
 HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
 if(_recommendedBar){
 jiubaCell.jiuBaM = _recommendedBar;
 }
 return jiubaCell;
 
 }else if(indexPath.row == 2){  //if(indexPath.row >= 2 & indexPath.row <= 5){
 //  NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
 /*       HomeMenuCollectionViewCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCollectionViewCell" forIndexPath:indexPath];
 //        menuCell.layer.cornerRadius = 2;
 //        menuCell.layer.masksToBounds = YES;
 //  [menuCell.imgView_title setImage:[UIImage imageNamed:picNameArray[indexPath.row - 2]]];
 //   if(picNameArray.count == 4) menuCell.label_title.text = picNameArray[indexPath.row - 2];
 if(_fiterArray.count == 4) [menuCell.imgView_bg sd_setImageWithURL:[NSURL URLWithString:_fiterArray[indexPath.row - 2]] placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
 return menuCell;
 
 HomeMenusCollectionViewCell *menucell = [collectionView dequeueReusableCellWithReuseIdentifier:@
 "HomeMenusCollectionViewCell"forIndexPath:indexPath];
 for (int i = 0;i < 4;i++) {
 UIButton *btn = menucell.btnArray[i];
 [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:_fiterArray[i]] forState:UIControlStateNormal];
 [btn addTarget:self action:@selector(menusClickCell:) forControlEvents:UIControlEventTouchUpInside];
 }
 return menucell;
 }else{
 HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
 if(_dataArray.count){
 NSArray *array = _dataArray[collectionView.tag];
 if(array.count){
 JiuBaModel *jiuBaM = array[indexPath.row - 3];
 jiubaCell.jiuBaM = jiuBaM;
 }
 }
 return jiubaCell;
 }
 
 } */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collectView) {
        LYHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYHomeCollectionViewCell" forIndexPath:indexPath];
        
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
                    }
                    if(barList.count) [cell.collectViewInside.mj_footer endRefreshing];
                    else [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
                }
        }];
    }];
        MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)cell.collectViewInside.mj_footer;
        [self initMJRefeshFooterForGif:footer];
        
        return cell;
    }else{
//        LYHomeCollectionViewCell *homeCell = (LYHomeCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
          LYHomeCollectionViewCell *homeCell = (LYHomeCollectionViewCell *)[[collectionView superview] superview];
            switch (indexPath.item) {
                case 0:
                {
                    UICollectionViewCell *spaceCell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, ((SCREEN_WIDTH - 6) * 9) / 16) delegate:self placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
                    NSMutableArray *bannerList=[NSMutableArray new];
                    for (NSDictionary *dic in self.newbannerList) {
                        if ([dic objectForKey:@"img_url"]) {
                            [bannerList addObject:[dic objectForKey:@"img_url"]];
                        }
                    }
                    cycleScrollView.imageURLStringsGroup =bannerList;// self.bannerList;
                    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_s"];
                    cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_us"];
                    [spaceCell addSubview:cycleScrollView];
                    return spaceCell;
            }
                break;
            case 1:{
                HomeBarCollectionViewCell *cell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
                if (_recommendedBar) {
                    cell.jiuBaM = _recommendedBar;
                }
                return cell;
                }
                    break;
            case 2://才当
            {
                HomeMenusCollectionViewCell *menucell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@
                                                         "HomeMenusCollectionViewCell"forIndexPath:indexPath];
                return menucell;
               
            }
                break;
                case 3:
                {
                    UICollectionViewCell *cell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                    UIImageView *imageV = [cell viewWithTag:10010];
                    if (imageV) {
                        [imageV removeFromSuperview];
                    }
                    if (_recommendedTopic.id) {
                    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16)];
                    imageV.layer.cornerRadius = 2;
                    imageV.layer.masksToBounds = YES;
                    imgV.tag = 10010;
                    [imgV sd_setImageWithURL:[NSURL URLWithString:_recommendedTopic.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                    [cell addSubview:imgV];
                    }
                    return cell;
                }
                    break;
            default:{
                NSLog(@"---->%ld",indexPath.item);
                HomeBarCollectionViewCell *barCell = [homeCell.collectViewInside dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
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
        if(indexPath.item == 2){
            HomeMenusCollectionViewCell *menucell = (HomeMenusCollectionViewCell *)cell;
            if(_fiterArray.count == 4){
            for (int i = 0;i < 4;i++) {
                UIButton *btn = menucell.btnArray[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:_fiterArray[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(menusClickCell:) forControlEvents:UIControlEventTouchUpInside];
            }
            }
        }else if (indexPath.item > 3) {
//            array = _dataArray[_index];
            LYHomeCollectionViewCell *hcell = (LYHomeCollectionViewCell *)[[collectionView superview] superview];
            HomeBarCollectionViewCell *homeCell = (HomeBarCollectionViewCell *)cell;
            NSLog(@"---->%ld",indexPath.item);
            if (indexPath.item - 4 >= hcell.jiubaArray.count) {
                return;
            }
            JiuBaModel *jiubaM = hcell.jiubaArray[indexPath.item - 4];
            homeCell.jiuBaM = jiubaM;
        }
    }else{
        LYHomeCollectionViewCell *hcell = (LYHomeCollectionViewCell *)cell;
        hcell.jiubaArray = _dataArray[indexPath.item];
        if (hcell.collectViewInside) {
            if (_menuView.center.y < 45) {
                [hcell.collectViewInside setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
            }else{
                [hcell.collectViewInside setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
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
        jiuBaM = _recommendedBar;
    }else if(indexPath.item == 3){
        if(_recommendedTopic.id){
        ActionPage *aPage = [[ActionPage alloc]init];
        aPage.topicid = _recommendedTopic.id;
        [self.navigationController pushViewController:aPage animated:YES];
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
    BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    
    controller.beerBarId = @(model.barid);
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dic = _newbannerList [index];
    NSNumber *ad_type=[dic objectForKey:@"ad_type"];
    NSNumber *linkid=[dic objectForKey:@"linkid"];
    //    "ad_type": 1,//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客
    //    "linkid": 1 //对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
    if(ad_type.intValue ==1){
        //酒吧
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        
        controller.beerBarId = linkid;
        NSString *str = [NSString stringWithFormat:@"首页滑动视图酒吧ID%@",linkid];
        [self.navigationController pushViewController:controller animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if(ad_type.intValue ==2){
        //有活动内容才跳转
        if(![MyUtil isEmptyString:[dic objectForKey:@"linkurl"]]){
            HuoDongLinkViewController *huodong2=[[HuoDongLinkViewController alloc] init];
            huodong2.linkUrl=[dic objectForKey:@"linkurl"];
            [self.navigationController pushViewController:huodong2 animated:YES];
            
        }else if ([dic objectForKey:@"content"]) {
            HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
            huodong.content=[dic objectForKey:@"content"];
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
        //    4：拼客－>改为专题活动
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
    }
    
}
/*
 -(void)EScrollerViewDidClicked:(NSUInteger)index{
 NSDictionary *dic = _newbannerList [index];
 NSNumber *ad_type=[dic objectForKey:@"ad_type"];
 NSNumber *linkid=[dic objectForKey:@"linkid"];
 //    "ad_type": 1,//banner图片类别 0广告，1：酒吧/3：套餐/2：活动/4：拼客
 //    "linkid": 1 //对应的id  比如酒吧 就是对应酒吧id  套餐就是对应套餐id 活动就对应活动页面的id
 if(ad_type.intValue ==1){
 //酒吧
 BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
 
 controller.beerBarId = linkid;
 NSString *str = [NSString stringWithFormat:@"首页滑动视图酒吧ID%@",linkid];
 [self.navigationController pushViewController:controller animated:YES];
 [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
 }else if(ad_type.intValue ==2){
 //有活动内容才跳转
 if ([dic objectForKey:@"content"]) {
 HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
 huodong.content=[dic objectForKey:@"content"];
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
 }
 
 }
 */
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
