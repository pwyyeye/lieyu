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

#define PAGESIZE 20
#define HOMEPAGE_MTA @"HOMEPAGE"
#define HOMEPAGE_TIMEEVENT_MTA @"HOMEPAGE_TIMEEVENT"

@interface HomePageINeedPlayViewController ()
<EScrollerViewDelegate,
    UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
>{
    UIButton *_cityChooseBtn;
    UIButton *_searchBtn;
    UIImageView *_titleImageView;
    CGFloat _scale;
    UICollectionView *_collectView;
    UIButton *_btn_yedian;
    UIButton *_btn_bar;
    UIView *_lineView;
    UIVisualEffectView *_navView;
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 90) collectionViewLayout:layout];
    _collectView.backgroundColor = RGBA(243, 243, 243, 1);
    [self.view addSubview:_collectView];
    
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _collectView.bounds=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
     self.curPageIndex = 1;
     self.aryList=[[NSMutableArray alloc]init];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    _collectView.showsHorizontalScrollIndicator=NO;
    [self setupViewStyles];
    [self getData];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.shadowRadius = 1;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
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
    _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90 - 20);
    [self.navigationController.navigationBar addSubview:_navView];
    
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 40, 27)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:@"上海" forState:UIControlStateNormal];
    [_cityChooseBtn setTitleColor:RGBA(1, 1, 1, 1) forState:UIControlStateNormal];
    _cityChooseBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    [_cityChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 20, 0, 0)];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_cityChooseBtn];
    
    CGFloat searchBtnWidth = 24;
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - searchBtnWidth, 10, searchBtnWidth, searchBtnWidth)];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_searchBtn];
    
    CGFloat titleImgViewWidth = 40;
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - titleImgViewWidth)/2.f , 9.5, titleImgViewWidth, titleImgViewWidth)];
    _titleImageView.image = [UIImage imageNamed:@"logo"];
    [_navView addSubview:_titleImageView];
    
    _btn_yedian = [[UIButton alloc]initWithFrame:CGRectMake(47, 20, 24, 28)];
    [_btn_yedian setTitle:@"夜店" forState:UIControlStateNormal];
    [_btn_yedian addTarget:self action:@selector(yedianClick) forControlEvents:UIControlEventTouchUpInside];
    _btn_yedian.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_btn_yedian setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [_navView addSubview:_btn_yedian];
    [_btn_yedian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_navView.mas_bottom).with.offset(-5);
        make.left.mas_equalTo(_navView.mas_left).with.offset(130);
        make.size.mas_equalTo(CGSizeMake(24, 28));
    }];

    _btn_bar = [[UIButton alloc]init];
    [_btn_bar setTitle:@"酒吧" forState:UIControlStateNormal];
        [_btn_bar addTarget:self action:@selector(barClick) forControlEvents:UIControlEventTouchUpInside];
    _btn_bar.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_btn_bar setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [_navView addSubview:_btn_bar];
    [_btn_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_navView.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(_navView.mas_right).with.offset(-130);
        make.size.mas_equalTo(CGSizeMake(24, 28));
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [_navView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(_btn_yedian.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(42, 1));
    }];

}
- (void)yedianClick{
    NSLog(@"---->夜店");
}
- (void)barClick{
    NSLog(@"---->酒吧");
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
    [_btn_bar removeFromSuperview];
    [_btn_yedian removeFromSuperview];
    [_navView removeFromSuperview];
    [_lineView removeFromSuperview];
}

//筛选，跳转，增加，删除，确认

#pragma mark 选择城市action
- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"选择城市"]];
}

#pragma mark 搜索action
- (void)searchClick:(UIButton *)sender {
    LYHomeSearcherViewController *homeSearchVC = [[LYHomeSearcherViewController alloc]init];
    [self.navigationController pushViewController:homeSearchVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"搜索"]];
}



#pragma mark 获取数据
-(void)getData{
    if([MyUtil configureNetworkConnect] == 0){
        NSArray *array = [self getDataFromLocal];
        if (array.count) {
            NSDictionary *dataDic = ((LYCache *)array.firstObject).lyCacheValue;
            self.aryList = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]] ;
            self.bannerList = dataDic[@"banner"];
            self.newbannerList = dataDic[@"newbanner"];
            self.bartypeslistArray = [[NSMutableArray alloc]initWithArray:[bartypeslistModel mj_objectArrayWithKeyValuesArray:dataDic[@"bartypeslist"]]] ;
            [_collectView reloadData];
            return;
        }
    }
    __weak HomePageINeedPlayViewController * weakSelf = self;
    [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 _collectView.mj_footer.hidden = NO;
             }
             else
             {
                 _collectView.mj_footer.hidden = YES;
             }
         }
     }];
}

- (void)loadHomeList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block
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
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList pageIndex:1 results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList,NSArray *newbanner,NSMutableArray *bartypeslist) {
        if (ermsg.state == Req_Success)
        {
            if (weakSelf.curPageIndex == 1) {
                [weakSelf.aryList removeAllObjects];
                //                [weakSelf.bannerList removeAllObjects];
                weakSelf.bannerList = bannerList.mutableCopy;
                weakSelf.newbannerList = newbanner.mutableCopy;
                weakSelf.bartypeslistArray = bartypeslist;
            }
            [weakSelf.aryList addObjectsFromArray:barList.mutableCopy] ;
            [_collectView reloadData];
        }
        block !=nil? block(ermsg,bannerList,barList):nil;
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
    [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
    [_collectView registerNib:[UINib nibWithNibName:@"HomeMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeMenuCollectionViewCell"];
}

- (void)installFreshEvent
{
    __weak HomePageINeedPlayViewController * weakSelf = self;
    _collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
                             ^{
                                 weakSelf.curPageIndex = 1;
                                 [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
                                  {
                                      if (Req_Success == ermsg.state)
                                      {
                                          if (barList.count == PAGESIZE)
                                          {
                                              weakSelf.curPageIndex = 2;
                                              _collectView.mj_footer.hidden = NO;
                                          }
                                          else
                                          {
                                              _collectView.mj_footer.hidden = YES;
                                          }
                                          [_collectView.mj_header endRefreshing];
                                      }
                                  }];
                             }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)_collectView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    _collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                if (barList.count == PAGESIZE)
                {
                    _collectView.mj_footer.hidden = NO;
                }
                else
                {
                    _collectView.mj_footer.hidden = YES;
                }
                weakSelf.curPageIndex ++;
                [_collectView.mj_footer endRefreshing];
            }
        }];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)_collectView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
   
}

#pragma mark 离我最近
- (IBAction)aroundMeClick:(id)sender {
    LYCloseMeViewController *closeMeVC = [[LYCloseMeViewController alloc]init];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:NO];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
//    NSArray
//    [self.aryList sortUsingDescriptors:sortDescriptors];
    
    closeMeVC.beerBarArray = self.aryList;
    [self.navigationController pushViewController:closeMeVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:@"离我最近"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark UITableViewDataSoucre&UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0://广告
                case 1://娱乐分类
        {
          LYAmusementClassCell *amuseCell =[tableView dequeueReusableCellWithIdentifier:@"LYAmusementClassCell" forIndexPath:indexPath];
            amuseCell.bartypeArray = self.bartypeslistArray;
            amuseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIButton *btn in amuseCell.buttonArray) {
                [btn addTarget:self action:@selector(hotJiuClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return amuseCell;
        }
            break;
        case 2://热门推荐
        {
            LYHotRecommandCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
        }
            break;
        
        default://酒吧列表
        {
            LYWineBarCell *wineCell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
            wineCell.selectionStyle = UITableViewCellSelectionStyleNone;
            wineCell.btn_star.userInteractionEnabled = NO;
            wineCell.btn_zang.userInteractionEnabled = NO;
            JiuBaModel *jiuBaModel = self.aryList[indexPath.section - 3];
            wineCell.jiuBaModel = jiuBaModel;
            return wineCell;
        }
            break;
    }
  return cell;
}

 */

#pragma mark UICollectionViewDataSource 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _aryList.count + 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item >= 2 && indexPath.item <= 5){
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
    return UIEdgeInsetsMake(0, 3, 3, 3);
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
            if(_aryList.count){
                JiuBaModel *jiuBaM = _aryList[0];
                jiubaCell.jiuBaM = jiuBaM;
            }
            return jiubaCell;
    }else if(indexPath.row >= 2 & indexPath.row <= 5){
        NSArray *picNameArray = @[@"热门",@"附近",@"价格",@"返利"];
            HomeMenuCollectionViewCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCollectionViewCell" forIndexPath:indexPath];
        menuCell.imgView_bg.userInteractionEnabled = YES;
        [menuCell.imgView_title setImage:[UIImage imageNamed:picNameArray[indexPath.row - 2]]];
        menuCell.label_title.text = picNameArray[indexPath.row - 2];
            menuCell.backgroundColor = [UIColor cyanColor];
        menuCell.label_title.shadowOffset = CGSizeMake(0, 0.5);
            return menuCell;
        }else{
            HomeBarCollectionViewCell *jiubaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
            JiuBaModel *jiuBaM = _aryList[indexPath.row - 5];
            jiubaCell.jiuBaM = jiuBaM;
            return jiubaCell;
        }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *jiuBaM = nil;
    if(indexPath.item == 1){
        jiuBaM = _aryList[indexPath.item - 1];
    }else if(indexPath.item >= 6){
        jiuBaM = _aryList[indexPath.item - 5];
    }else if(indexPath.item >= 2&& indexPath.item <= 5){
//        LYHotBarViewController *hotJiuBarVC = [[LYHotBarViewController alloc]init];
        LYHotBarViewController *hotBarVC = [[LYHotBarViewController alloc]init];
//        NSMutableArray *titleArray = [[NSMutableArray alloc]initWithCapacity:0];
//        for (int i = 0;  i < self.bartypeslistArray.count; i ++) {
//            bartypeslistModel *bartypeModel = self.bartypeslistArray[i];
//            [titleArray addObject:bartypeModel.name];
//        }
//        hotJiuBarVC.titleArray = titleArray;
//        hotJiuBarVC.bartypeArray = self.bartypeslistArray;
//        if(!self.bartypeslistArray.count) return;
//        hotJiuBarVC.subidStr = ((bartypeslistModel *)self.bartypeslistArray[indexPath.item - 2]).subids;
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
    
//    LYWineBarCell *cell = (LYWineBarCell *)[tableView cellForRowAtIndexPath:indexPath];
}
#pragma mark 跳转热门酒吧界面
- (void)hotJiuClick:(UIButton *)button{
    
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
