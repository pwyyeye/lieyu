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
#import "HuoDongViewController.h"
#define PAGESIZE 20
@interface HomePageINeedPlayViewController ()
<
UITableViewDataSource,UITableViewDelegate,
    EScrollerViewDelegate,
    UITextFieldDelegate
>{
    UIButton *_cityChooseBtn;
    UIButton *_searchBtn;
    UIImageView *_titleImageView;
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,weak) IBOutlet UITableView * tableView;
@property (nonatomic,strong) NSArray *bartypeslistArray;
@property(nonatomic,assign) NSInteger curPageIndex;
@property (nonatomic,strong) NSArray *hotJiuBarTitle;
@end

@implementation HomePageINeedPlayViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.bounds=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
    }
    
   // _tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-104);
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
     self.curPageIndex = 1;
     self.aryList=[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
   [self initialize];
   [self setupViewStyles];
    
    
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
    [self getData];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    _cityChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(9.5, 12, 54, 20)];
    [_cityChooseBtn setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [_cityChooseBtn setTitle:@"上海" forState:UIControlStateNormal];
    [_cityChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -8)];
    _cityChooseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cityChooseBtn addTarget:self action:@selector(cityChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_cityChooseBtn];
    
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(288, 12, 24, 24)];
    [_searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_searchBtn];
    
    _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(134.5, 9.5, 50.0, 24.6)];
    _titleImageView.image = [UIImage imageNamed:@"猎娱"];
    [self.navigationController.navigationBar addSubview:_titleImageView];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNavButtonAndImageView];
}

- (void)removeNavButtonAndImageView{
    [_titleImageView removeFromSuperview];
    [_searchBtn removeFromSuperview];
    [_cityChooseBtn removeFromSuperview];
}

- (void)cityChangeClick:(UIButton *)sender {
    LYCityChooseViewController *cityChooseVC = [[LYCityChooseViewController alloc]init];
    [self.navigationController pushViewController:cityChooseVC animated:YES];
}
- (void)searchClick:(UIButton *)sender {
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
            [weakSelf.aryList addObjectsFromArray:barList.mutableCopy] ;
            [weakSelf.tableView reloadData];
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
    [self installFreshEvent];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYHotRecommandCell" bundle:nil]  forCellReuseIdentifier:@"hotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYAmusementClassCell" bundle:nil] forCellReuseIdentifier:@"LYAmusementClassCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark 离我最近
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
    if (self.aryList.count) {
        return self.aryList.count + 3;
    }else{
        return 0;
    }
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
        case 0://广告
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            [[cell viewWithTag:1999] removeFromSuperview];
            
            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            for (NSString *iconStr in self.bannerList) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 122)
                                                                  scrolArray:[NSArray arrayWithArray:[bigArr copy]] needTitile:YES];
            scroller.delegate=self;
            scroller.tag=1999;
            [cell addSubview:scroller];
        }
            break;
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

//跳转热门酒吧界面
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
    }else if(ad_type.intValue ==2){
        //有活动内容才跳转
        if ([dic objectForKey:@"content"]) {
            HuoDongViewController *huodong=[[HuoDongViewController alloc] init];
            huodong.content=[dic objectForKey:@"content"];
            [self.navigationController pushViewController:huodong animated:YES];
        }
        
        
        
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
