//
//  LYGuWenVideoViewController.m
//  lieyu
//
//  Created by 狼族 on 16/6/4.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenVideoViewController.h"
#import "HotMenuButton.h"
#import "LYAdviserHttpTool.h"
#import "LYGuWenOutsideCollectionViewCell.h"
#import "LYFriendsAMessageDetailViewController.h"

#define margin (SCREEN_WIDTH - 240) / 3
#define LIMIT 10

@interface LYGuWenVideoViewController ()<LYGuWenCollectionDelegate>
{
    UIButton *filterBtn;
    
    UIView *_filterBgView;//筛选背景图
    UIVisualEffectView *_filterView;//筛选菜单毛玻璃
    
    NSArray *classArray ;
    NSMutableArray *_buttonsArray;
    
    NSInteger _filterFlag;
    
    NSInteger _start;
    NSString *_attachType;
    
    NSMutableArray *_dataList;
    
    BOOL _isChangedFilter;
    
    UILabel *_kongLabel;
}

@end

@implementation LYGuWenVideoViewController


- (void)dealloc{
    NSLog(@"LYGuWenVideoViewController   dealloc    success");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    _attachType = @"1";
    classArray = @[@"全部",@"顾问",@"玩友"];
    _dataList = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMenuView{
    [self createFilterView];
    
    
    UIBlurEffect *effectExtraLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    _menuView.alpha = 5;
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = @"直播";
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(5, 30, 30, 30);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:backBtn];
    
    filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 46, 33, 32, 22)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:filterBtn];
}

- (void)createLineForMenuView{
    
}

- (void)createFilterView{
    
    _buttonsArray = [[NSMutableArray alloc]initWithCapacity:classArray.count];
    
    _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    _filterBgView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
    UITapGestureRecognizer *tapFilter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterHideAnimation)];
    [_filterBgView addGestureRecognizer:tapFilter];
    [self.view addSubview:_filterBgView];
    _filterBgView.hidden = YES;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleExtraLight)];
    _filterView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    _filterView.clipsToBounds = YES;
    [_filterBgView addSubview:_filterView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 42, 20)];
    [label setText:@"分类"];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:RGBA(198, 38, 217, 1)];
    [_filterView addSubview:label];
    
    for (int i = 0; i < classArray.count; i ++) {
        HotMenuButton *button = [[HotMenuButton alloc]initWithFrame:CGRectMake(72 + i % 3 * (56 + margin), i / 3 * 35 + 20, 56, 20)];
        [button setTitle:[classArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            button.isGuWenSelected = YES;
        }else{
            button.isGuWenSelected = NO;
        }
        [button addTarget:self action:@selector(filterClass:) forControlEvents:UIControlEventTouchUpInside];
        [_filterView addSubview:button];
        [_buttonsArray addObject:button];
    }
}

- (void)filterClick:(UIButton *)button{
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
        [_filterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, [classArray count] / 3 * 20 + 40)];
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
        if (_isChangedFilter == YES) {
            _start = 0 ;
            _isChangedFilter = NO;
            [self getDataForHot];
        }
    }];
}

- (void)filterClass:(UIButton *)button{
    for (int i = 0 ; i < _buttonsArray.count; i ++) {
        HotMenuButton *btn = [_buttonsArray objectAtIndex:i];
        if (btn == button) {
            _isChangedFilter = YES;
            btn.isGuWenSelected = YES;
            _filterFlag = i ;
        }else{
            btn.isGuWenSelected = NO;
        }
    }
}

- (void)getDataForHotWith:(NSInteger)tag{
    [self getDataForHot];
}

- (void)getDataForHot{
    NSDictionary *dict = @{@"start":[NSNumber numberWithInteger:_start],
                           @"limit":[NSNumber numberWithInteger:LIMIT],
                           @"attachType":_attachType,
                           @"releaseUserType":[NSNumber numberWithInteger:_filterFlag]};
    [LYAdviserHttpTool lyGetAdviserVideoWithParams:dict complete:^(NSArray *dataList) {
        LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        if (dataList.count) {
            [self hideKongView];
            if (_start == 0) {
                //start
                [_dataList removeAllObjects];
                [cell.collectViewInside.mj_header endRefreshing];
                cell.collectViewInside.contentOffset = CGPointMake(0, -64);
            }
            [_dataList addObjectsFromArray:dataList];
            [cell.collectViewInside.mj_footer endRefreshing];
            _start = _start + LIMIT;
            
        }else{
            if (_start == 0) {
                [_dataList removeAllObjects];
                [cell.collectViewInside.mj_header endRefreshing];
                [self initKongView];
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
        [_kongLabel setText:@"抱歉，暂无直播视频！"];
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
    cell.typeForShow = 2;
    cell.delegate = self;
    
    __weak __typeof(self)weakSelf = self;
    cell.collectViewInside.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _start = 0 ;
        [weakSelf getDataForHot];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)cell.collectViewInside.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    cell.collectViewInside.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getDataForHot];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)cell.collectViewInside.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
    cell.videoArray = _dataList;
    
    return cell;
}

//- (void)VideoSelected:(FriendsRecentModel *)recentM{
//    LYFriendsAMessageDetailViewController *detailVC = [[LYFriendsAMessageDetailViewController alloc]init];
//    detailVC.recentM = recentM;
//    detailVC.isFriendToUserMessage = YES;
//    detailVC.isMessageDetail = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}
//
//- (void)lyRecentMessageLikeChange:(NSString *)liked{
//    
//}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end