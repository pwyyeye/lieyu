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
#import "DWTaoCanXQViewController.h"
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
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
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

//    LYShareSnsView * shareView = [LYShareSnsView loadFromNib];
//    [self.view addSubview:shareView];
//    CGPoint center = self.view.center;
//    center.y = self.view.frame.size.height - 69-64;
//    shareView.center = center;
    
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
            return [[_beerBarDetail recommend_package] count];
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
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topViewCell"] ;
                NSMutableArray *bigArr=[[NSMutableArray alloc]init];
                
                for (NSString *iconStr in _beerBarDetail.banners) {
                    NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                    [dicTemp setObject:iconStr forKey:@"ititle"];
                    [dicTemp setObject:@"" forKey:@"mainHeading"];
                    [bigArr addObject:dicTemp];
                }
                
                EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 242)
                                                       scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
                [cell addSubview:scroller];
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
           
                cell = [tableView dequeueReusableCellWithIdentifier:@"PacketBarCell" forIndexPath:indexPath];
                PacketBarCell * tCell = (PacketBarCell *)cell;
                {
                    RecommendPackageModel * model = nil;
                    model = indexPath.row < _beerBarDetail.recommend_package.count ?[_beerBarDetail.recommend_package objectAtIndex:indexPath.row]:nil;
                    [tCell configureCell:model];
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 87.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            
        }
            break;
        default:
        {
            
            NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
            
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor whiteColor];
                UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-20, 25)];
                [lal1 setTag:1];
                lal1.textAlignment=NSTextAlignmentLeft;
                lal1.font=[UIFont boldSystemFontOfSize:12];
                lal1.backgroundColor=[UIColor clearColor];
                lal1.textColor= RGB(128, 128, 128);
                lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
                lal1.lineBreakMode=UILineBreakModeWordWrap;
                [cell.contentView addSubview:lal1];
                
            }
            
            
            UILabel *lal = (UILabel*)[cell viewWithTag:1];
            NSString *title;
            if(_beerBarDetail.announcement){
               title=[NSString stringWithFormat:@"%@：\n     %@",_beerBarDetail.announcement.title,_beerBarDetail.announcement.content];
            }else{
                title=@"暂无公告";
            }
            
            
            //高度固定不折行，根据字的多少计算label的宽度
            
            CGSize size = [title sizeWithFont:lal.font
                            constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
            //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
            //根据计算结果重新设置UILabel的尺寸
            lal.height=size.height;
            lal.text=title;
            CGRect cellFrame = [cell frame];
            cellFrame.origin=CGPointMake(0, 0);
            cellFrame.size.width=SCREEN_WIDTH;
            cellFrame.size.height=lal.size.height+20;
            
            [cell setFrame:cellFrame];
            
            
            
            
            
        
            break;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 34;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return [[UIView alloc] initWithFrame:CGRectZero];
        
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        if(section==1){
            label.text=@"今日热门订座套餐";
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(215, 11, 60, 12)];
            label1.font=[UIFont systemFontOfSize:12];
            label1.textColor=RGB(51, 51, 51);
            label1.text=@"订单数量：";
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(215+60, 11, 80, 12)];
            label2.font=[UIFont systemFontOfSize:12];
            label2.textColor=RGB(254, 96, 96);
            label2.text=[NSString stringWithFormat:@"%ld",_beerBarDetail.recommend_package.count];
            [view addSubview:label1];
            [view addSubview:label2];
        }else{
            label.text=@"商家公告";
        }
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        return view;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h =  indexPath.row == 0? 242:_dyBarDetailH;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h =  88;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            h=cell.frame.size.height;
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
    if(indexPath.section==1){
        
        RecommendPackageModel * model = nil;
        model = indexPath.row < _beerBarDetail.recommend_package.count ?[_beerBarDetail.recommend_package objectAtIndex:indexPath.row]:nil;
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
        taoCanXQViewController.title=@"套餐详情";
        taoCanXQViewController.smid=model.smid.intValue;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        taoCanXQViewController.dateStr=[dateFormatter stringFromDate:[NSDate new]];
        [self.navigationController pushViewController:taoCanXQViewController animated:YES];
    }
    
    
    
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
    woYaoDinWeiMainViewController.barid=_beerBarDetail.barid.intValue;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHshowDetailListViewController *showDetailListViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHshowDetailListViewController"];
    showDetailListViewController.title=@"吃喝专场";
    showDetailListViewController.barid=_beerBarDetail.barid.intValue;
    showDetailListViewController.barName=_beerBarDetail.barname;
    [self.navigationController pushViewController:showDetailListViewController animated:YES];
}
@end
