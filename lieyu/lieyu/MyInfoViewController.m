//
//  MyInfoViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ZSMaintViewController.h"
#import "ZSListCell.h"
#import "TuiJianShangJiaViewController.h"
#import "MyCollectionViewController.h"
#import "LYMyOrderManageViewController.h"
#import "LYUserLoginViewController.h"
#import "MyZSManageViewController.h"
@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

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
    NSDictionary *dic=@{@"colorRGB":RGB(255, 114, 130),@"imageContent":@"hat L",@"title":@"我是专属经理",@"delInfo":@""};
    NSDictionary *dic1=@{@"colorRGB":RGB(255, 200, 101),@"imageContent":@"todos L",@"title":@"订单",@"delInfo":@"12"};
    NSDictionary *dic2=@{@"colorRGB":RGB(149, 236, 135),@"imageContent":@"icon_star2_normal",@"title":@"收藏",@"delInfo":@"8"};
    NSDictionary *dic3=@{@"colorRGB":RGB(255, 149, 90),@"imageContent":@"shoe L",@"title":@"专属经理",@"delInfo":@"8"};
    NSDictionary *dic4=@{@"colorRGB":RGB(54, 234, 213),@"imageContent":@"ShoppingCart",@"title":@"购物车",@"delInfo":@"8"};
    NSDictionary *dic5=@{@"colorRGB":RGB(64, 222, 255),@"imageContent":@"bell L",@"title":@"信息中心",@"delInfo":@"9"};
    NSDictionary *dic6=@{@"colorRGB":RGB(129, 168, 255),@"imageContent":@"crown L",@"title":@"推荐商户",@"delInfo":@""};
    [listArr addObject:dic];
    [listArr addObject:dic1];
    [listArr addObject:dic2];
    [listArr addObject:dic3];
    [listArr addObject:dic4];
    [listArr addObject:dic5];
    [listArr addObject:dic6];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 228)];
    view.backgroundColor=RGB(35, 166, 116);
    //外部圆
    cImageView=[[UIImageView alloc]initWithFrame:CGRectMake(130, 82, 60, 60)];
    [view addSubview:cImageView];
    myPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(130, 82, 60, 60)];
    //照片圆形
    myPhotoImageView.layer.masksToBounds =YES;
    
    myPhotoImageView.layer.cornerRadius =myPhotoImageView.frame.size.width/2;
    myPhotoImageView.backgroundColor=[UIColor whiteColor];
    [view addSubview:myPhotoImageView];
    namelal=[[UILabel alloc]initWithFrame:CGRectMake(0,167,320,18)];
    [namelal setTextColor:RGB(255,255,255)];
    namelal.font=[UIFont boldSystemFontOfSize:12];
    namelal.backgroundColor=[UIColor clearColor];
    namelal.text=@"Patricia Perkins";
    namelal.textAlignment=NSTextAlignmentCenter;
    [view addSubview:namelal];
    orderInfoLal=[[UILabel alloc]initWithFrame:CGRectMake(0,200,320,16)];
    [orderInfoLal setTextColor:RGB(255,255,255)];
    orderInfoLal.font=[UIFont boldSystemFontOfSize:10];
    orderInfoLal.backgroundColor=[UIColor clearColor];
    orderInfoLal.text=@"我属于你生命中小宝贝";
    orderInfoLal.textAlignment=NSTextAlignmentCenter;
    [view addSubview:orderInfoLal];
    self.tableView.tableHeaderView=view;
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews
{
    if (self.navigationController.navigationBarHidden != YES) {
        [self.navigationController setNavigationBarHidden:YES];
    }

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
    static NSString *CellIdentifier = @"ZSListCell";
    
    ZSListCell *cell = (ZSListCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ZSListCell *)[nibArray objectAtIndex:0];
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
    cell.delLal.textAlignment=NSTextAlignmentRight;
    cell.titleLbl.width=200;
    //    cell.disImageView;
    
    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    switch (indexPath.row) {
            
        case 0://我是专属经理
        {
            ZSMaintViewController *maintViewController=[[ZSMaintViewController alloc]initWithNibName:@"ZSMaintViewController" bundle:nil];
            [self.navigationController pushViewController:maintViewController animated:YES];
            break;
        }
            
        case 1:// 订单
        {
            LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
            myOrderManageViewController.title=@"我的订单";
            [self.navigationController pushViewController:myOrderManageViewController animated:YES];
            break;
        }
            
        case 2:// 收藏
        {
            MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
            maintViewController.title=@"我的收藏";
            [self.navigationController pushViewController:maintViewController animated:YES];
            break;
        }
            
        case 3:// 专属经理
        {
            MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
            myZSManageViewController.title=@"我的专属经理";
            [self.navigationController pushViewController:myZSManageViewController animated:YES];
            
            break;
        }
        case 4:// 购物车
        {
            
            
            break;
        }
        case 5:// 信息中心
        {
            
            
            break;
        }
        
        default://推荐商户
        {
            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
            tuiJianShangJiaViewController.title=@"推荐商家";
            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
            
            break;
        }
            
    }
    
    
}

#pragma mark 设置
- (IBAction)settingQct:(UIButton *)sender {
    LYUserLoginViewController *userLoginViewController=[[LYUserLoginViewController alloc]initWithNibName:@"LYUserLoginViewController" bundle:nil];
    userLoginViewController.title=@"登录";
    [self.navigationController pushViewController:userLoginViewController animated:YES];
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
