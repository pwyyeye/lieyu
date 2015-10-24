//
//  BeerBarDetailViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailViewController.h"
#import "MacroDefinition.h"
#import "BeerBarDetailCell.h"
#import "PacketBarCell.h"
#import "LYShareSnsView.h"
#import "LYAdshowCell.h"
#import "LYColors.h"
#import "LYToPlayRestfulBusiness.h"
#import "BeerBarOrYzhDetailModel.h"
#import "RecommendPackageModel.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "CHshowDetailListViewController.h"
@interface BeerBarDetailViewController ()

@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property(nonatomic,strong)IBOutlet BeerBarDetailCell *barDetailCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *orderTotalCell;

@property(nonatomic,weak)IBOutlet UIView *bottomBarView;
@property(nonatomic,assign)CGFloat dyBarDetailH;

@property(nonatomic,strong) BeerBarOrYzhDetailModel *beerBarDetail;

@end

@implementation BeerBarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewStyles];
    [self loadBarDetail];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadBarDetail
{
    __weak __typeof(self ) weakSelf = self;
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    [bus getBearBarOrYzhDetail:_beerBarId results:^(LYErrorMessage *erMsg, BeerBarOrYzhDetailModel *detailItem)
    {
        if (erMsg.state == Req_Success) {
            weakSelf.beerBarDetail = detailItem;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViewStyles
{    
    [_tableView registerNib:[UINib nibWithNibName:@"PacketBarCell" bundle:nil] forCellReuseIdentifier:@"PacketBarCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BusinessPublicNoteCell" bundle:nil] forCellReuseIdentifier:@"BusinessPublicNoteCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LYAdshowCell" bundle:nil] forCellReuseIdentifier:@"LYAdshowCell"];

    LYShareSnsView * shareView = [LYShareSnsView loadFromNib];
    [self.view addSubview:shareView];
    CGPoint center = self.view.center;
    center.y = self.view.frame.size.height - 69-64;
    shareView.center = center;
    
    self.bottomBarView.backgroundColor = [LYColors tabbarBgColor];
    _dyBarDetailH = [BeerBarDetailCell adjustCellHeight:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [[_beerBarDetail recommend_package] count]+1;
            break;
        case 2:
            return 1;
        
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0) {
                            cell = [tableView dequeueReusableCellWithIdentifier:@"LYAdshowCell" forIndexPath:indexPath];
                LYAdshowCell * adCell = (LYAdshowCell *)cell;
                adCell.frame = CGRectMake(0, 0, CGRectGetWidth(adCell.bounds), 264);
                _beerBarDetail.banners = @[@"http://img4.imgtn.bdimg.com/it/u=1083196650,946960492&fm=15&gp=0.jpg"];
                [adCell setBannerUrlList:_beerBarDetail.banners];
            }
            else
            {
                cell = _barDetailCell;
                UILabel * labOrdNum = (UILabel *)[cell viewWithTag:6];
                labOrdNum.text = _beerBarDetail.today_sm_buynum;
            }
            [_barDetailCell configureCell:_beerBarDetail];

        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell= _orderTotalCell;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PacketBarCell" forIndexPath:indexPath];
                PacketBarCell * tCell = (PacketBarCell *)cell;
                {
                    RecommendPackageModel * model = nil;
                    model = indexPath.row-1 < _beerBarDetail.recommend_package.count ?[_beerBarDetail.recommend_package objectAtIndex:indexPath.row-1]:nil;
                    [tCell configureCell:model];
                }
                
            }
        }
            break;
        case 2:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessPublicNoteCell" forIndexPath:indexPath];
        }
            break;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [LYColors commonBgColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h =  indexPath.row == 0? 264:_dyBarDetailH;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h =  indexPath.row == 0? 40:105;
        }
            break;
        case 2:
        {
            h = 155;
        }
            break;
        default:
        {
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)dealloc
{
    NSLog(@"dealoc bardetail viewcontroller");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dianweiAct:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=17;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHshowDetailListViewController *showDetailListViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHshowDetailListViewController"];
    showDetailListViewController.title=@"吃喝专场";
    showDetailListViewController.barid=1;
    showDetailListViewController.barName=@"颜色酒吧";
    [self.navigationController pushViewController:showDetailListViewController animated:YES];
}
@end
