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
#import "BeerBarDetailViewController.h"

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
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtnArray;
@end

@implementation LYHotBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"热门酒吧";
    _scrollView.delegate = self;
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
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(i%4 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 90) collectionViewLayout:layout];
        collectView.dataSource = self;
        collectView.delegate = self;
        collectView.tag = i;
        [collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
        [_collectArray addObject:collectView];
        [_scrollView addSubview:collectView];
    }
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _collectArray.count, 0)];
    
     [self installFreshEvent];
    [self getDataForHotWith:_contentTag];
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _contentTag, 0)];
    [self createLineForMenuView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)createLineForMenuView{
    UIButton *hotBtn = _menuBtnArray[0];
    _purpleLineView = [[UIView alloc]init];
    CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
    CGFloat offsetWidth = _scrollView.contentOffset.x;
    _purpleLineView.frame = CGRectMake(0, _menuView.size.height - 1, 42, 1);
    _purpleLineView.backgroundColor = RGBA(186, 40, 227, 1);
    _purpleLineView.center = CGPointMake(hotBtn.center.x + offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH , CGRectGetCenter(_purpleLineView.frame).y);
    [_menuView addSubview:_purpleLineView];
}

- (IBAction)btnMenuViewClick:(HotMenuButton *)sender {
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    sender.isMenuSelected = YES;
    [_scrollView setContentOffset:CGPointMake(sender.tag * SCREEN_WIDTH, 0) animated:YES];
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
        if(!array.count) [self getDataForHotWith:_index];
    }
}

- (void)getDataForHotWith:(NSInteger)tag{
    
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    hList.need_page = @(1);
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
            hList.sort = @"rebateasc";
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
             NSMutableArray *array = _dataArray[tag];
             switch (tag) {
                 case 0:
                 {
                     if(_currentPageHot == 1){
                          [_dataArray replaceObjectAtIndex:0 withObject:barList];
                     }else{
                         [array addObjectsFromArray:barList];
                     }
                     _currentPageHot ++;
                 }
                     break;
                 case 1:
                 {
                     if(_currentPageDistance == 1) {
                          [_dataArray replaceObjectAtIndex:1 withObject:barList];
                     }else{
                         [array addObjectsFromArray:barList];
                     }
                     _currentPageDistance ++;
                 }
                     break;
                 case 2:
                 {
                     if(_currentPagePrice == 1) {
                          [_dataArray replaceObjectAtIndex:2 withObject:barList];
                     }else{
                         [array addObjectsFromArray:barList];
                     }
                     _currentPagePrice ++;
                 }
                     break;
                 case 3:
                 {
                     if(_currentPageFanli == 1) {
                          [_dataArray replaceObjectAtIndex:3 withObject:barList];
                     }else{
                         [array addObjectsFromArray:barList];
                     }
                     _currentPageFanli ++;
                 }
                     break;
             }

             
             UICollectionView *collectView = _collectArray[tag];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [collectView reloadData];
                 [collectView.mj_header endRefreshing];
                 if(barList.count) [collectView.mj_footer endRefreshing];
                 else [collectView.mj_footer endRefreshingWithNoMoreData];
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
        collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = _dataArray[collectionView.tag];
    return array.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 9 /16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
    JiuBaModel *jiubaM = _dataArray[collectionView.tag][indexPath.row];
    cell.jiuBaM = jiubaM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count) {
        NSArray *array = _dataArray[collectionView.tag];
        if (array.count) {
            JiuBaModel *jiuM = array[indexPath.item];
            BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
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
