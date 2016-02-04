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
    NSMutableArray *_collectViewArray;
    NSInteger _index;
    NSMutableArray *_dataArray;
    NSInteger _currentPage_YD,_currentPage_Bar;
    HotMenuButton *_btn_yedian,*_btn_bar;
    UIView *_lineView;
    UIScrollView *_scrollView;
    UIVisualEffectView *_navView,*_menuView;
    NSArray *_fiterArray;
    JiuBaModel *_recommendedBar;
    CGFloat _contentOffSet_Height_YD,_contentOffSet_Height_BAR,_contentOffSetWidth;
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

   
    
    _currentPage_YD = 1;
    _currentPage_Bar = 1;
    _contentOffSet_Height_BAR = 1;
    _contentOffSet_Height_YD = 1;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = RGBA(242, 242, 242, 1);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    
    _collectViewArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        collectView.backgroundColor = RGBA(243, 243, 243, 1);
        collectView.tag = i;
            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
            [collectView registerNib:[UINib nibWithNibName:@"HomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenuCollectionViewCell"];
        [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
        collectView.dataSource = self;
        collectView.delegate = self;
        [_collectViewArray addObject:collectView];
        [_scrollView addSubview:collectView];
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _collectViewArray.count, 0)];
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.extendedLayoutIncludesOpaqueBars = NO;
        //        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self setupViewStyles];
    if (_collectViewArray.count) {
        [self getDataLocalAndReload];
        [self getDataWith:0];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault] ;
    
//     self.navigationController.delegate=self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (CGRectGetMaxY(_menuView.frame) < 90) {
        for (UICollectionView *collectView in _collectViewArray) {
            //[collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0) ]  ;
        }
    }
    UICollectionView *collectView = _collectViewArray[_index];
    switch (_index) {
        case 0:
        {
            _contentOffSet_Height_YD = collectView.contentOffset.y;
        }
            break;
        case 1:
        {
            _contentOffSet_Height_BAR = collectView.contentOffset.y;
        }
            break;
    }
    NSLog(@"----->%f--------%f--------%f",_contentOffSet_Height_YD,_contentOffSet_Height_BAR,collectView.contentOffset.y);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (_menuView.center.y < 45) {
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
        }
    }else{
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    if(scrollView == _scrollView){
            CGFloat offsetWidth = _scrollView.contentOffset.x;
            CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
            _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
//        if (_menuView.center.y < 45) {
//            for (UICollectionView *collectView in _collectViewArray) {
//                [collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0)];
//            }
//        }else{
//            for (UICollectionView *collectView in _collectViewArray) {
//                [collectView setContentInset:UIEdgeInsetsMake(88, 0, 49, 0)];
//            }
//        }
    }else{
        UICollectionView *collectView = nil;
        collectView = _collectViewArray[_index];
        if (_index) {
            if (collectView.contentOffset.y - 40> _contentOffSet_Height_BAR) {
              //  [collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0)];
                [UIView animateWithDuration:0.5 animations:^{
                    
                    _menuView.center = CGPointMake( _menuView.center.x,8 );
                    _titleImageView.alpha = 0.0;
                    _cityChooseBtn.alpha = 0.f;
                    _searchBtn.alpha = 0.f;
                } completion:^(BOOL finished) {
                    
                }];
            }else if(collectView.contentOffset.y + 40 <_contentOffSet_Height_BAR){
              // [collectView setContentInset:UIEdgeInsetsMake(88, 0, 49, 0)];
                [UIView animateWithDuration:0.5 animations:^{
                    
                    _menuView.center = CGPointMake(_menuView.center.x,45);
                    _titleImageView.alpha = 1.0;
                    _cityChooseBtn.alpha = 1.f;
                    _searchBtn.alpha = 1.f;
                }completion:^(BOOL finished) {
                    
                }];
            }
        }else{
                if (collectView.contentOffset.y - 40 > _contentOffSet_Height_YD) {
                  //  [collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0)];
                [UIView animateWithDuration:0.5 animations:^{
                    
                    _menuView.center = CGPointMake( _menuView.center.x,8 );
                    _titleImageView.alpha = 0.0;
                    _cityChooseBtn.alpha = 0.f;
                    _searchBtn.alpha = 0.f;
                } completion:^(BOOL finished) {
                    
                }];
                }else if(collectView.contentOffset.y + 40 < _contentOffSet_Height_YD) {
                   // [collectView setContentInset:UIEdgeInsetsMake(88, 0, 49, 0)];
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        _menuView.center = CGPointMake(_menuView.center.x,45);
                        _titleImageView.alpha = 1.0;
                        _cityChooseBtn.alpha = 1.f;
                        _searchBtn.alpha = 1.f;
                    }completion:^(BOOL finished) {
                        
                    }];
                }
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = (NSInteger)_scrollView.contentOffset.x/SCREEN_WIDTH;
    UICollectionView *collectView = nil;
    if (_dataArray.count) {
        NSArray *array = _dataArray[_index];
        if(!array.count) {
            collectView = _collectViewArray[_index];
            [collectView.mj_header beginRefreshing];
        }
    }
    if (scrollView == _scrollView) {
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
//    _contentOffSetWidth = _scrollView.contentOffset.x;

//    [UIView animateWithDuration:.5 animations:^{
//        CGFloat offsetWidth = _scrollView.contentOffset.x;
//        CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
//        _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
//    }];
    
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
    
    CGFloat titleImgViewWidth = 30;
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - titleImgViewWidth)/2.f , 9.5 + 15, titleImgViewWidth, titleImgViewWidth)];
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
    
}

#pragma mark －夜店action
- (void)yedianClick{
    _index = 0;
    [_scrollView setContentOffset:CGPointZero animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_yedian.currentTitle]];
    _btn_yedian.isHomePageMenuViewSelected = YES;
    _btn_bar.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        NSArray *array = _dataArray[0];
        if (!array.count) {
            [self getDataWith:0];
        }
    }
    
    if (_menuView.center.y < 45) {
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
        }
    }else{
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
        }
    }
}

#pragma mark －酒吧action
- (void)barClick{
    _index = 1;
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
     [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOMEPAGE_MTA titleName:_btn_bar.currentTitle]];
    _btn_bar.isHomePageMenuViewSelected = YES;
    _btn_yedian.isHomePageMenuViewSelected = NO;
    if (_dataArray.count) {
        NSArray *array = _dataArray[1];
        if (!array.count) {
            [self getDataWith:1];
        }
    }
    if (CGRectGetMaxY(_menuView.frame) < 90) {
        for (UICollectionView *collectView in _collectViewArray) {
            //[collectView setContentInset:UIEdgeInsetsMake(88 - 40, 0, 49, 0) ]  ;
        }
    }
    
    if (_menuView.center.y < 45) {
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91 - 40, 0, 49, 0)];
        }
    }else{
        for (UICollectionView *collectView in _collectViewArray) {
            [collectView setContentInset:UIEdgeInsetsMake(91, 0, 49, 0)];
        }
    }
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
//    ((LYNavigationController *)self.navigationController).navBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.hidden = YES;

    if (self.navigationController.navigationBarHidden != NO) {
//        [self.navigationController setNavigationBarHidden:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [_scrollView setContentOffset:CGPointZero];
//    ((LYNavigationController *)self.navigationController).navBar.hidden = NO;
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
//    self.navigationController.navigationBarHidden = NO;
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
            collectView = _collectViewArray[0];
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
            collectView = _collectViewArray[1];
        }
        [collectView reloadData];
    }
}

#pragma mark 获取数据
-(void)getDataWith:(NSInteger)tag{
//    if([MyUtil configureNetworkConnect] == 0){
//        NSArray *array = [self getDataFromLocal];
//        UICollectionView *collectView = nil;
//        if (array.count == 2) {
//            if (((NSArray *)array[0]).count) {
//                NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
//                NSArray *array_YD = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
//                self.bannerList = dataDic[@"banner"];
//                self.newbannerList = dataDic[@"newbanner"];
//                self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
//                _fiterArray = [dataDic valueForKey:@"filterImages"];
//                NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
//                _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
//                [_dataArray replaceObjectAtIndex:0 withObject:array_YD];
//                collectView = _collectViewArray[0];
//            }else if(((NSArray *)array[1]).count){
//                NSDictionary *dataDic = ((LYCache *)((NSArray *)array[0]).firstObject).lyCacheValue;
//                NSArray *array_BAR = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
//                self.bannerList = dataDic[@"banner"];
//                self.newbannerList = dataDic[@"newbanner"];
//                self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]];
//                _fiterArray = [dataDic valueForKey:@"filterImages"];
//                NSDictionary *recommendedBarDic = [dataDic valueForKey:@"recommendedBar"];
//                _recommendedBar = [JiuBaModel mj_objectWithKeyValues:recommendedBarDic];
//                [_dataArray replaceObjectAtIndex:1 withObject:array_BAR];
//                collectView = _collectViewArray[1];
//            }
//            [collectView reloadData];
//            /*[UIView transitionWithView:collectView
//                              duration: 0.6f
//                               options: UIViewAnimationOptionTransitionCrossDissolve
//                            animations: ^(void){
//                                [collectView reloadData];
//                            }completion: ^(BOOL isFinished){
//                                
//                            }]; */
//            return;
//        }
//    }
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeListWith:tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             UICollectionView *collectView = _collectViewArray[_index];
             if (barList.count == PAGESIZE)
             {
//                 weakSelf.curPageIndex = 2;
                 switch (_index) {
                     case 0:
                         _currentPage_YD = 2;
                         break;
                         
                     case 1:
                         _currentPage_Bar = 2;
                         break;
                     default:
                         break;
                 }
                
             }else
             {
                 //collectView.mj_footer.hidden = YES;
                 [collectView.mj_footer endRefreshingWithNoMoreData];
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
    switch (_index) {
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
            UICollectionView *collectView = _collectViewArray[tag];
            NSMutableArray *array = _dataArray[tag];
            if((tag == 0 && _currentPage_YD == 1) || (tag == 1 && _currentPage_Bar == 1)) {
                [array removeAllObjects];
                weakSelf.bannerList = homePageM.banner.mutableCopy;
                weakSelf.newbannerList = homePageM.newbanner.mutableCopy;
                weakSelf.bartypeslistArray = homePageM.bartypeslist;
                _fiterArray = homePageM.filterImages;
            }
            _recommendedBar = homePageM.recommendedBar;
            [array addObjectsFromArray:homePageM.barlist.mutableCopy] ;
            [collectView reloadData];
          /*  [UIView transitionWithView:collectView
                              duration: 0.6f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void){
                                [collectView reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }]; */
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
    for (UICollectionView *collectView in _collectViewArray) {
    __weak HomePageINeedPlayViewController * weakSelf = self;
    collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
                              ^{
                                  switch (collectView.tag) {
                                      case 0:
                                      {
                                          _currentPage_YD = 1;
                                          [collectView.mj_footer setState:MJRefreshStatePulling];
                                      }
                                          break;
                                      case 1:
                                      {
                                          _currentPage_Bar = 1;
                                          [collectView.mj_footer setState:MJRefreshStatePulling];
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
                                                   case 1:{
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
//        switch (collectView.tag) {
//            case 0:
//            {
//                _currentPage_ = 2;
//            }
//                break;
//            case 1:
//            {
//                _currentPage_Bar = 2;
//            }
//                break;
//        }

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
      }
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
    NSArray *array = _dataArray[collectionView.tag];
    if(array.count){
    return array.count + 6;
    }else{
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= 2 && indexPath.row <= 5){
        return CGSizeMake((SCREEN_WIDTH - 9)/2.f, (SCREEN_WIDTH - 9)/2.f * 9 / 16);
    }else if(indexPath.row == 0){
        return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16);
    }else{
        return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16);
    }
    
 /*   if(indexPath.row >= 2 && indexPath.row <= 5){
        return CGSizeMake((SCREEN_WIDTH - 6)/2.f, (SCREEN_WIDTH - 6)/2.f * 9 / 16);
    }else if(indexPath.row == 0){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16);
    }else{
        return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH ) * 9 / 16);
    } */
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3,3,3,3);
}


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

    }else if(indexPath.row >= 2 & indexPath.row <= 5){
      //  NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
        HomeMenuCollectionViewCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCollectionViewCell" forIndexPath:indexPath];
        menuCell.layer.cornerRadius = 2;
        menuCell.layer.masksToBounds = YES;
      //  [menuCell.imgView_title setImage:[UIImage imageNamed:picNameArray[indexPath.row - 2]]];
     //   if(picNameArray.count == 4) menuCell.label_title.text = picNameArray[indexPath.row - 2];
        if(_fiterArray.count == 4) [menuCell.imgView_bg sd_setImageWithURL:[NSURL URLWithString:_fiterArray[indexPath.row - 2]] placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
        return menuCell;
    }else{
        HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
        if(_dataArray.count){
            NSArray *array = _dataArray[collectionView.tag];
            if(array.count){
                JiuBaModel *jiuBaM = array[indexPath.row - 6];
                jiubaCell.jiuBaM = jiuBaM;
            }
        }

        return jiubaCell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *jiuBaM = nil;
    NSArray *array = nil;
    if (_dataArray.count) {
        array = _dataArray[collectionView.tag];
    }
    if(indexPath.item == 1){
        jiuBaM = _recommendedBar;
    }else if(indexPath.item >= 6){
        if(array.count) jiuBaM = array[indexPath.item - 6];
    }else if(indexPath.item >= 2&& indexPath.item <= 5){
        //        LYHotBarViewController *hotJiuBarVC = [[LYHotBarViewController alloc]init];
        LYHotBarViewController *hotBarVC = [[LYHotBarViewController alloc]init];
        hotBarVC.contentTag = indexPath.item - 2;
        switch (collectionView.tag) {
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
    
    
    BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    controller.beerBarId = @(jiuBaM.barid);
    [self.navigationController pushViewController:controller animated:YES];
     [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
   

    
  /*  BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    controller.beerBarId = @(jiuBaM.barid);
    [self.navigationController pushViewController:controller animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
   */
    
    //    LYWineBarCell *cell = (LYWineBarCell *)[tableView cellForRowAtIndexPath:indexPath];
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
