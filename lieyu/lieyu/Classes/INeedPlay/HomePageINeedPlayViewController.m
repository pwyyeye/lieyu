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
#import "HuoDongViewController.h"
#import "LYCacheDefined.h"
#import "LYCache+CoreDataProperties.h"
#import "LYUserHttpTool.h"
#import "LYFriendsHttpTool.h"
#import "Masonry.h"
#import "HomeBarCollectionViewCell.h"
#import "HomeMenuCollectionViewCell.h"
#import "LYHotBarViewController.h"
#import "HomePageModel.h"

#define PAGESIZE 20
#define HOMEPAGE_MTA @"HOMEPAGE"
#define HOMEPAGE_TIMEEVENT_MTA @"HOMEPAGE_TIMEEVENT"

@interface HomePageINeedPlayViewController ()
<EScrollerViewDelegate,
UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
,UIScrollViewDelegate>{
    UIButton *_cityChooseBtn,*_searchBtn;
    UIImageView *_titleImageView;
    CGFloat _scale;
    NSMutableArray *_collectViewArray;
    NSInteger _index;
    NSMutableArray *_dataArray;
    NSInteger _currentPage_YD,_currentPage_Bar;
    UIButton *_btn_yedian,*_btn_bar;
    UIView *_lineView;
    UIScrollView *_scrollView;
    UIVisualEffectView *_navView,*_menuView;
    NSArray *_fiterArray;
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
    [self.navigationController setNavigationBarHidden:NO];
    _currentPage_YD = 1;
    _currentPage_Bar = 1;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 90)];
    _scrollView.backgroundColor = RGBA(242, 242, 242, 1);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 2; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    
    _collectViewArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i % 2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 90) collectionViewLayout:layout];
        collectView.backgroundColor = RGBA(243, 243, 243, 1);
        collectView.tag = i;
            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
            [collectView registerNib:[UINib nibWithNibName:@"HomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenuCollectionViewCell"];

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
    [self getDataWith:0];
    
  /*  self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.shadowRadius = 1; */
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _scrollView){
        CGFloat offsetWidth = scrollView.contentOffset.x;
        CGFloat hotMenuBtnWidth = _btn_bar.center.x - _btn_yedian.center.x;
        _lineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + _btn_yedian.center.x, _lineView.center.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = (NSInteger)_scrollView.contentOffset.x/SCREEN_WIDTH;
    if (_dataArray.count) {
        NSArray *array = _dataArray[_index];
        if(!array.count) [self getDataWith:_index];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    CGRect rc = _topView.frame;
    //    rc.origin.x = 0;
    //    rc.origin.y = -20;
    //    _topView.frame = rc;
    //    [self.navigationController.navigationBar addSubview:_topView];
    //ios 7.0适配
    //    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
    //        self.tableView.contentInset = UIEdgeInsetsMake(0,  0,  0,  0);
    //    }
    
    //WTT
    //    [self.navigationController setNavigationBarHidden:NO];
    [self createNavButton];
}

#pragma mark 创建导航的按钮(选择城市和搜索)
- (void)createNavButton{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _navView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _navView.alpha = 5;
    _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.navigationController.navigationBar addSubview:_navView];
    
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _menuView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 26);
    _menuView.alpha = 5;
    [self.view addSubview:_menuView];
    
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 40, 30)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:@"上海" forState:UIControlStateNormal];
    [_cityChooseBtn setTitleColor:RGBA(1, 1, 1, 1) forState:UIControlStateNormal];
    _cityChooseBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    [_cityChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 18, 0, 0)];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_cityChooseBtn];
    
    CGFloat searchBtnWidth = 24;
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - searchBtnWidth, 10, searchBtnWidth, searchBtnWidth)];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_searchBtn];
    
    CGFloat titleImgViewWidth = 40;
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - titleImgViewWidth)/2.f , 9.5, titleImgViewWidth, titleImgViewWidth)];
    _titleImageView.image = [UIImage imageNamed:@"logo"];
    [_navView addSubview:_titleImageView];
    
    _btn_yedian = [[UIButton alloc]init];
    [_btn_yedian setTitle:@"夜店" forState:UIControlStateNormal];
    _btn_yedian.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_btn_yedian setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
    [_menuView addSubview:_btn_yedian];
    [_btn_yedian addTarget:self action:@selector(yedianClick) forControlEvents:UIControlEventTouchUpInside];
    [_btn_yedian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_menuView.mas_bottom).offset(-5.5);
        make.left.mas_equalTo(_menuView.mas_left).offset(131);
        make.size.mas_equalTo(CGSizeMake(24, 14));
    }];
    
    _btn_bar = [[UIButton alloc]init];
    [_btn_bar setTitle:@"酒吧" forState:UIControlStateNormal];
    _btn_bar.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_btn_bar setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal];
    [_btn_bar addTarget:self action:@selector(barClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:_btn_bar];
    [_btn_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_menuView.mas_bottom).offset(-5.5);
        make.right.mas_equalTo(_menuView.mas_right).offset(-131);
        make.size.mas_equalTo(CGSizeMake(24, 14));
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [_menuView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_menuView.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_menuView.mas_left).offset(122);
        make.size.mas_equalTo(CGSizeMake(42, 1));
    }];
    
}

#pragma mark －夜店action
- (void)yedianClick{
    [_scrollView setContentOffset:CGPointZero animated:YES];
    if (_dataArray.count) {
        NSArray *array = _dataArray[0];
        if (!array.count) {
            [self getDataWith:0];
        }
    }
}

#pragma mark －酒吧action
- (void)barClick{
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    if (_dataArray.count) {
        NSArray *array = _dataArray[1];
        if (!array.count) {
            [self getDataWith:1];
        }
    }}

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNavButtonAndImageView];
}

#pragma mark 移除导航的按钮和图片
- (void)removeNavButtonAndImageView{
    [_titleImageView removeFromSuperview];
    [_searchBtn removeFromSuperview];
    [_cityChooseBtn removeFromSuperview];
    [_navView removeFromSuperview];
}

//筛选，跳转，增加，删除，确认

#pragma mark 搜索action
- (void)searchClick:(UIButton *)sender {
    LYHomeSearcherViewController *homeSearchVC = [[LYHomeSearcherViewController alloc]init];
    [self.navigationController pushViewController:homeSearchVC animated:YES];
    
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"搜索"]];
}



#pragma mark 获取数据
-(void)getDataWith:(NSInteger)tag{
    if([MyUtil configureNetworkConnect] == 0){
        NSArray *array = [self getDataFromLocal];
        if (array.count) {
            NSDictionary *dataDic = ((LYCache *)array.firstObject).lyCacheValue;
            self.aryList = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            self.bannerList = dataDic[@"banner"];
            self.newbannerList = dataDic[@"newbanner"];
            self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]] ;
            //[_collectView reloadData];
            return;
        }
    }
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeListWith:tag block:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 //        weakSelf.tableView.mj_footer.hidden = NO;
             }
             else
             {
                 //       weakSelf.tableView.mj_footer.hidden = YES;
                 
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
    [bus getToPlayOnHomeList2:hList pageIndex:1 results:^(LYErrorMessage * ermsg,HomePageModel *homePageM){
        if (ermsg.state == Req_Success)
        {
            UICollectionView *collectView = _collectViewArray[tag];
            NSMutableArray *array = _dataArray[tag];
            if((tag == 0 && _currentPage_YD == 1) || (tag == 1 && _currentPage_Bar == 1)) {
                weakSelf.bannerList = homePageM.banner.mutableCopy;
                weakSelf.newbannerList = homePageM.newbanner.mutableCopy;
                weakSelf.bartypeslistArray = homePageM.bartypeslist;
                _fiterArray = homePageM.filterImages;
            }
            [array addObjectsFromArray:homePageM.barlist.mutableCopy] ;
            [collectView reloadData];
        }
        block !=nil? block(ermsg,homePageM.banner,homePageM.barlist):nil;
    }];
}

#pragma mark 本地获取数据
- (NSArray *)getDataFromLocal{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"lyCacheKey == %@",CACHE_INEED_PLAY_HOMEPAGE];
    return  [[LYCoreDataUtil shareInstance]getCoreData:@"LYCache" withPredicate:pre];
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
                                               collectView.mj_footer.hidden = YES;
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
                    collectView.mj_footer.hidden = YES;
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
                [collectView.mj_footer endRefreshing];
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
    return array.count + 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= 2 && indexPath.row <= 5){
        return CGSizeMake((SCREEN_WIDTH - 9)/2.f, (SCREEN_WIDTH - 9)/2.f * 9 / 16);
    }else if(indexPath.row == 0){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16);
    }else{
        return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 / 16);
    }
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
        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH * 9)/16)
                                                              scrolArray:[NSArray arrayWithArray:[bigArr copy]] needTitile:YES];
        scroller.delegate=self;
        scroller.tag=1999;
        [cell addSubview:scroller];
        return cell;
    }else if(indexPath.row == 1){
        HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
        if(_dataArray.count){
            NSArray *array = _dataArray[collectionView.tag];
            if(array.count){
                JiuBaModel *jiuBaM = array[0];
                jiubaCell.jiuBaM = jiuBaM;
            }
        }
        return jiubaCell;
    }else if(indexPath.row >= 2 & indexPath.row <= 5){
        NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
        HomeMenuCollectionViewCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCollectionViewCell" forIndexPath:indexPath];
        [menuCell.imgView_title setImage:[UIImage imageNamed:picNameArray[indexPath.row - 2]]];
        if(picNameArray.count == 4) menuCell.label_title.text = picNameArray[indexPath.row - 2];
        if(_fiterArray.count == 4) [menuCell.imgView_bg sd_setImageWithURL:[NSURL URLWithString:_fiterArray[indexPath.row - 2]] placeholderImage:[UIImage imageNamed:@"emptyImage120"]];
        return menuCell;
    }else{
        HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
        if(_dataArray.count){
            NSArray *array = _dataArray[collectionView.tag];
            if(array.count){
                JiuBaModel *jiuBaM = array[indexPath.row - 5];
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
        if(array.count) jiuBaM = array[indexPath.item - 1];
    }else if(indexPath.item >= 6){
        if(array.count) jiuBaM = array[indexPath.item - 5];
    }else if(indexPath.item >= 2&& indexPath.item <= 5){
        //        LYHotBarViewController *hotJiuBarVC = [[LYHotBarViewController alloc]init];
        LYHotBarViewController *hotBarVC = [[LYHotBarViewController alloc]init];
        hotBarVC.contentTag = indexPath.item - 2;
        switch (collectionView.tag) {
            case 0:
            {
                hotBarVC.subidStr = @"2";
            }
                break;
            case 1:
            {
                hotBarVC.subidStr = @"1,6,7";
            }
                break;
        }
        [self.navigationController pushViewController:hotBarVC animated:YES];
        return;
        //        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:titleArray[indexPath.item - 2]]];
    }else{
        return;
    }
    
    
    BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    controller.beerBarId = @(jiuBaM.barid);
    [self.navigationController pushViewController:controller animated:YES];
    // [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
   

    
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
