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
#import "MenuButton.h"

#define PAGESIZE 20

@interface LYHotJiuBarViewController ()<UITableViewDataSource,UITableViewDelegate,LYHotBarMenuViewDelegate>
{
    NSString *_addressStr;
    NSString *_pricedescStr;// 人均最高
    NSString *_priceascStr;//人均最低
    NSString *_rebatedescStr;//返利最高
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

    LYHotBarMenuView *menuView = [[LYHotBarMenuView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    menuView.delegate = self;
    NSArray *array1 = @[@"所有地区",@"虹口区",@"普陀区",@"闵行区",@"浦东区",@"宝山区",@"徐汇区",@"嘉定区",@"长宁区",@"松江区"];
    NSArray *array2 = _titleArray;
    NSArray *array3 = @[@"离我最近",@"人均最高",@"人均最低",@"返利最高"];
    [menuView deployWithMiddleTitle:_middleStr ItemArray:@[array1,array2,array3]];
    [self.view addSubview:menuView];
    self.curPageIndex = 1;
    _aryList = [[NSMutableArray alloc]initWithCapacity:0];
    [self getData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)getData{
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

- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    
//    NSString * mainType = nil;
//    if (self.entryType == BaseEntry_WineBar) {
//        mainType = @"酒吧";
//    }
//    else
//    {
//        mainType = @"夜总会";
//    }
    
//#if 1
   // hList.bartype = mainType;
    
   
    hList.address = _addressStr;
    hList.subids = _subidStr;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
//#endif
    
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray *newbanner,NSMutableArray *bartypeslist)
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
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}

- (void)installFreshEvent
{
    
    __weak LYHotJiuBarViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:
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

#pragma 菜单代理
- (void)didClickHotBarMenuDropWithButton:(MenuButton *)button dropButton:(MenuButton *)dropButton{

    
    switch (button.section) {
        case 2:
        {
            bartypeslistModel *bartypeModel = self.bartypeArray[dropButton.tag];
            _subidStr = bartypeModel.subids;
           [self getData];
        }
            break;
        case 1:
        {
            _addressStr = dropButton.currentTitle;
             [self getData];
        }
            break;
        case 3:
        {
            //1.离我最近
            //2.人均最高
            //3.人均最低
            //4.返利最高
            switch (dropButton.tag) {
                case 0:
                {
                    _aryList = [[_aryList sortedArrayUsingSelector:@selector(compareJiuBaModel:)] mutableCopy];
                    [self.tableView reloadData];
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                {
                    
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
    JiuBaModel *jiuBaModel = self.aryList[indexPath.row];
    BeerBarDetailViewController *detailVC = [[BeerBarDetailViewController alloc]init];
    detailVC.beerBarId = @(jiuBaModel.barid);
    [self.navigationController pushViewController:detailVC animated:YES];
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
