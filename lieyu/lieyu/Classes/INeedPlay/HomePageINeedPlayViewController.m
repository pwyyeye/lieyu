//
//  HomePageINeedPlayViewController.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYAdshowCell.h"
#import "LYWineBarCell.h"
#import "HomePageINeedPlayViewController.h"
#import "MJRefresh.h"
#import "BeerBarDetailViewController.h"
#import "BearBarListViewController.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "JiuBaModel.h"
#import "LYPlayTogetherMainViewController.h"
#import "LYHomeSearchViewController.h"
#import "DWTaoCanXQViewController.h"
#import "MyCollectionViewController.h"
#import "LYAmusementClassCell.h"
#import "LYHotRecommandCell.h"
#import "LYCityChooseViewController.h"
#import "LYHomeSearcherViewController.h"
#import "LYHotJiuBarViewController.h"
#import "LYCloseMeViewController.h"
#import "bartypeslistModel.h"

#define PAGESIZE 20
@interface HomePageINeedPlayViewController ()
<
UITableViewDataSource,UITableViewDelegate,
    EScrollerViewDelegate,
    UITextFieldDelegate
>//,SearchDelegate

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,strong) IBOutlet UIView * topView;
@property(nonatomic,weak) IBOutlet UIButton * myFllowButton;
@property(nonatomic,weak) IBOutlet UITableView * tableView;
@property(nonatomic,weak) IBOutlet UITextField * searchTextField;
@property (nonatomic,strong) NSArray *bartypeslistArray;
@property(nonatomic,assign) NSInteger curPageIndex;
@property (nonatomic,strong) NSArray *hotJiuBarTitle;
@end

@implementation HomePageINeedPlayViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
//    self.navigationController.delegate=self;
    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.height=431;
    }
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:@"cityChange" object:nil];
     self.curPageIndex = 1;
     self.aryList=[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
   [self initialize];
   [self setupViewStyles];
    
//    // Do any additional setup after loading the view from its nib.
//    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYHotRecommandCell" bundle:nil]  forCellReuseIdentifier:@"hotCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"LYAmusementClassCell" bundle:nil] forCellReuseIdentifier:@"LYAmusementClassCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _hotJiuBarTitle = @[@"激情夜店",@"文艺清吧",@"音乐清吧",@"ktv"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cityChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rc = _topView.frame;
    rc.origin.x = 0;
    rc.origin.y = -20;
    _topView.frame = rc;
    [self.navigationController.navigationBar addSubview:_topView];
    //ios 7.0适配
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0,  0,  0,  0);
    }
    [self.navigationController.navigationBar bringSubviewToFront:_topView];
    [self getData];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //ios 7.0适配
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0,  0,  0,  0);
    }
    
    
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_topView removeFromSuperview];
}

- (IBAction)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
}
- (IBAction)searchClick:(UIButton *)sender {
    LYHomeSearcherViewController *homeSearchVC = [[LYHomeSearcherViewController alloc]init];
    [self.navigationController pushViewController:homeSearchVC animated:YES];
}

-(void)getData{
    __weak HomePageINeedPlayViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
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
             //             [weakSelf.tableView.header endRefreshing];
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
    if (![MyUtil isEmptyString:_cityBtn.titleLabel.text]) {
       hList.city = _cityBtn.titleLabel.text;
    }
//    hList.city = [LYUserLocation instance].city;
//    hList.bartype = @"酒吧/夜总会";
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList,NSArray *newbanner,NSMutableArray *bartypeslist) {
        if (ermsg.state == Req_Success)
        {
            if (weakSelf.curPageIndex == 1) {
                [weakSelf.aryList removeAllObjects];
                //                [weakSelf.bannerList removeAllObjects];
                weakSelf.bannerList = bannerList.mutableCopy;
                weakSelf.newbannerList = newbanner.mutableCopy;
                weakSelf.bartypeslistArray = bartypeslist;
            }
            [self.aryList addObjectsFromArray:barList.mutableCopy] ;
            [self.tableView reloadData];
        }
        block !=nil? block(ermsg,bannerList,barList):nil;
    }];
}



- (void)initialize
{
    
}

- (void)setupViewStyles
{
   [self setupToViewStyles];
    /*
    UINib * adCellNib = [UINib nibWithNibName:@"LYAdshowCell" bundle:nil];
    [self.tableView registerNib:adCellNib forCellReuseIdentifier:@"LYAdshowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
   */
    [self installFreshEvent];

}
- (void)installFreshEvent
{
    __weak HomePageINeedPlayViewController * weakSelf = self;
//    __weak UITableView *tableView = self.tableView;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
                             ^{
                                 weakSelf.curPageIndex = 1;
                                 [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
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
        [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
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

- (void)setupToViewStyles
{

}

//---TODO: add action

- (IBAction)myFllowClick:(id)sender
{
    MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
    maintViewController.title=@"我的收藏";
    [self.navigationController pushViewController:maintViewController animated:YES];
}

- (IBAction)beerBarClick:(id)sender
{
    BearBarListViewController * bearBarController  = [[BearBarListViewController alloc ] initWithNibName:@"BearBarListViewController" bundle:nil];
    bearBarController.entryType = BaseEntry_WineBar;
    bearBarController.cityStr=_cityBtn.titleLabel.text;
    [self.navigationController pushViewController:bearBarController animated:YES];
}


- (IBAction)yzhClick:(id)sender
{
    BearBarListViewController * bearBarController  = [[BearBarListViewController alloc ] initWithNibName:@"BearBarListViewController" bundle:nil];
    bearBarController.entryType = BaseEntry_Yzh;
    [self.navigationController pushViewController:bearBarController animated:YES];
}

#pragma mark 选择区域
-(void)chooseButton:(UIButton *)sender andSelected:(BOOL)isSelected{
    if (isSelected) {
        _cityBtn.titleLabel.text=sender.titleLabel.text;
        [_cityBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        [self getData];
        [_alertView removeFromSuperview];
        _alertView=nil;
    }
}

- (IBAction)aroundMeClick:(id)sender {
    LYCloseMeViewController *closeMeVC = [[LYCloseMeViewController alloc]init];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:NO];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
//    NSArray
//    [self.aryList sortUsingDescriptors:sortDescriptors];
    

    
    closeMeVC.beerBarArray = self.aryList;
    [self.navigationController pushViewController:closeMeVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSoucre&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.aryList.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section || section == 3) {
        return 0.00001;
    }
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0.0001;
    }
    return 4;
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            for (NSString *iconStr in self.bannerList) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 122)
                                                                  scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
            scroller.delegate=self;
            [cell addSubview:scroller];
            
        }
            break;
        case 1:
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
        case 2:
        {
            
            LYHotRecommandCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
        }
            break;
        
        default:
        {
            LYWineBarCell *wineCell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
            wineCell.selectionStyle = UITableViewCellSelectionStyleNone;
            JiuBaModel *jiuBaModel = self.aryList[indexPath.section - 3];
            wineCell.jiuBaModel = jiuBaModel;
            return wineCell;
        }
            break;
    }
  return cell;
}

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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h = 122.5 ;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 211  ;
        }
            break;
        case 2:
        {
           
            h = 45;
        }
            break;
        default:
        {
            h = 273.5;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section >= 3) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    
        JiuBaModel * model = [_aryList objectAtIndex:indexPath.section -3];
        controller.beerBarId = @(model.barid);
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
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
        [self.navigationController pushViewController:controller animated:YES];
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
    }else if (ad_type.intValue ==4){
//    4：拼客
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        LYPlayTogetherMainViewController *playTogetherMainViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
        playTogetherMainViewController.title=@"我要拼客";
        playTogetherMainViewController.smid=linkid.intValue;
        [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
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
