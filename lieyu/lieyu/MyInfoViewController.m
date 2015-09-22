//
//  MyInfoViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ZSMaintViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listArr =[[NSMutableArray alloc]init];
    //    self.automaticallyAdjustsScrollViewInsets=0;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getDataForShowList];

//    [self.navigationController setNavigationBarHidden:YES];
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
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    NSLog(@"111");
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"222");
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

- (IBAction)queryZSInfo:(id)sender {
    ZSMaintViewController *maintViewController=[[ZSMaintViewController alloc]initWithNibName:@"ZSMaintViewController" bundle:nil];
    [self.navigationController pushViewController:maintViewController animated:YES];
 
//HomePageINeedPlayViewController.
}
@end
