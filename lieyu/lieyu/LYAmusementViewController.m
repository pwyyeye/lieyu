//
//  LYAmusementViewController.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "HDDetailViewController.h"
#import "LYAmusementViewController.h"
#import "HotMenuButton.h"
#import "LYYUTableViewCell.h"
#import "LYYUHttpTool.h"
#import "YUOrderShareModel.h"
#import "CustomerModel.h"
#import "YUOrderInfo.h"
#import "YUPinkerListModel.h"
#import "LYFriendsToUserMessageViewController.h"
#import "YUOrderShareModel.h"
#import "LYHotBarMenuDropView.h"
#import "MJRefresh.h"
#import "LYYUCollectionViewCell.h"
#import <CoreGraphics/CoreGraphics.h>
#import "LYUserLocation.h"


#define PAGESIZE 20

@interface LYAmusementViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,LYHotBarMenuDropViewDelegate>{
    UIScrollView *_scrollView;
    NSMutableArray *_collectviewArray,*_menuBtnArray,*_dataArray;
    UIVisualEffectView *_menuView;
    UILabel *_titelLabel;
    UIView *_purpleLineView;
//    NSInteger _currentPageHot,_currentPageDistance,_currentPagePrice,_currentPageTime;
        NSInteger _currentPageDistance,_currentPageTime;
    NSInteger _index;
    LYHotBarMenuDropView *_menuDropView;
    UIButton *_sectionBtn;
    NSString *_sectionTitle_distance,*_sectionTitle_time;//记录是否换过区
}

@end

@implementation LYAmusementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAllProperty];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(_menuDropView) {
        [_menuDropView removeFromSuperview];
        _menuDropView = nil;
        _sectionBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupAllProperty{
//    _currentPageHot = 1;
    _currentPageDistance= 1;
//    _currentPagePrice = 1;
    _currentPageTime = 1;
    _dataArray = [[NSMutableArray alloc]initWithCapacity:4];
    for (int i = 0; i < 4; i ++) {
        [_dataArray addObject:[[NSMutableArray alloc]init]];
    }
    [self createUI];
}

- (void)createUI{
    
    _collectviewArray = [[NSMutableArray alloc]initWithCapacity:2];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 2; i ++) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *tableView = [[UICollectionView alloc]initWithFrame:CGRectMake(i%2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView setContentInset:UIEdgeInsetsMake(94, 0, 49,0)];
        tableView.backgroundColor = RGBA(243, 243, 243, 1);
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [tableView registerNib:[UINib nibWithNibName:@"LYYUTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYYUTableViewCell"];
        [tableView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [tableView registerNib:[UINib nibWithNibName:@"LYYUCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYYUCollectionViewCell"];
        [_scrollView addSubview:tableView];
        [_collectviewArray addObject:tableView];
    }
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _collectviewArray.count, 0)];
    [self installFreshEvent];
    UICollectionView *tableView = _collectviewArray[0];
    [tableView.mj_header beginRefreshing];
    [self createMenuUI];
}

- (void)createMenuUI{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.1;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
    CGFloat offSet = 26;
    _menuBtnArray = [[NSMutableArray alloc]initWithCapacity:2];
    NSArray *btnTitleArray = @[@"热门",@"时间",@"附近",@"价格"];
    for (int i = 0; i < 4; i ++) {
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        if (i == 0) {
            btn.frame = CGRectMake(offSet, 63,btnWidth, 26);
            btn.isMenuSelected = YES;
        }else{
            btn.frame = CGRectMake(offSet + i%4 * btnWidth, 63, btnWidth, 26);
            btn.isMenuSelected = NO;
        }
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
//        btn.tag = i;
        [btn addTarget:self action:@selector(btnMenuViewClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1 || i == 2)  {
            btn.tag = i - 1;
            [_menuView addSubview:btn];
            [_menuBtnArray addObject:btn];
        }
    }
    
    
    
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = @"娱";
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];
    
    _sectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 35, 88, 19)];
    [_sectionBtn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionBtn setTitle:@"所有地区" forState:UIControlStateNormal];
    _sectionTitle_distance = _sectionBtn.currentTitle;
    _sectionTitle_time = _sectionBtn.currentTitle;
    _sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sectionBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [_sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [_sectionBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [_menuView addSubview:_sectionBtn];
    
    _purpleLineView = [[UIView alloc]init];
    HotMenuButton *hotBtn = _menuBtnArray[0];
    CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
    CGFloat offsetWidth = _scrollView.contentOffset.x;
    _purpleLineView.frame = CGRectMake(0, _menuView.size.height - 2, 42, 2);
    _purpleLineView.backgroundColor = RGBA(186, 40, 227, 1);
    _purpleLineView.center = CGPointMake(hotBtn.center.x + offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH , CGRectGetCenter(_purpleLineView.frame).y);
    [_menuView addSubview:_purpleLineView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
        HotMenuButton *btn = _menuBtnArray[0];
        _purpleLineView.center = CGPointMake(btn.center.x + offX * btnWidth / SCREEN_WIDTH, _purpleLineView.center.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        _index = offX/SCREEN_WIDTH;
        for (HotMenuButton *btn in _menuBtnArray) {
            btn.isMenuSelected = NO;
        }
        ((HotMenuButton *)_menuBtnArray[_index]).isMenuSelected = YES;
        
        if(!((NSArray *)_dataArray[_index]).count || ![_sectionTitle_time isEqualToString:_sectionTitle_distance]){
            UICollectionView *tableview = _collectviewArray[_index];
            [tableview.mj_header beginRefreshing];
            _sectionTitle_time = _sectionBtn.currentTitle;
            _sectionTitle_distance = _sectionBtn.currentTitle;
        }
    }
}

#pragma mark 选择区的action
- (void)sectionClick:(UIButton *)button{
    if(_menuDropView) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.8];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _menuDropView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
        [UIView commitAnimations];
        [self performSelector:@selector(removeMenuView) withObject:self afterDelay:.8];
        [UIView animateWithDuration:.5 animations:^{
            
            button.imageView.transform = CGAffineTransformMakeRotation(0);
            //            button.imageView.transform = CGAffineTransformMakeScale(2, 2);
        }];
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        //        button.imageView.transform = CGAffineTransformMakeScale(1, 1);
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    _menuDropView = [[LYHotBarMenuDropView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT - 65)];
    NSArray *array = @[@"所有地区",@"杨浦区",@"虹口区",@"闸北区",@"普陀区",@"黄浦区",@"静安区",@"长宁区",@"卢湾区",@"徐汇区",@"闵行区",@"浦东新区",@"宝山区",@"松江区",@"嘉定区",@"青浦区",@"金山区",@"奉贤区",@"南汇区",@"崇明县"];
    _menuDropView.backgroundColor = [UIColor whiteColor];
    [_menuDropView deployWithItemArrayWith:array withTitle:button.currentTitle];
    _menuDropView.delegate = self;
    _menuDropView.alpha = 0;
    [self.view addSubview:_menuDropView];
    [self.view bringSubviewToFront:_menuView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _menuDropView.alpha = 1.0;
    _menuDropView.frame = CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [UIView commitAnimations];
}

#pragma mark LYHotBarMenuDropViewDelegate
- (void)lyHotBarMenuButton:(UIButton *)menuBtn withIndex:(NSInteger)index{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    _menuDropView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    _menuDropView.alpha = 0.0;
    [UIView commitAnimations];
    
    [UIView animateWithDuration:.5 animations:^{
        _sectionBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
    [self performSelector:@selector(removeMenuView) withObject:self afterDelay:.3];
    [_sectionBtn setTitle:menuBtn.currentTitle forState:UIControlStateNormal];
    
    if (!_index) {
        _sectionTitle_distance = menuBtn.currentTitle;
    }else{
        _sectionTitle_time = menuBtn.currentTitle;
    }
    UICollectionView *collectView = _collectviewArray[_index];
    [collectView.mj_header beginRefreshing];
}

- (void)removeMenuView{
    [_menuDropView removeFromSuperview];
    _menuDropView = nil;
}

#pragma mark 热门，附近，价格，时间的acrion
- (void)btnMenuViewClick:(HotMenuButton *)button{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    button.isMenuSelected = YES;
    [_scrollView setContentOffset:CGPointMake(button.tag *SCREEN_WIDTH, 0) animated:YES];
    if(!((NSArray *)_dataArray[button.tag]).count || ![_sectionTitle_time isEqualToString:_sectionTitle_distance]){
        UICollectionView  *tableview = _collectviewArray[button.tag];
        [tableview.mj_header beginRefreshing];
        _sectionTitle_distance = _sectionBtn.currentTitle;
        _sectionTitle_time = _sectionBtn.currentTitle;
    }
    
}


- (void)getDataForHotWith:(NSInteger)tag{
    NSString *p = nil;
    NSDictionary *dic = nil;
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    NSString *longitude = [NSString stringWithFormat:@"%@",[[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue]];
    NSString *latitude = [NSString stringWithFormat:@"%@",[[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue]];
    NSString *address = nil;
    if ([_sectionBtn.currentTitle isEqualToString:@"所有地区"]) {
        address = @"";
    }else{
        address = _sectionBtn.currentTitle;
    }
    switch (tag) {
        case 0:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPageDistance];
            dic = @{@"p":p,@"per":[NSString stringWithFormat:@"%d",PAGESIZE],@"longitude":longitude,@"latitude":latitude,@"address":address,@"sort":@"rebatedesc"};
        }
            break;
        case 1:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPageTime];
            dic = @{@"p":p,@"per":[NSString stringWithFormat:@"%d",PAGESIZE],@"longitude":longitude,@"latitude":latitude,@"address":address,@"sort":@"distanceasc"};
        }
            break;
    }
//    dic = @{@"p":p,@"per":[NSString stringWithFormat:@"%d",PAGESIZE],@"longitude":longitude,@"latitude":latitude};
    [LYYUHttpTool yuGetDataOrderShareWithParams:dic compelte:^(NSArray *dataArray) {
        if(tag >= 4) return ;
        NSMutableArray *array = _dataArray[tag];
        switch (tag) {
            case 0:
            {
                if(_currentPageDistance == 1){
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPageDistance ++;
            }
                break;
            case 1:
            {
                if(_currentPageTime == 1) {
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPageTime ++;
            }
                break;
        }
        
        UICollectionView *tableView = _collectviewArray[tag];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_header endRefreshing];
            switch (tag) {
                case 0:
                {
                    if (_currentPageDistance != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
                case 1:
                {
                    if (_currentPageTime != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
            }
            //                [tableView reloadData];
            [UIView transitionWithView:tableView
                              duration: 0.6f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void){
                                [tableView reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }];
            //            NSIndexSet *indexS = [NSIndexSet indexSetWithIndex:0];
            //            [tableView reloadSections:indexS withRowAnimation:UITableViewRowAnimationFade];
        });
    }];
}

- (void)installFreshEvent
{
    for (int i = 0; i < _collectviewArray.count; i ++) {
        if(!_collectviewArray.count) return;
        __weak UITableView *tableView = _collectviewArray[i];
        __weak LYAmusementViewController * weakSelf = self;
        tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            switch (i) {
                case 0:
                {
                    _currentPageDistance = 1;
                    [weakSelf getDataForHotWith:0];
                }
                    break;
                case 1:
                {
                    _currentPageTime = 1;
                    [weakSelf getDataForHotWith:1];
                }
                    break;
            }
        }];
        
        MJRefreshGifHeader *header=(MJRefreshGifHeader *)tableView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        
        tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
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
        MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)tableView.mj_footer;
        [self initMJRefeshFooterForGif:footer];
        NSLog(@"------>tableview.mj_footer:%@",tableView.mj_footer);
        
    }
    
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray *)_dataArray[collectionView.tag]).count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 221 + 6 + (SCREEN_WIDTH - (68 + 10 + 4 * 20))/5.f + 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LYYUCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYYUCollectionViewCell" forIndexPath:indexPath];
    cell.btn_headerImg.tag = indexPath.row;
    [cell.btn_headerImg addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    for (int i = 0; i < cell.btnArray.count; i ++) {
        UIButton *btn = cell.btnArray[i];
        btn.tag = cell.btnArray.count * indexPath.row + i;
        [btn addTarget:self action:@selector(pinkerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    YUOrderShareModel *orderM = _dataArray[collectionView.tag][indexPath.row];
    cell.orderModel = orderM;
    if (orderM.orderInfo.pinkerList.count >= 5) {
        cell.btn_more.tag = indexPath.item;
        [cell.btn_more addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)btnMoreClick:(UIButton *)button{
    HDDetailViewController *HDDetailVC = [[HDDetailViewController alloc]initWithNibName:@"HDDetailViewController" bundle:[NSBundle mainBundle]];
    YUOrderShareModel *orderM = _dataArray[_index][button.tag];
    HDDetailVC.YUModel = orderM;
    [self.navigationController pushViewController:HDDetailVC  animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HDDetailViewController *HDDetailVC = [[HDDetailViewController alloc]initWithNibName:@"HDDetailViewController" bundle:[NSBundle mainBundle]];
    YUOrderShareModel *orderM = _dataArray[collectionView.tag][indexPath.row];
    HDDetailVC.YUModel = orderM;
    [self.navigationController pushViewController:HDDetailVC  animated:YES];
}


#pragma mark hot头像的action
- (void)headerClick:(UIButton *)button{
    NSArray *array = _dataArray[_index];
    if (button.tag + 1 > array.count) {
        return;
    }
    YUOrderShareModel *orderModel = array[button.tag];
    LYFriendsToUserMessageViewController *friendsVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsVC.friendsId = orderModel.orderInfo.userid;
    [self.navigationController pushViewController:friendsVC animated:YES];
}

- (void)pinkerClick:(UIButton *)button{
    NSInteger tag = button.tag %5;
    NSArray *array = _dataArray[_index];
    if (tag + 1 > array.count) {
        return;
    }
    YUOrderShareModel *orderModel = array[tag];
    if (tag + 1 > orderModel.orderInfo.pinkerList.count) {
        return;
    }
    YUPinkerListModel *pinkerListM = orderModel.orderInfo.pinkerList[tag];
    LYFriendsToUserMessageViewController *friendsVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsVC.friendsId = pinkerListM.inmember;
    [self.navigationController pushViewController:friendsVC animated:YES];
    
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
