//
//  HomePageINeedPlayViewController.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYAdshowCell.h"
#import "LYWineBarInfoCell.h"
#import "HomePageINeedPlayViewController.h"
#import "MJRefresh.h"
#import "BeerBarDetailViewController.h"
#import "BearBarListViewController.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "JiuBaModel.h"
#define PAGESIZE 20
@interface HomePageINeedPlayViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,

    UITextFieldDelegate
>

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,strong) IBOutlet UIView * topView;
@property(nonatomic,weak) IBOutlet UIButton * myFllowButton;
@property(nonatomic,weak) IBOutlet UITableView * tableView;
@property(nonatomic,weak) IBOutlet UITextField * searchTextField;
//@property(nonatomic,weak) IBOutlet UITabBarItem * tabBarItem;
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation HomePageINeedPlayViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.curPageIndex = 1;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self initialize];
    [self setupViewStyles];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    CGRect rc = _topView.frame;
    rc.origin.x = 0;
    rc.origin.y = 0;
    _topView.frame = rc;
    [self.navigationController.navigationBar addSubview:_topView];
//    [self loadHomeList];
    [self getData];
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
                 weakSelf.tableView.footer.hidden = NO;
             }
             else
             {
                 weakSelf.tableView.footer.hidden = YES;
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
    hList.city = [LYUserLocation instance].city;
    hList.bartype = @"酒吧/夜总会";
//    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(20);
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
        if (ermsg.state == Req_Success)
        {
            if (weakSelf.curPageIndex == 1) {
                [weakSelf.aryList removeAllObjects];
                //                [weakSelf.bannerList removeAllObjects];
            }
            self.aryList = barList.mutableCopy;
            self.bannerList = bannerList.mutableCopy;
            [self.tableView reloadData];
        }
        block !=nil? block(ermsg,bannerList,barList):nil;
    }];
}

- (void)viewWillLayoutSubviews
{
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_topView removeFromSuperview];
}

- (void)initialize
{
    
}

- (void)setupViewStyles
{
    [self setupToViewStyles];
    UINib * adCellNib = [UINib nibWithNibName:@"LYAdshowCell" bundle:nil];
    [self.tableView registerNib:adCellNib forCellReuseIdentifier:@"LYAdshowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
   
    [self installFreshEvent];

}
- (void)installFreshEvent
{
    
    __weak HomePageINeedPlayViewController * weakSelf = self;
//    __weak UITableView *tableView = self.tableView;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:
                             ^{
                                 weakSelf.curPageIndex = 1;
                                 [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
                                  {
                                      if (Req_Success == ermsg.state)
                                      {
                                          if (barList.count == PAGESIZE)
                                          {
                                              weakSelf.curPageIndex = 2;
                                              weakSelf.tableView.footer.hidden = NO;
                                          }
                                          else
                                          {
                                              weakSelf.tableView.footer.hidden = YES;
                                          }
                                          [weakSelf.tableView.header endRefreshing];
                                      }
                                  }];
                             }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadHomeList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                weakSelf.curPageIndex ++;
                [weakSelf.tableView.footer endRefreshing];
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

}

- (IBAction)beerBarClick:(id)sender
{
    BearBarListViewController * bearBarController  = [[BearBarListViewController alloc ] initWithNibName:@"BearBarListViewController" bundle:nil];
    bearBarController.entryType = BaseEntry_WineBar;
    [self.navigationController pushViewController:bearBarController animated:YES];
}


- (IBAction)yzhClick:(id)sender
{
    BearBarListViewController * bearBarController  = [[BearBarListViewController alloc ] initWithNibName:@"BearBarListViewController" bundle:nil];
    bearBarController.entryType = BaseEntry_Yzh;
    [self.navigationController pushViewController:bearBarController animated:YES];
}

- (IBAction)selectAreaClick:(id)sender
{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryList.count+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topViewCell"] ;            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            
            for (NSString *iconStr in self.bannerList) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 122)
                                                                  scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
            [cell addSubview:scroller];
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"spaceEntryCell" forIndexPath:indexPath];
        }
            break;
        case 2:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"jiujiBeerBarCell" forIndexPath:indexPath];
            cell.backgroundColor = RGBA(250, 250, 250, 1.0);
        }
            break;
        default:
        {
            LYWineBarInfoCell * barCell = [tableView dequeueReusableCellWithIdentifier:@"LYWineBarInfoCell" forIndexPath:indexPath];
            
            cell = barCell;
            [barCell configureCell:[_aryList objectAtIndex:indexPath.row-3]];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 103.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.row) {
        case 0://广告
        {
            h = 122;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 67;
        }
            break;
        case 2:
        {
            h = 41;
        }
            break;
        default:
        {
            h = 104;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 3) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    
        JiuBaModel * model = [_aryList objectAtIndex:indexPath.row -3];
        controller.beerBarId = @(model.barid);
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{


}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
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
