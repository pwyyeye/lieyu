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

#define PAGESIZE 20

@interface LYAmusementViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,LYHotBarMenuDropViewDelegate>{
    UIScrollView *_scrollView;
    NSMutableArray *_tableViewArray,*_menuBtnArray,*_dataArray;
    UIVisualEffectView *_menuView;
    UILabel *_titelLabel;
    UIView *_purpleLineView;
    NSInteger _currentPageHot,_currentPageDistance,_currentPagePrice,_currentPageTime;
    NSInteger _index;
    LYHotBarMenuDropView *_menuDropView;
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
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = YES;
}

 - (void)setupAllProperty{
     _currentPageHot = 1;
     _currentPageDistance= 1;
     _currentPagePrice = 1;
     _currentPageTime = 1;
     _dataArray = [[NSMutableArray alloc]initWithCapacity:4];
     for (int i = 0; i < 4; i ++) {
         [_dataArray addObject:[[NSMutableArray alloc]init]];
     }
     [self createUI];
}
                                  
- (void)createUI{
    
    _tableViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i%4 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView setContentInset:UIEdgeInsetsMake(90, 0, 100,0)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LYYUTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYYUTableViewCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_scrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
    [self installFreshEvent];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tableViewArray.count, 0)];
    UITableView *tableView = _tableViewArray[0];
    [tableView.mj_header beginRefreshing];
    [self createMenuUI];
}

- (void)createMenuUI{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
    CGFloat offSet = 26;
    _menuBtnArray = [[NSMutableArray alloc]initWithCapacity:4];
    NSArray *btnTitleArray = @[@"热门",@"附近",@"价格",@"时间"];
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
        btn.tag = i;
        [btn addTarget:self action:@selector(btnMenuViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:btn];
        [_menuBtnArray addObject:btn];
    }
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = @"娱";
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];
    
    UIButton *sectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 40, 70, 19)];
    [sectionBtn addTarget:self action:@selector(sectionClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionBtn setTitle:@"徐汇区" forState:UIControlStateNormal];
    sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sectionBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [sectionBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_menuView addSubview:sectionBtn];
    
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
        
        if(!((NSArray *)_dataArray[_index]).count){
            UITableView *tableview = _tableViewArray[_index];
            [tableview.mj_header beginRefreshing];
        }
    }
}

#pragma mark 选择区的action
- (void)sectionClick{
    _menuDropView = [[LYHotBarMenuDropView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 65, SCREEN_WIDTH,SCREEN_HEIGHT - 65)];
     NSArray *array = @[@"所有地区",@"杨浦区",@"虹口区",@"闸北区",@"普陀区",@"黄浦区",@"静安区",@"长宁区",@"卢湾区",@"徐汇区",@"闵行区",@"浦东新区",@"宝山区",@"松江区",@"嘉定区",@"青浦区",@"金山区",@"奉贤区",@"南汇区",@"崇明县"];
    _menuDropView.backgroundColor = [UIColor whiteColor];
    [_menuDropView deployWithItemArrayWith:array];
    _menuDropView.delegate = self;
    _menuDropView.isYu = YES;
    [self.view addSubview:_menuDropView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _menuDropView.frame = CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [UIView commitAnimations];
    
}

#pragma mark LYHotBarMenuDropViewDelegate
- (void)lyHotBarMenuButton:(UIButton *)menuBtn withIndex:(NSInteger)index{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    _menuDropView.frame = CGRectMake(-SCREEN_WIDTH, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [UIView commitAnimations];
}

#pragma mark 热门，附近，价格，时间的acrion
- (void)btnMenuViewClick:(HotMenuButton *)button{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    button.isMenuSelected = YES;
    [_scrollView setContentOffset:CGPointMake(button.tag *SCREEN_WIDTH, 0) animated:YES];
    if(!((NSArray *)_dataArray[button.tag]).count){
        UITableView *tableview = _tableViewArray[button.tag];
        [tableview.mj_header beginRefreshing];
    }
    
}

- (void)getDataForHotWith:(NSInteger)tag{
    NSString *p = nil;
    
    switch (tag) {
        case 0:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPageHot];
        }
            break;
        case 1:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPageDistance];
        }
            break;
        case 2:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPagePrice];
        }
            break;
        case 3:
        {
            p = [NSString stringWithFormat:@"%ld",_currentPageTime];
        }
            break;
    }
    NSDictionary *dic = @{@"p":p,@"per":[NSString stringWithFormat:@"%d",PAGESIZE]};
    [LYYUHttpTool yuGetDataOrderShareWithParams:dic compelte:^(NSArray *dataArray) {
        if(tag >= 4) return ;
        NSMutableArray *array = _dataArray[tag];
        switch (tag) {
            case 0:
            {
                if(_currentPageHot == 1){
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPageHot ++;
            }
                break;
            case 1:
            {
                if(_currentPageDistance == 1) {
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPageDistance ++;
            }
                break;
            case 2:
            {
                if(_currentPagePrice == 1) {
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPagePrice ++;
            }
                break;
            case 3:
            {
                if(_currentPageTime == 1) {
                    [array removeAllObjects];
                }
                [array addObjectsFromArray:dataArray];
                _currentPageTime ++;
            }
                break;
        }
        
        UITableView *tableView = _tableViewArray[tag];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_header endRefreshing];
            switch (tag) {
                case 0:
                {
                    if (_currentPageHot != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
                case 1:
                {
                    if (_currentPageDistance != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
                case 2:
                {
                    if (_currentPagePrice != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
                case 3:
                {
                    if (_currentPageTime != 1 && !dataArray.count) {
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer endRefreshing];
                    }
                }
                    break;
            }
//            [tableView reloadData];
            NSIndexSet *indexS = [NSIndexSet indexSetWithIndex:0];
            [tableView reloadSections:indexS withRowAnimation:UITableViewRowAnimationLeft];
        });
    }];
}

- (void)installFreshEvent
{
    for (int i = 0; i < _tableViewArray.count; i ++) {
        if(!_tableViewArray.count) return;
        __weak UITableView *tableView = _tableViewArray[i];
        __weak LYAmusementViewController * weakSelf = self;
        //    __weak UITableView *tableView = self.tableView;
        tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
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
                    _currentPageTime = 1;
                    [weakSelf getDataForHotWith:3];
                }
                    break;
            }
        }];
        
        MJRefreshGifHeader *header=(MJRefreshGifHeader *)tableView.mj_header;
        [self initMJRefeshHeaderForGif:header];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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


#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataArray[tableView.tag];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYYUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYYUTableViewCell" forIndexPath:indexPath];
    cell.btn_headerImg.tag = indexPath.row;
    [cell.btn_headerImg addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    for (UIButton *btn in cell.btnArray) {
        btn.tag = cell.btnArray.count * indexPath.row + btn.tag;
        [btn addTarget:self action:@selector(pinkerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    YUOrderShareModel *orderM = _dataArray[tableView.tag][indexPath.row];
    cell.orderModel = orderM;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 221 + (SCREEN_WIDTH - (68 + 10 + 16 + 4 * 20))/5.f + 10;
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
      /*  customerM.sex = [orderModel. isEqualToString:@"0"] ? @"0" : @"1";
        //    customerM.sex = _userInfo.gender;
        customerM.usernick = _userInfo.usernick;
        customerM.message = _userInfo.introduction;
        customerM.imUserId= _userInfo.imUserId;
        customerM.friendName=_userInfo.usernick;
        customerM.friend = _userInfo.userId.intValue;
        customerM.age = [MyUtil getAgefromDate:_userInfo.birthday];
        customerM.birthday=_userInfo.birthday;
        customerM.userid = _userInfo.userId.intValue;
        customerM.tag=_userInfo.tags;
        
        __weak __typeof(self)weakSelf = self;
        LYMyFriendDetailViewController *friendDetailVC = [[LYMyFriendDetailViewController alloc]init];
        friendDetailVC.customerModel = customerM;
        [weakSelf.navigationController pushViewController:friendDetailVC animated:YES]; */
}

- (void)pinkerClick:(UIButton *)button{
    NSArray *array = _dataArray[_index];
    if (button.tag + 1 > array.count) {
        return;
    }
    YUOrderShareModel *orderModel = array[button.tag];
    if (button.tag + 1 > orderModel.orderInfo.pinkerList.count) {
        return;
    }
    YUPinkerListModel *pinkerListM = orderModel.orderInfo.pinkerList[button.tag];
    LYFriendsToUserMessageViewController *friendsVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsVC.friendsId = pinkerListM.inmember;
    [self.navigationController pushViewController:friendsVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
