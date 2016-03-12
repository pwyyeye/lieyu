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
#import "ZSMyClientsViewController.h"
#import "ZSMyShopsManageViewController.h"
#import "ZSNoticeCenterViewController.h"
#import "XiaoFeiMaUiew.h"
#import "ZSListCell.h"
#import "LYRecentContactViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SaoYiSaoViewController.h"
#import "LYUserHttpTool.h"

@interface ZSMaintViewController ()<UITextFieldDelegate>

@end

@implementation ZSMaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArr =[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets=1;
    self.tableView.bounces=NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self getDataForShowList];
    
    
    
   
}

#pragma mark 初始化数据
-(void)getDataForShowList{
    [listArr removeAllObjects];
    NSDictionary *dic=@{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""};
    NSDictionary *dic1=@{@"colorRGB":RGB(136, 223, 121),@"imageContent":@"Fill20179",@"title":@"最近联系",@"delInfo":@"您有客户留言请及时查收"};
    NSDictionary *dic2=@{@"colorRGB":RGB(254, 147, 87),@"imageContent":@"Fill20219",@"title":@"订单管理",@"delInfo":@"您有订单要确认请及时确定"};
    NSDictionary *dic3=@{@"colorRGB":RGB(65, 241, 221),@"imageContent":@"Fill20176",@"title":@"我的客户",@"delInfo":@""};
    NSDictionary *dic4=@{@"colorRGB":RGB(186, 40, 227),@"imageContent":@"Fill20176",@"title":@"速核码扫描",@"delInfo":@""};
//    NSDictionary *dic4=@{@"colorRGB":RGB(84, 225, 255),@"imageContent":@"Fill2097",@"title":@"商铺管理",@"delInfo":@""};
    
    [listArr addObject:dic2];//订单管理
//    [listArr addObject:dic4];//速核码扫描
    [listArr addObject:dic];//卡座已满
    [listArr addObject:dic1];//通知中心
    [listArr addObject:dic3];//我的客户
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 212)];
    
//    view.backgroundColor=RGB(35, 166, 116);
    view.backgroundColor = RGB(186, 40, 227);
    
    //外部圆
//    cImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 44, 68, 88, 88)];
//    [view addSubview:cImageView];
//    [cImageView setImage:[UIImage imageNamed:@"yuanhuan"]];
//    myPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, 81.7, 60, 60)];
//    //照片圆形
//    myPhotoImageView.layer.masksToBounds =YES;
//    
//    myPhotoImageView.layer.cornerRadius =myPhotoImageView.frame.size.width/2;
//    myPhotoImageView.backgroundColor=[UIColor lightGrayColor];
//    [myPhotoImageView setImageWithURL:[NSURL URLWithString:self.userModel.avatar_img]];
//    [view addSubview:myPhotoImageView];
//    namelal=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50,167,100,18)];
//    [namelal setTextColor:RGB(255,255,255)];
//    namelal.font=[UIFont boldSystemFontOfSize:12];
//    namelal.backgroundColor=[UIColor clearColor];
//    namelal.text=@"我是VIP专属经理";
//    namelal.textAlignment=NSTextAlignmentLeft;
//    [view addSubview:namelal];
//    orderInfoLal=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 133,200,266,16)];
//    [orderInfoLal setTextColor:RGB(255,255,255)];
//    orderInfoLal.font=[UIFont boldSystemFontOfSize:10];
//    orderInfoLal.backgroundColor=[UIColor clearColor];
////    orderInfoLal.text=@"您有30个订单要处理，请即时处理！";
//    orderInfoLal.textAlignment=NSTextAlignmentLeft;
//    [view addSubview:orderInfoLal];
    
    UIButton *ScanButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 28, 70, 56, 56)];
    ScanButton.backgroundColor = [UIColor clearColor];
    [ScanButton setImage:[UIImage imageNamed:@"zsQRCodeScan"] forState:UIControlStateNormal];
    [ScanButton addTarget:self action:@selector(zsQRCodeScanClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ScanButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 28, 134, 56, 18)];
    label.text = @"速核码";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBA(0, 0, 0, 0.5);
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UITextField *textView = [[UITextField alloc]initWithFrame:CGRectMake(8, 161, SCREEN_WIDTH - 16, 43)];
    textView.placeholder = @"请输入消费码";
    textView.delegate = self;
    textView.tag = 123;
    textView.borderStyle = UITextBorderStyleRoundedRect;
    textView.keyboardType = UIKeyboardTypeNumberPad;
    textView.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textView];
    
    //返回按钮
    _btnBack=[[UIButton alloc] initWithFrame:CGRectMake(15, 40, 44, 44)];
    [_btnBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnBack];
    self.tableView.tableHeaderView=view;
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    //    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UITextField *text = [self.view viewWithTag:123];
    text.text = @"";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - 扫一扫
- (void)zsQRCodeScanClick{
    SaoYiSaoViewController *saoyisaoVC = [[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
    [self.navigationController pushViewController:saoyisaoVC animated:YES];
}

#pragma mark - 输入完消费码之后
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *consuer = [MyUtil encryptUseDES:textField.text withKey:app.desKey];
        NSDictionary *dic = @{@"consumptionCode":consuer};
        [LYUserHttpTool zsCheckConsumerIDWith:dic complete:^{
            
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
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
//    NSString *delInfo=[dic objectForKey:@"delInfo"];
//    @{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""}
    [cell.mesImageView setHidden:YES];
    cell.backImageView.backgroundColor=bColor;
    cell.CoutentImageView.image=imge;
    cell.titleLbl.text=title;
//    cell.delLal.text=delInfo;
//    cell.disImageView;
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
    
    switch (indexPath.row) {
            
        case 1://卡座
        {
            ZSSeatControlView *seatControlView=[[ZSSeatControlView alloc]initWithNibName:@"ZSSeatControlView" bundle:nil];
            [self.navigationController pushViewController:seatControlView animated:YES];
            break;
        }
            
        case 2:// 通知中心
        {
            LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
            chat.title=@"最近联系";
            [self.navigationController pushViewController:chat animated:YES];
            break;
        }
            
        case 0:// 订单管理
        {
            ZSOrderViewController *orderManageViewController=[[ZSOrderViewController alloc]initWithNibName:@"ZSOrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderManageViewController animated:YES];
            break;
        }
            
        case 3:// 我的客户
        {
            ZSMyClientsViewController *myClientViewController=[[ZSMyClientsViewController alloc]initWithNibName:@"ZSMyClientsViewController" bundle:nil];
            
            [self.navigationController pushViewController:myClientViewController animated:YES];
            break;
        }
//        case 1://速核码扫描
//        {
//            SaoYiSaoViewController *saoyisaoVC = [[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
//            [self.navigationController pushViewController:saoyisaoVC animated:YES];
//        }
        default:
        {
//            ZSMyShopsManageViewController *myShopManageViewController=[[ZSMyShopsManageViewController alloc]initWithNibName:@"ZSMyShopsManageViewController" bundle:nil];
//            [self.navigationController pushViewController:myShopManageViewController animated:YES];
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
