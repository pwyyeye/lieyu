//
//  LYHotJiuBarViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotJiuBarViewController.h"
#import "LYWineBarCell.h"
#import "LYHotBarMenuViewController.h"
#import "LYHotBarMenuView.h"
#import "ZSManageHttpTool.h"
#import "JiuBaModel.h"
#import "MJRefresh.h"
#import "ProductCategoryModel.h"
#import "MReqToPlayHomeList.h"
#import "LYBaseViewController.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "LYHotBarMenuDropView.h"
#import "BeerBarDetailViewController.h"
#import "bartypeslistModel.h"
#import "UIImage+GIF.h"
#import "MenuButton.h"
#import "LYCache.h"

#define PAGESIZE 20
#define HOTJIUBAPAGE_MTA @"HOTJIUBAPAGE"

@interface LYHotJiuBarViewController ()<UITableViewDataSource,UITableViewDelegate,LYHotBarMenuViewDelegate>
{
    NSString *_addressStr;
    NSString *_pricedescStr;// 人均最高
    NSString *_priceascStr;//人均最低
    NSString *_rebatedescStr;//返利最高
    LYHotBarMenuView *_menuView;
    UIView *_bgView;
    UIImageView *_image_place;
    UILabel *_label_place;
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) LYHotBarMenuViewController *menuVC;
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHotJiuBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _menuView = [[LYHotBarMenuView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    _menuView.delegate = self;
    self.navigationItem.title = _middleStr;
    NSArray *array1 = @[@"所有地区",@"杨浦区",@"虹口区",@"闸北区",@"普陀区",@"黄浦区",@"静安区",@"长宁区",@"卢湾区",@"徐汇区",@"闵行区",@"浦东新区",@"宝山区",@"松江区",@"嘉定区",@"青浦区",@"金山区",@"奉贤区",@"南汇区",@"崇明县"];
    NSArray *array2 = _titleArray;
    NSArray *array3 = @[@"离我最近",@"人均最高",@"人均最低",@"返利最高"];
    [_menuView deployWithMiddleTitle:_middleStr ItemArray:@[array1,array2,array3]];
    [self.view addSubview:_menuView];
    
    self.curPageIndex = 1;
    _aryList = [[NSMutableArray alloc]initWithCapacity:0];
    [self getData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    [self installFreshEvent];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [MTA trackPageViewBegin:ADDRESSPAGE_MTA];
//    [MTA trackCustomEventBegin:LYTIMEEVENT_MTA args:@[ADDRESSPAGE_TIMEEVENT_MTA]];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [MTA trackPageViewEnd:ADDRESSPAGE_MTA];
//    [MTA trackCustomEventEnd:LYTIMEEVENT_MTA args:@[ADDRESSPAGE_TIMEEVENT_MTA]];
//}

- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取数据
-(void)getData{
    if(!_addressStr.length){
        NSArray *dataArray = [self getDataFromLocal];
        if(dataArray.count){
        NSDictionary *dataDic = ((LYCache *)dataArray.firstObject).lyCacheValue;
        self.aryList = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataDic[@"barlist"]]];
        [self.tableView reloadData];
        [self noGoodsViewWith:self.aryList];
        return;
        }
    }
    
    __weak LYHotJiuBarViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 weakSelf.tableView.mj_footer.hidden = NO;
             }
             else
             {
                 weakSelf.tableView.mj_footer.hidden = YES;
             }
         }
     }];
}
- (NSArray *)getDataFromLocal{
      return  [[LYCoreDataUtil shareInstance] getCoreData:@"LYCache" andSearchPara:@{@"lyCacheKey":[NSString stringWithFormat:@"%@%@",CACHE_HOTJIUBA,self.navigationItem.title]}];
}

//无商品时的界面
- (void)noGoodsViewWith:(NSArray *)goodsArray{
    if (!goodsArray.count) {
        [_bgView removeFromSuperview];
        [_image_place removeFromSuperview];
        [_label_place removeFromSuperview];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_menuView.frame) , SCREEN_WIDTH,  SCREEN_HEIGHT - 64 - CGRectGetHeight(_menuView.frame))];
        _bgView.backgroundColor = RGBA(0, 0, 0, 0.4);
        _bgView.alpha = 0.2;
        _bgView.tag = 300;
        [self.view addSubview:_bgView];
        
        _image_place = [[UIImageView alloc]initWithFrame:CGRectMake(107, 191,105 , 119)];
        _image_place.image =[UIImage sd_animatedGIFNamed:@"sorry"];
        _image_place.tag = 100;
        [self.view addSubview:_image_place];
        
        _label_place = [[UILabel alloc]initWithFrame:CGRectMake(76, 310, 168, 22)];
        _label_place.text = @"正在等待商家入住";
        _label_place.textColor = RGBA(29, 32, 47, 1);
        _label_place.font = [UIFont systemFontOfSize:14];
        _label_place.tag = 200;
        _label_place.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label_place];
        
        [self.view bringSubviewToFront:_menuView];
    }else{
        [_bgView removeFromSuperview];
        [_image_place removeFromSuperview];
        [_label_place removeFromSuperview];
    }
}

- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];

    hList.address = _addressStr;
    hList.subids = _subidStr;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
    hList.titleStr = self.navigationItem.title;
    
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList pageIndex:2 results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray *newbanner,NSMutableArray *bartypeslist)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [weakSelf.aryList removeAllObjects];
                 weakSelf.bannerList = bannerList.mutableCopy;
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [weakSelf.aryList addObjectsFromArray:barList];
             [weakSelf.tableView reloadData];
             [weakSelf noGoodsViewWith:weakSelf.aryList];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}

- (void)installFreshEvent
{
    __weak LYHotJiuBarViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
                             ^{
                                 weakSelf.curPageIndex = 1;
                                 [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
                                  {
                                      if (Req_Success == ermsg.state)
                                      {
                                          if (barList.count == PAGESIZE)
                                          {
                                              weakSelf.curPageIndex = 2;
                                              weakSelf.tableView.mj_footer.hidden = NO;
                                          }
                                          else
                                          {
                                              weakSelf.tableView.mj_footer.hidden = YES;
                                          }
                                          [weakSelf.tableView.mj_header endRefreshing];
                                      }
                                  }];
                             }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                if (barList.count == PAGESIZE)
                {
                    
                    weakSelf.tableView.mj_footer.hidden = NO;
                }
                else
                {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                weakSelf.curPageIndex ++;
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }];
    }];
}

#pragma mark 菜单代理
- (void)didClickHotBarMenuDropWithButton:(MenuButton *)button dropButton:(MenuButton *)dropButton{

    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOTJIUBAPAGE_MTA titleName:button.currentTitle]];
    switch (button.section) {
        case 2:
        {
            bartypeslistModel *bartypeModel = self.bartypeArray[dropButton.tag];
            _subidStr = bartypeModel.subids;
            self.navigationItem.title = dropButton.currentTitle;
           [self getData];
        }
            break;
        case 1:
        {
                _addressStr = dropButton.currentTitle;
            if (!dropButton.tag) {
               _addressStr = @"";
            }
             [self getData];
        }
            break;
        case 3:
        {
             [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"筛选" pageName:HOTJIUBAPAGE_MTA titleName:dropButton.currentTitle]];
            //1.离我最近
            //2.人均最高
            //3.人均最低
            //4.返利最高
            switch (dropButton.tag) {
                case 0:
                {
                    [ _aryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        JiuBaModel *a = (JiuBaModel *)obj1;
                        JiuBaModel *b = (JiuBaModel *)obj2;
                        NSLog(@"--->%@---->%@",a.lowest_consumption,b.lowest_consumption);
                        float aNum = [a.distance floatValue];
                        float bNum = [b.distance floatValue];
                        if (aNum > bNum) {
                            return NSOrderedDescending;
                        }
                        else if (aNum < bNum){
                            return NSOrderedAscending;
                        }
                        else {
                            return NSOrderedSame;
                        }
                    }];
                   [self.tableView reloadData];
                    [self.tableView setContentOffset:CGPointZero animated:YES];
                }
                    break;
                case 1:
                {
//                    _aryList = [[_aryList sortedArrayUsingSelector:@selector(compareJiuBaModelGao:)] mutableCopy];
//                    [self.tableView reloadData];
                    [ _aryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        JiuBaModel *a = (JiuBaModel *)obj1;
                        JiuBaModel *b = (JiuBaModel *)obj2;
                        NSLog(@"--->%@---->%@",a.lowest_consumption,b.lowest_consumption);
                        int aNum = [a.lowest_consumption intValue];
                        int bNum = [b.lowest_consumption intValue];
                        if (aNum < bNum) {
                            return NSOrderedDescending;
                        }
                        else if (aNum > bNum){
                            return NSOrderedAscending;
                        }
                        else {
                            return NSOrderedSame;
                        }
                    }];
                    [self.tableView reloadData];
                                        [self.tableView setContentOffset:CGPointZero animated:YES];
                }
                    break;
                case 2:
                {
                    [ _aryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        JiuBaModel *a = (JiuBaModel *)obj1;
                        JiuBaModel *b = (JiuBaModel *)obj2;
                        NSLog(@"--->%@---->%@",a.lowest_consumption,b.lowest_consumption);
                        int aNum = [a.lowest_consumption intValue];
                        int bNum = [b.lowest_consumption intValue];
                        if (aNum > bNum) {
                            return NSOrderedDescending;
                        }
                        else if (aNum < bNum){
                            return NSOrderedAscending;
                        }
                        else {
                            return NSOrderedSame;
                        }
                    }];
                    [self.tableView reloadData];
                    [self.tableView setContentOffset:CGPointZero animated:YES];
                }
                    break;
                case 3:
                {
                    [ _aryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        JiuBaModel *a = (JiuBaModel *)obj1;
                        JiuBaModel *b = (JiuBaModel *)obj2;
                        float aNum = [a.rebate floatValue];
                        float bNum = [b.rebate floatValue];
                        if (aNum > bNum) {
                            return NSOrderedDescending;
                        }
                        else if (aNum < bNum){
                            return NSOrderedAscending;
                        }
                        else {
                            return NSOrderedSame;
                        }
                    }];
                    [self.tableView reloadData];
                    [self.tableView setContentOffset:CGPointZero animated:YES];
                }
                    break;
                    
                default:
                    break;
                    
            }
        }
            break;
        default:
            break;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _aryList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 273;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  /*
            LYHotBarMenuTableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"LYHotBarMenuTableViewCell" forIndexPath:indexPath];
            menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [menuCell.btn_allPlace addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuCell.btn_music addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuCell.btn_aroundMe addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            return menuCell;
      */ 
            LYWineBarCell *wineCell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
            wineCell.jiuBaModel = _aryList[indexPath.section];
            wineCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return wineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *jiuBaModel = self.aryList[indexPath.section];
    BeerBarDetailViewController *detailVC = [[BeerBarDetailViewController alloc]init];
    detailVC.beerBarId = @(jiuBaModel.barid);
    [self.navigationController pushViewController:detailVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOTJIUBAPAGE_MTA titleName:jiuBaModel.barname]];
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
