//
//  LYGuWenListViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenListViewController.h"
#import "HotMenuButton.h"
#import "MReqToPlayHomeList.h"
#import "LYUserLocation.h"
#import "LYAdviserHttpTool.h"
#import "MJExtension.h"

#define margin (SCREEN_WIDTH - 240) / 3
#define PAGESIZE 10

@interface LYGuWenListViewController ()<UIScrollViewDelegate,LYGuWenCollectionDelegate>
{
    UIButton *filterBtn;
    UIView *_filterBgView;//筛选背景图
    UIVisualEffectView *_filterView;//筛选菜单毛玻璃
    NSUInteger _filterViewHeight;//筛选菜单高度
    
    NSArray *sexTitleArr;
    NSArray *placeTitleArr;
    
    NSMutableArray *_sexFilterButtons;
    NSMutableArray *_areaFilterButtons;
    
    NSInteger _pagePopularity;
    NSInteger _pageDistance;
    NSInteger _pageRecommend;
    
    NSMutableArray *_isChangedFilter;//判断是否更改筛选条件
    
    UILabel *_kongLabel;
    
}

@end

@implementation LYGuWenListViewController

- (void)viewDidLoad {
    NSString *location = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserChoosedLocation"];
    NSMutableArray *array;
    if (location) {
        array = [[NSMutableArray alloc]initWithArray:[MyUtil getAreaWithName:location withStly:LYAreaStyleWithStateAndCityAndDistrict]];
    }else{
        array = [[NSMutableArray alloc]initWithArray:[MyUtil getAreaWithName:@"上海" withStly:LYAreaStyleWithStateAndCityAndDistrict]];
    }
    [array insertObject:@"所有地区" atIndex:0];
    placeTitleArr = [NSArray arrayWithArray:array];
//    placeTitleArr = @[@"所有地区",@"杨浦区",@"虹口区",@"闸北区",@"普陀区",@"黄浦区",@"静安区",@"长宁区",@"卢湾区",@"徐汇区",@"闵行区",@"浦东新区",@"宝山区",@"松江区",@"嘉定区",@"青浦区",@"金山区",@"奉贤区",@"南汇区",@"崇明县"];
    sexTitleArr = @[@"美女顾问",@"帅哥顾问",@"全部顾问"];
    _pageDistance = 1;
    _pageRecommend = 1;
    _pagePopularity = 1;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.titleText = @"全部顾问";
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    if(_filterSortFlag == 0){
        self.titleText = @"人气顾问";
    }else if (_filterSortFlag == 1){
        self.titleText = @"附近顾问";
    }else if (_filterSortFlag == 2){
        self.titleText = @"推荐顾问";
    }
}

#pragma mark - 创建菜单view
- (void)createMenuView{
    [super createMenuView];
    
    [self createFilterView];
    
    filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 46, 33, 32, 22)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:filterBtn];
}

- (void)createFilterView{
    
    _sexFilterButtons = [[NSMutableArray alloc]init];
    _areaFilterButtons = [[NSMutableArray alloc]init];
    _isChangedFilter = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
    
    _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    _filterBgView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
    UITapGestureRecognizer *tapFilter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterHideAnimation)];
    [_filterBgView addGestureRecognizer:tapFilter];
    [self.view addSubview:_filterBgView];
    _filterBgView.hidden = YES;
    _filterBgView.layer.zPosition = 4;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleExtraLight)];
    _filterView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    _filterView.clipsToBounds = YES;
    [_filterBgView addSubview:_filterView];
    
    for (int i = 0;i < sexTitleArr.count; i++) {
        NSString *sexTitle = sexTitleArr[i];
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        btn.frame = CGRectMake(72 + i % 3 * (56 + margin), i / 3 * 35 + 20, 56, 20);
        [btn setTitle:sexTitle forState:UIControlStateNormal];
        if(i == 2){
            btn.isGuWenSelected = YES;
        }
        else{
            btn.isGuWenSelected = NO;
        }
        
        [btn addTarget:self action:@selector(filterSex:) forControlEvents:UIControlEventTouchUpInside];
        [_sexFilterButtons addObject:btn];
        [_filterView addSubview:btn];
        _filterViewHeight = i / 3 * 35 + 20;
    }
    
    NSArray *classTitleArr = @[@"性别:",@"地区:"];
    for (int i = 0; i < classTitleArr.count; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 , (_filterViewHeight + 15) * i + 20 , 42, 20)];
        label.text = classTitleArr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBA(198, 38, 217, 1);
        [_filterView addSubview:label];
    }
    
    int startHeight = _filterViewHeight;
    for (int i = 0; i < placeTitleArr.count; i ++) {
        NSString *placeTitle = placeTitleArr[i];
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        btn.frame = CGRectMake(72 + i % 3 * (56 + margin), startHeight + 35 + i / 3 * 35, 56, 20);
        [btn setTitle:placeTitle forState:UIControlStateNormal];
        if(i == 0){
            btn.isGuWenSelected = YES;
        }
        else{
            btn.isGuWenSelected = NO;
        }
        [btn addTarget:self action:@selector(filterArea:) forControlEvents:UIControlEventTouchUpInside];
        [_areaFilterButtons addObject:btn];
        [_filterView addSubview:btn];
        _filterViewHeight = btn.frame.origin.y + 50;
    }
}

#pragma mark - 筛选菜单
- (void)filterClick:(UIButton *)btn{
    if ([filterBtn.currentTitle isEqualToString:@"筛选"]) {
        [self filterShowAnimation];
    }else{
        [self filterHideAnimation];
    }
}

- (void)filterShowAnimation{
    _filterBgView.hidden = NO;
    [filterBtn setTitle:@"确定" forState:UIControlStateNormal];
    [filterBtn setTitleColor:RGBA(197, 55, 255, 1) forState:UIControlStateNormal];
    
    _filterBgView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_filterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _filterViewHeight)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)filterHideAnimation{
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _filterBgView.frame = CGRectMake(0,  64, SCREEN_WIDTH, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        _filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        _filterBgView.hidden = YES;
        
        if (_filterSortFlag == 0) {
            _pagePopularity = 1;
        }else if (_filterSortFlag == 1){
            _pageDistance = 1;
        }else if (_filterSortFlag == 2){
            _pageRecommend = 1;
        }
        //  确定后执行搜索
        [self getDataForHot];
    }];
}

#pragma mark - 筛选
- (void)filterSex:(HotMenuButton *)button{
    for (int i = 0 ; i < 3; i ++) {
        if (i != _filterSortFlag) {
            [_isChangedFilter replaceObjectAtIndex:i withObject:@"1"];
        }else{
            [_isChangedFilter replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    
    for (int i = 0 ; i < _sexFilterButtons.count; i ++) {
        HotMenuButton *btn = [_sexFilterButtons objectAtIndex:i];
        if (btn == button) {
            btn.isGuWenSelected = YES;
            _filterSexFlag = i ;
        }else{
            btn.isGuWenSelected = NO;
        }
    }
}

- (void)filterArea:(HotMenuButton *)button{
    for (int i = 0 ; i < 3; i ++) {
        if (i != _filterSortFlag) {
            [_isChangedFilter replaceObjectAtIndex:i withObject:@"1"];
        }else{
            [_isChangedFilter replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    
    for (int i = 0 ; i < _areaFilterButtons.count; i ++) {
        HotMenuButton *btn = [_areaFilterButtons objectAtIndex:i];
        if (btn == button) {
            btn.isGuWenSelected = YES;
            _filterAreaFlag = i ;
        }else{
            btn.isGuWenSelected = NO;
        }
    }
}

#pragma mark - 获取数据
- (void)getDataForHotWith:(NSInteger)tag{
    [self getDataForHot];
}

- (void)getDataForHot{
    MReqToPlayHomeList *hList = [[MReqToPlayHomeList alloc]init];
    CLLocation *userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc]initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc]initWithString:@(userLocation.coordinate.latitude).stringValue];
    switch (_filterSortFlag) {
        case 0:
            hList.sort = @"popularityasc";
            hList.p = @(_pagePopularity);
            break;
        case 1:
            hList.sort = @"distanceasc";
            hList.p = @(_pageDistance);
            break;
        case 2:
            hList.sort = @"recommendasc";
            hList.p = @(_pageRecommend);
            break;
        default:
            break;
    }
    hList.per = @(PAGESIZE);
    hList.gender = @(_filterSexFlag).stringValue;
    if(_filterAreaFlag > 0 && _filterAreaFlag < placeTitleArr.count){
        hList.address = [placeTitleArr objectAtIndex:_filterAreaFlag];
    }
    if (![MyUtil isEmptyString:_cityName]) {
        hList.city = _cityName;
    }
    NSDictionary *dict = [hList mj_keyValues];
    
    [LYAdviserHttpTool lyGetAdviserListWithParams:dict complete:^(HomePageModel *model) {
        LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_filterSortFlag inSection:0]];
        
        NSArray *arrayTemp = model.viplist;
        if (arrayTemp.count > 0) {
            [self hideKongView];
            if (_filterSortFlag == 0) {
                if (_pagePopularity == 1) {
                    [[_dataArray objectAtIndex:0]removeAllObjects];
                    cell.collectViewInside.contentOffset = CGPointMake(0, -90);
                    [cell.collectViewInside.mj_header endRefreshing];
                }
                [cell.collectViewInside.mj_footer endRefreshing];
                _pagePopularity ++;
                [[_dataArray objectAtIndex:0]addObjectsFromArray:arrayTemp];
            }else if (_filterSortFlag == 1){
                if (_pageDistance == 1) {
                    [[_dataArray objectAtIndex:1]removeAllObjects];
                    [cell.collectViewInside.mj_header endRefreshing];
                }
                [cell.collectViewInside.mj_footer endRefreshing];
                _pageDistance ++;
                [[_dataArray objectAtIndex:1]addObjectsFromArray:arrayTemp];
            }else if (_filterSortFlag == 2){
                if (_pageRecommend == 1) {
                    [[_dataArray objectAtIndex:2]removeAllObjects];
                    [cell.collectViewInside.mj_header endRefreshing];
                }
                [cell.collectViewInside.mj_footer endRefreshing];
                _pageRecommend ++;
                [[_dataArray objectAtIndex:2]addObjectsFromArray:arrayTemp];
            }
        }else{
//            if ([cell.collectViewInside.mj_header isRefreshing]) {
//                [cell.collectViewInside.mj_header endRefreshing];
//            }
            if (_filterSortFlag == 0) {
                if (_pagePopularity == 1) {
                    [self initKongView];
                    [[_dataArray objectAtIndex:0]removeAllObjects];
                    [cell.collectViewInside.mj_header endRefreshing];
                }
            }
            if (_filterSortFlag == 1) {
                if (_pageDistance == 1) {
                    [self initKongView];
                    [[_dataArray objectAtIndex:1]removeAllObjects];
                    [cell.collectViewInside.mj_header endRefreshing];
                }
            }
            if (_filterSortFlag == 2) {
                if (_pageRecommend == 1) {
                    [self initKongView];
                    [[_dataArray objectAtIndex:2]removeAllObjects];
                    [cell.collectViewInside.mj_header endRefreshing];
                }
            }
            
            [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
        }
        [cell.collectViewInside reloadData];
    }];
}

#pragma mark - 空界面
- (void)initKongView{
    if (!_kongLabel) {
        _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 45, SCREEN_WIDTH, 20)];
        [_kongLabel setText:@"抱歉，暂无顾问入驻！"];
        [_kongLabel setTextAlignment:NSTextAlignmentCenter];
        [_kongLabel setFont:[UIFont systemFontOfSize:14]];
        [_kongLabel setTextColor:RGBA(186, 40, 227, 1)];
        _kongLabel.layer.zPosition = 3;
    }
        [self.view addSubview:_kongLabel];
    
}

- (void)hideKongView{
    [_kongLabel removeFromSuperview];
}


#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYGuWenOutsideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenOutsideCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.typeForShow = 1;
    cell.delegate = self;
    
    NSArray *array = _dataArray[indexPath.item];
    
//    __weak LYHotBarsViewController *weakSelf = self;
    __weak __typeof(self)weakSelf = self;
    cell.collectViewInside.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _filterSortFlag = indexPath.item;
        switch (indexPath.item) {
            case 0:{
                _pagePopularity = 1;
                [weakSelf getDataForHot];
            }
            break;
                
            case 1:{
                _pageDistance = 1;
                [weakSelf getDataForHot];
            }
            break;
                
            case 2:{
                _pageRecommend = 1;
                [weakSelf getDataForHot];
            }
            break;
        }
    }];
    
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)cell.collectViewInside.mj_header;
    [self initMJRefeshHeaderForGif:header];
    cell.collectViewInside.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _filterSortFlag = indexPath.item;
        switch (indexPath.item) {
            case 0:{
                [weakSelf getDataForHot];
            }
            break;
                
            case 1:{
                [weakSelf getDataForHot];
            }
            break;
                
            case 2:{
                [weakSelf getDataForHot];
            }
            break;
        }
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)cell.collectViewInside.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
    cell.guWenArray = array;
    return cell;

}

#pragma mark - 滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideKongView];
    if (scrollView == _collectView) {
        UIButton *hotBtn = _menuBtnArray[0];
        CGFloat offsetWidth = scrollView.contentOffset.x;
        CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
        CGFloat startCenterY = _purpleLineView.center.y;
        _purpleLineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth / SCREEN_WIDTH + hotBtn.center.x , startCenterY);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollEnd];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollEnd];
}

- (void)scrollEnd{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isGuWenSelected = NO;
    }
    _index = (NSInteger)_collectView.contentOffset.x / SCREEN_WIDTH;
    HotMenuButton *btn = [_menuBtnArray objectAtIndex:_index];
    btn.isGuWenSelected = YES;
    _filterSortFlag = _index;
    self.titleText = [NSString stringWithFormat:@"%@顾问",btn.titleLabel.text];
    if (_dataArray.count) {
        NSArray *array = [_dataArray objectAtIndex:_index];
        if (!array.count || [[_isChangedFilter objectAtIndex:_index] isEqualToString:@"1"]) {
            LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
//            _filterSortFlag = _index;
            [_isChangedFilter replaceObjectAtIndex:_filterSortFlag withObject:@"0"];
            [cell.collectViewInside.mj_header beginRefreshing];
        }
//        else{
//            [self hideKongView];
//        }
    }
}

#pragma mark - select delegate
- (void)GuWenSelected:(NSString *)userID{
//    LYGuWenDetailViewController *detailVC = [[LYGuWenDetailViewController alloc]initWithNibName:@"LYGuWenDetailViewController" bundle:nil];
    LYMyFriendDetailViewController *detailVC = [[LYMyFriendDetailViewController alloc]init];
    detailVC.userID = userID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
