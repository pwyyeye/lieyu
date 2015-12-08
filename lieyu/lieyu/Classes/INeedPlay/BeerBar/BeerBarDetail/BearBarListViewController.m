//
//  BearBarListViewController.m
//  lieyu
//
//  Created by newfly on 9/26/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BearBarListViewController.h"
#import "LYWineBarCell.h"
#import "BeerBarDetailViewController.h"
#import "LYCustomSegmentControl.h"
#import "MJRefresh.h"
#import "LYToPlayRestfulBusiness.h"
#import "MReqToPlayHomeList.h"
#import "LYUserLocation.h"
#import "LYAdshowCell.h"
#import "JiuBaModel.h"
#define PAGESIZE 20

@interface BearBarListViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UIView * topView;
@property(nonatomic,strong) NSMutableArray *aryList;
@property(nonatomic,strong) NSMutableArray *bannerList;
@property(nonatomic,assign) NSInteger curPageIndex;
@property(nonatomic,strong) LYCustomSegmentControl *segmentCtrl;

@end

@implementation BearBarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    self.aryList = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource =self ;
    self.curPageIndex = 1;
    [self setupViewStyles];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    __weak BearBarListViewController * weakSelf = self;
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
//             [weakSelf.tableView.header endRefreshing];
         }
     }];

}
- (void)setwineBarTop
{
    self.segmentCtrl =
    [[LYCustomSegmentControl alloc] initWithTitleItems:@[@"闹吧",@"清吧",@"演艺吧",@"音乐吧"] frame:_topView.frame];
    
    [self.topView addSubview:_segmentCtrl];
    self.segmentCtrl.selectedColor = [UIColor whiteColor];
    self.segmentCtrl.backgroundColor = UIColorFromRGB(0xe5fff5);
    self.segmentCtrl.titleColor = UIColorFromRGB(0x666666);
    self.segmentCtrl.font = [UIFont systemFontOfSize:13];
    self.segmentCtrl.selectedIndex = 0;
    
    __weak __typeof(self) weakSelf = self;
    [self.segmentCtrl setSelectedItem:^(NSInteger index)
     {
         weakSelf.curPageIndex = 1;
         [weakSelf loadItemList:nil];
     }];

}

- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    hList.city = _cityStr;
    
    NSString * mainType = nil;
    if (self.entryType == BaseEntry_WineBar) {
        mainType = @"酒吧";
    }
    else
    {
        mainType = @"夜总会";
    }
    
#if 1
    hList.bartype = mainType;
    hList.subtype = _segmentCtrl.selectedItemTitle;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
#endif
    
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


- (void)setYzhTop
{
//    CGFloat w = _topView.frame.size.width;
    self.segmentCtrl =
    [[LYCustomSegmentControl alloc] initWithTitleItems:@[@"商务会所",@"KTV"] frame:_topView.frame];
    
    [self.topView addSubview:_segmentCtrl];
    self.segmentCtrl.selectedColor = [UIColor whiteColor];
    self.segmentCtrl.backgroundColor = UIColorFromRGB(0xe5fff5);
    self.segmentCtrl.titleColor = UIColorFromRGB(0x666666);
    self.segmentCtrl.font = [UIFont systemFontOfSize:13];
    self.segmentCtrl.selectedIndex = 0;
    
    __weak __typeof(self) weakSelf = self;
    [self.segmentCtrl setSelectedItem:^(NSInteger index)
     {
         [weakSelf loadItemList:nil];
     }];

}

- (void)installFreshEvent
{
    
    __weak BearBarListViewController * weakSelf = self;
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
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
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
    
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
}

- (void)setupViewStyles
{
    UINib * adCellNib = [UINib nibWithNibName:@"LYAdshowCell" bundle:nil];
    [self.tableView registerNib:adCellNib forCellReuseIdentifier:@"LYAdshowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
    
    if (self.entryType == BaseEntry_WineBar)
    {
        self.title = @"酒吧";
        [self setwineBarTop];
    }
    
    if (self.entryType == BaseEntry_Yzh)
    {
        self.title = @"夜总会";
        [self setYzhTop];
    }
    
    [self installFreshEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topViewCell"] ;
            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            
            for (NSString *iconStr in _bannerList) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 128)
                                                                  scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
            [cell addSubview:scroller];
            
        }
            break;

        default:
        {
            LYWineBarCell * barCell = [tableView dequeueReusableCellWithIdentifier:@"LYWineBarCell" forIndexPath:indexPath];
            
            cell = barCell;
            if ([_aryList count] >=1) {
                //[barCell configureCell:[_aryList objectAtIndex:indexPath.row - 1]];
            }
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
            h = 128;
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
    if (indexPath.row >= 1) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        
        JiuBaModel *model=[_aryList objectAtIndex:indexPath.row - 1];
        controller.beerBarId = @(model.barid);
        [self.navigationController pushViewController:controller animated:YES];
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

@end




