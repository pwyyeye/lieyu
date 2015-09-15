//
//  ZSMaintViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSMaintViewController.h"
#import "FunctionListCell.h"
#import "ZSSeatControlView.h"
#import "ZSOrderViewController.h"
#import "ZSMyClientViewController.h"
#import "ZSMyShopManageViewController.h"
#import "ZSNoticeCenterViewController.h"
@interface ZSMaintViewController ()

@end

@implementation ZSMaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArr =[[NSMutableArray alloc]init];
//    self.automaticallyAdjustsScrollViewInsets=0;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getDataForShowList];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 初始化数据
-(void)getDataForShowList{
    [listArr removeAllObjects];
    NSDictionary *dic=@{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""};
    NSDictionary *dic1=@{@"colorRGB":RGB(136, 223, 121),@"imageContent":@"Fill20179",@"title":@"通知中心",@"delInfo":@"您有客户留言请及时查收"};
    NSDictionary *dic2=@{@"colorRGB":RGB(254, 147, 87),@"imageContent":@"Fill20219",@"title":@"订单管理",@"delInfo":@"您有订单要确认请及时确定"};
    NSDictionary *dic3=@{@"colorRGB":RGB(65, 241, 221),@"imageContent":@"Fill20176",@"title":@"我的客户",@"delInfo":@""};
    NSDictionary *dic4=@{@"colorRGB":RGB(84, 225, 255),@"imageContent":@"Fill2097",@"title":@"商铺管理",@"delInfo":@""};
    [listArr addObject:dic];
    [listArr addObject:dic1];
    [listArr addObject:dic2];
    [listArr addObject:dic3];
    [listArr addObject:dic4];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 262)];
    view.backgroundColor=RGB(35, 166, 116);
    //外部圆
    cImageView=[[UIImageView alloc]initWithFrame:CGRectMake(108, 79, 104, 104)];
    [view addSubview:cImageView];
    myPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(131, 102, 58, 58)];
    //照片圆形
    myPhotoImageView.layer.masksToBounds =YES;
    
    myPhotoImageView.layer.cornerRadius =myPhotoImageView.frame.size.width/2;
    myPhotoImageView.backgroundColor=[UIColor whiteColor];
    [view addSubview:myPhotoImageView];
    namelal=[[UILabel alloc]initWithFrame:CGRectMake(77,196,166,21)];
    [namelal setTextColor:RGB(255,255,255)];
    namelal.font=[UIFont boldSystemFontOfSize:14];
    namelal.backgroundColor=[UIColor clearColor];
    namelal.text=@"我是VIP专属经理";
    namelal.textAlignment=NSTextAlignmentLeft;
    [view addSubview:namelal];
    orderInfoLal=[[UILabel alloc]initWithFrame:CGRectMake(33,234,266,18)];
    [orderInfoLal setTextColor:RGB(255,255,255)];
    orderInfoLal.font=[UIFont boldSystemFontOfSize:12];
    orderInfoLal.backgroundColor=[UIColor clearColor];
    orderInfoLal.text=@"您有30个订单要处理，请即时处理！";
    orderInfoLal.textAlignment=NSTextAlignmentLeft;
    [view addSubview:orderInfoLal];
    self.tableView.tableHeaderView=view;
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    //    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}
#pragma mark tableview代理方法
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FunctionListCell";
    
    FunctionListCell *cell = (FunctionListCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FunctionListCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    NSDictionary *dic=[listArr objectAtIndex:indexPath.row];
    UIColor *bColor=[dic objectForKey:@"colorRGB"];
    UIImage *imge=[UIImage imageNamed:[dic objectForKey:@"imageContent"]];
    NSString *title=[dic objectForKey:@"title"];
    NSString *delInfo=[dic objectForKey:@"delInfo"];
//    @{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""}
    cell.backImageView.backgroundColor=bColor;
    cell.CoutentImageView.image=imge;
    cell.titleLbl.text=title;
    cell.delLal.text=delInfo;
//    cell.disImageView;
    
    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 81;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    switch (indexPath.row) {
            
        case 0://卡座
        {
            ZSSeatControlView *seatControlView=[[ZSSeatControlView alloc]initWithNibName:@"ZSSeatControlView" bundle:nil];
            [self.navigationController pushViewController:seatControlView animated:YES];
            break;
        }
            
        case 1:// 通知中心
        {
            ZSNoticeCenterViewController *noticeViewController=[[ZSNoticeCenterViewController alloc]initWithNibName:@"ZSNoticeCenterViewController" bundle:nil];
            [self.navigationController pushViewController:noticeViewController animated:YES];
            break;
        }
            
        case 2:// 订单管理
        {
            ZSOrderViewController *orderManageViewController=[[ZSOrderViewController alloc]initWithNibName:@"ZSOrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderManageViewController animated:YES];
            break;
        }
            
        case 3:// 我的客户
        {
            ZSMyClientViewController *myClientViewController=[[ZSMyClientViewController alloc]initWithNibName:@"ZSMyClientViewController" bundle:nil];
            
            [self.navigationController pushViewController:myClientViewController animated:YES];
            break;
        }
            
        default:
        {
            ZSMyShopManageViewController *myShopManageViewController=[[ZSMyShopManageViewController alloc]initWithNibName:@"ZSMyShopManageViewController" bundle:nil];
            [self.navigationController pushViewController:myShopManageViewController animated:YES];
            break;
        }
        
    }
    
    
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
- (IBAction)backAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
