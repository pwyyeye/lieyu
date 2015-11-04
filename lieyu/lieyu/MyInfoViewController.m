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
#import "UserModel.h"
#import "TuiJianShangJiaViewController.h"
#import "MyCollectionViewController.h"
#import "LYMyOrderManageViewController.h"
#import "Setting.h"
#import "MyZSManageViewController.h"
#import "LYCarListViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MyMessageListViewController.h"
@interface MyInfoViewController ()
{
    NSString *userType;
}
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userType=@"";
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.height=431;
    }
//    _tableView.height=431;
    listArr =[[NSMutableArray alloc]init];
    //    self.automaticallyAdjustsScrollViewInsets=0;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getDataForShowList];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden != YES) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [self getDataForShowList];
}
#pragma mark 初始化数据
-(void)getDataForShowList{
    [listArr removeAllObjects];
    //"usertype":"1"//用户类型1是普通用户，2是VIP专属经理
//    "applyStatus":0,//是否申请专属经理 1正在审核，2审核完成，3审核不通过
    if(self.userModel){
        NSString *usertype=self.userModel.usertype;
        int applyStatus=self.userModel.applyStatus;
        if([usertype isEqualToString:@"2"]){
            NSDictionary *dic=@{@"colorRGB":RGB(255, 114, 130),@"imageContent":@"hat L",@"title":@"我是专属经理",@"delInfo":@""};
            [listArr addObject:dic];
            userType=@"2";
        }else{
            if(applyStatus==1){
                NSDictionary *dic=@{@"colorRGB":RGB(255, 114, 130),@"imageContent":@"hat L",@"title":@"我是专属经理",@"delInfo":@"审核中"};
                [listArr addObject:dic];
                userType=@"1";
            }
        }
    }
    
    
    NSDictionary *dic1=@{@"colorRGB":RGB(255, 200, 101),@"imageContent":@"todos L",@"title":@"订单",@"delInfo":@""};
    NSDictionary *dic2=@{@"colorRGB":RGB(149, 236, 135),@"imageContent":@"icon_star2_normal",@"title":@"收藏",@"delInfo":@""};
    NSDictionary *dic3=@{@"colorRGB":RGB(255, 149, 90),@"imageContent":@"shoe L",@"title":@"专属经理",@"delInfo":@""};
    NSDictionary *dic4=@{@"colorRGB":RGB(54, 234, 213),@"imageContent":@"ShoppingCart",@"title":@"购物车",@"delInfo":@""};
    NSDictionary *dic5=@{@"colorRGB":RGB(64, 222, 255),@"imageContent":@"bell L",@"title":@"信息中心",@"delInfo":@""};
//    NSDictionary *dic6=@{@"colorRGB":RGB(129, 168, 255),@"imageContent":@"crown L",@"title":@"推荐商户",@"delInfo":@""};
    
    [listArr addObject:dic1];
    [listArr addObject:dic2];
    [listArr addObject:dic3];
    [listArr addObject:dic4];
    [listArr addObject:dic5];
//    [listArr addObject:dic6];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 228)];
    view.backgroundColor=RGB(35, 166, 116);
    //外部圆
    cImageView=[[UIImageView alloc]initWithFrame:CGRectMake(116, 68, 88, 88)];
    [cImageView setImage:[UIImage imageNamed:@"yuanhuan"]];
    [view addSubview:cImageView];
    myPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(130, 81.7, 60, 60)];
    //照片圆形
    myPhotoImageView.layer.masksToBounds =YES;
    
    myPhotoImageView.layer.cornerRadius =myPhotoImageView.frame.size.width/2;
    myPhotoImageView.backgroundColor=[UIColor whiteColor];
    [myPhotoImageView setImageWithURL:[NSURL URLWithString:self.userModel.avatar_img]];
    [view addSubview:myPhotoImageView];
    namelal=[[UILabel alloc]initWithFrame:CGRectMake(0,167,320,18)];
    [namelal setTextColor:RGB(255,255,255)];
    namelal.font=[UIFont boldSystemFontOfSize:12];
    namelal.backgroundColor=[UIColor clearColor];
    namelal.text=self.userModel.usernick;
    namelal.textAlignment=NSTextAlignmentCenter;
    [view addSubview:namelal];
    orderInfoLal=[[UILabel alloc]initWithFrame:CGRectMake(0,200,320,16)];
    [orderInfoLal setTextColor:RGB(255,255,255)];
    orderInfoLal.font=[UIFont boldSystemFontOfSize:10];
    orderInfoLal.backgroundColor=[UIColor clearColor];
    orderInfoLal.text=@"";
    orderInfoLal.textAlignment=NSTextAlignmentCenter;
    [view addSubview:orderInfoLal];
    UIButton *setTingBack=[UIButton buttonWithType:0];
    setTingBack.frame=CGRectMake(280,20, 22,22);
    [setTingBack setImage:[UIImage imageNamed:@"icon_setting_normal"] forState:0];
    [setTingBack addTarget:self action:@selector(settingQct:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:setTingBack];
    
    self.tableView.tableHeaderView=view;
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
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
    
    [cell.mesImageView setHidden:YES];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    if([userType isEqualToString:@"2"]){
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
                myZSManageViewController.isBarVip=false;
                [self.navigationController pushViewController:myZSManageViewController animated:YES];
                
                break;
            }
            case 4:// 购物车
            {
                
                LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
                carListViewController.title=@"购物车";
                [self.navigationController pushViewController:carListViewController animated:YES];
                break;
            }
            case 5:// 信息中心
            {
                
                MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
                messageListViewController.title=@"信息中心";
                [self.navigationController pushViewController:messageListViewController animated:YES];
                
                break;
            }
                
            default://推荐商户
            {
                //            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
                //            tuiJianShangJiaViewController.title=@"推荐商家";
                //            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
                //            
                //            break;
            }
                
        }
    }else if ( [userType isEqualToString:@"1"]){
        switch (indexPath.row) {
                
            case 0://我是专属经理
            {
                [MyUtil showMessage:@"审核中,请耐心等候"];
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
                myZSManageViewController.isBarVip=false;
                [self.navigationController pushViewController:myZSManageViewController animated:YES];
                
                break;
            }
            case 4:// 购物车
            {
                
                LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
                carListViewController.title=@"购物车";
                [self.navigationController pushViewController:carListViewController animated:YES];
                break;
            }
            case 5:// 信息中心
            {
                
                MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
                messageListViewController.title=@"信息中心";
                [self.navigationController pushViewController:messageListViewController animated:YES];
                
                break;
            }
                
            default://推荐商户
            {
                //            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
                //            tuiJianShangJiaViewController.title=@"推荐商家";
                //            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
                //
                //            break;
            }
                
        }
    }else{
        switch (indexPath.row) {
                
            
                
            case 0:// 订单
            {
                LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
                myOrderManageViewController.title=@"我的订单";
                [self.navigationController pushViewController:myOrderManageViewController animated:YES];
                break;
            }
                
            case 1:// 收藏
            {
                MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
                maintViewController.title=@"我的收藏";
                [self.navigationController pushViewController:maintViewController animated:YES];
                break;
            }
                
            case 2:// 专属经理
            {
                MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
                myZSManageViewController.title=@"我的专属经理";
                myZSManageViewController.isBarVip=false;
                [self.navigationController pushViewController:myZSManageViewController animated:YES];
                
                break;
            }
            case 3:// 购物车
            {
                
                LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
                carListViewController.title=@"购物车";
                [self.navigationController pushViewController:carListViewController animated:YES];
                break;
            }
            case 4:// 信息中心
            {
                
                MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
                messageListViewController.title=@"信息中心";
                [self.navigationController pushViewController:messageListViewController animated:YES];
                
                break;
            }
                
            default://推荐商户
            {
                //            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
                //            tuiJianShangJiaViewController.title=@"推荐商家";
                //            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
                //
                //            break;
            }
                
        }
    }
    
    
    
}

#pragma mark 设置
- (IBAction)settingQct:(UIButton *)sender {
    Setting *setting =[[Setting alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
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
