//
//  LYHotBarViewController.m
//  lieyu
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarViewController.h"
#import "HomeBarCollectionViewCell.h"
#import "MJRefresh.h"
#import "HotMenuButton.h"

#import "ZSManageHttpTool.h"
#import "JiuBaModel.h"
#import "ProductCategoryModel.h"
#import "MReqToPlayHomeList.h"
#import "LYBaseViewController.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "UIImage+GIF.h"
#import "LYCache.h"
#import "JiuBaModel.h"
#import "BeerNewBarViewController.h"

#define PAGESIZE 20

@interface LYHotBarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    UIView *_purpleLineView;
    NSMutableArray *_dataArray;
    NSMutableArray *_collectArray;
    NSInteger _currentPageHot;
        NSInteger _currentPageDistance;
        NSInteger _currentPagePrice;
    NSInteger _currentPageFanli;
    NSInteger _index;
    UILabel *_titelLabel;
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property (strong, nonatomic) UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property (strong, nonatomic) UIVisualEffectView *menuView;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (strong, nonatomic) NSMutableArray *menuBtnArray;
@end

@implementation LYHotBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMenuView];
    self.navigationItem.title = @"热门酒吧";
    
    _collectArray = [[NSMutableArray alloc]initWithCapacity:4];
    _dataArray = [[NSMutableArray alloc]initWithCapacity:4];
    _currentPageHot = 1;
        _currentPageDistance= 1;
        _currentPagePrice = 1;
        _currentPageFanli = 1;
    
    for (int i = 0; i < 4; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    
    for(int i = 0; i < 4; i++){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i%4 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [collectView setContentInset:UIEdgeInsetsMake(90, 0, 0, 0)];
        collectView.dataSource = self;
        collectView.delegate = self;
        collectView.tag = i;
        collectView.backgroundColor = RGBA(243, 243, 243, 1);
        [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
        [_collectArray addObject:collectView];
        [_scrollView addSubview:collectView];
    }
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _collectArray.count, 0)];
    [self installFreshEvent];
//    [self getDataForHotWith:_contentTag];
    if (_collectArray.count == 4) {
        UICollectionView *collectView = _collectArray[_contentTag];
        [collectView.mj_header beginRefreshing];
    }
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _contentTag, 0)];
    [self createLineForMenuView];
}
#pragma mark - 创建菜单view
- (void)createMenuView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 26);
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.1;
    _menuView.layer.shadowRadius = 1;
//    [self.view addSubview:_menuView];
    UIBlurEffect *effectExtraLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIBlurEffect *effectLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.alpha = 5;
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
    CGFloat offSet = 26;
    _menuBtnArray = [[NSMutableArray alloc]initWithCapacity:4];
    NSArray *btnTitleArray = @[@"热门",@"附近",@"价格",@"返利"];
    for (int i = 0; i < 4; i ++) {
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        if (i == 0) {
            btn.frame = CGRectMake(offSet, 63,btnWidth, 26);
        }else{
            btn.frame = CGRectMake(offSet + i%4 * btnWidth, 63, btnWidth, 26);
        }
        if (i == _contentTag) {
            btn.isMenuSelected = YES;
        }else{
            btn.isMenuSelected = NO;
        }
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnMenuViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:btn];
        [_menuBtnArray addObject:btn];
    }
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = _titleText;
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];

    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(5, 30, 30, 30);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:backBtn];
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)createLineForMenuView{
    UIButton *hotBtn = _menuBtnArray[0];
    _purpleLineView = [[UIView alloc]init];
    CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
    CGFloat offsetWidth = _scrollView.contentOffset.x;
    _purpleLineView.frame = CGRectMake(0, _menuView.size.height - 2, 42, 2);
    _purpleLineView.backgroundColor = RGBA(186, 40, 227, 1);
    _purpleLineView.center = CGPointMake(hotBtn.center.x + offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH , CGRectGetCenter(_purpleLineView.frame).y);
    [_menuView addSubview:_purpleLineView];
}

- (void)btnMenuViewClick:(HotMenuButton *)sender {
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    sender.isMenuSelected = YES;
    [_scrollView setContentOffset:CGPointMake(sender.tag * SCREEN_WIDTH, 0) animated:YES];
    if (!((NSArray *)_dataArray[sender.tag]).count) {
        //[self getDataForHotWith:sender.tag];
        UICollectionView *collectView = _collectArray[sender.tag];
        [collectView.mj_header beginRefreshing];
    }
    NSDictionary *dict = @{@"actionName":@"筛选",@"pageName":@"娱",@"titleName":@"主条件",@"value":sender.titleLabel.text};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _scrollView){
        UIButton *hotBtn = _menuBtnArray[0];
        CGFloat offsetWidth = scrollView.contentOffset.x;
        CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
        _purpleLineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + hotBtn.center.x, _purpleLineView.center.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
        _index = (NSInteger)_scrollView.contentOffset.x/SCREEN_WIDTH;
        HotMenuButton *btn = _menuBtnArray[_index];
        btn.isMenuSelected = YES;
    if (_dataArray.count) {
        NSArray *array = _dataArray[_index];
        if(!array.count) {
//            [self getDataForHotWith:_index];
            if (_collectArray.count == 4) {
                UICollectionView *collectView = _collectArray[_index];
                [collectView.mj_header beginRefreshing];
            }
        }
    }
}

- (void)getDataForHotWith:(NSInteger)tag{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    hList.need_page = @(1);
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    switch (tag) {
        case 0:
        {
             hList.p = @(_currentPageHot);
        }
            break;
        case 1:
        {
             hList.p = @(_currentPageDistance);
            hList.sort = @"distanceasc";
        }
            break;
        case 2:
        {
            hList.p = @(_currentPagePrice);
            hList.sort = @"priceasc";
        }
            break;
        case 3:
        {
             hList.p = @(_currentPageFanli);
            hList.sort = @"rebatedesc";
        }
            break;
    }
    hList.subids = _subidStr;
    hList.per = @(PAGESIZE);
    hList.titleStr = self.navigationItem.title;
    
    [bus getToPlayOnHomeList:hList pageIndex:2 results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray *newbanner,NSMutableArray *bartypeslist)
     {
         if (ermsg.state == Req_Success)
         {
             if(tag >= 4) return ;
             NSMutableArray *array = _dataArray[tag];
             switch (tag) {
                 case 0:
                 {
                     if(_currentPageHot == 1){
                          [array removeAllObjects];
                     }
                         [array addObjectsFromArray:barList];
                     _currentPageHot ++;
                 }
                     break;
                 case 1:
                 {
                     if(_currentPageDistance == 1) {
                          [array removeAllObjects];
                     }
                         [array addObjectsFromArray:barList];
                     _currentPageDistance ++;
                 }
                     break;
                 case 2:
                 {
                     if(_currentPagePrice == 1) {
                         [array removeAllObjects];
                     }
                         [array addObjectsFromArray:barList];
                     _currentPagePrice ++;
                 }
                     break;
                 case 3:
                 {
                     if(_currentPageFanli == 1) {
                         [array removeAllObjects];
                     }
                         [array addObjectsFromArray:barList];
                     _currentPageFanli ++;
                 }
                     break;
             }

             
             UICollectionView *collectView = _collectArray[tag];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [collectView.mj_header endRefreshing];
                 switch (tag) {
                     case 0:
                     {
                         if (_currentPageHot != 1 && !barList.count) {
                             [collectView.mj_footer endRefreshingWithNoMoreData];
                         }else{
                             [collectView.mj_footer endRefreshing];
                         }
                     }
                         break;
                     case 1:
                     {
                         if (_currentPageDistance != 1 && !barList.count) {
                             [collectView.mj_footer endRefreshingWithNoMoreData];
                         }else{
                             [collectView.mj_footer endRefreshing];
                         }
                     }
                         break;
                     case 2:
                     {
                         if (_currentPagePrice != 1 && !barList.count) {
                             [collectView.mj_footer endRefreshingWithNoMoreData];
                         }else{
                             [collectView.mj_footer endRefreshing];
                         }
                     }
                         break;
                     case 3:
                     {
                         if (_currentPageFanli != 1 && !barList.count) {
                             [collectView.mj_footer endRefreshingWithNoMoreData];
                         }else{
                             [collectView.mj_footer endRefreshing];
                         }
                     }
                         break;
                 }
//                 [UIView transitionWithView:collectView
//                                   duration: 0.6f
//                                    options: UIViewAnimationOptionTransitionCrossDissolve
//                                 animations: ^(void){
                                     [collectView reloadData];
//                                 }completion: ^(BOOL isFinished){
//                                     
//                                 }];
             });
         }
     }];
}



- (void)installFreshEvent
{
    for (int i = 0; i < _collectArray.count; i ++) {
        if(!_collectArray.count) return;
        __weak UICollectionView *collectView = _collectArray[i];
        __weak LYHotBarViewController * weakSelf = self;
        //    __weak UITableView *tableView = self.tableView;
        collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            switch (i) {
                case 0:
                {
                    _currentPageHot = 1;
                    [weakSelf getDataForHotWith:0];
                }
                    break;
                case 1:
                {
                    _currentPageDistance = 1;
                    [weakSelf getDataForHotWith:1];
                }
                    break;
                case 2:
                {
                    _currentPagePrice = 1;
                    [weakSelf getDataForHotWith:2];
                }
                    break;
                case 3:
                {
                    _currentPageFanli = 1;
                    [weakSelf getDataForHotWith:3];
                }
                    break;
            }
            
        }];
        
        MJRefreshGifHeader *header=(MJRefreshGifHeader *)collectView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            switch (i) {
                case 0:
                {
                    [weakSelf getDataForHotWith:0];
                }
                    break;
                case 1:
                {
                    [weakSelf getDataForHotWith:1];
                }
                    break;
                case 2:
                {
                    [weakSelf getDataForHotWith:2];
                }
                    break;
                case 3:
                {
                    [weakSelf getDataForHotWith:3];
                }
                    break;
            }
        }];
        MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)collectView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
        NSLog(@"----->%@",collectView.mj_footer);
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = _dataArray[collectionView.tag];
    return array.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH - 6, (SCREEN_WIDTH - 6) * 9 /16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 2;
    cell.layer.masksToBounds = YES;
    JiuBaModel *jiubaM = _dataArray[collectionView.tag][indexPath.row];
    cell.jiuBaM = jiubaM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count) {
        NSArray *array = _dataArray[collectionView.tag];
        if (array.count) {
            JiuBaModel *jiuM = array[indexPath.item];
            BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
            controller.beerBarId = @(jiuM.barid);
            [self.navigationController pushViewController:controller animated:YES];
           // [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:jiuBaM.barname]];
        }
    }
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
