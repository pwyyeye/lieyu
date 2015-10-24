//
//  CHDoOrderViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHDoOrderViewController.h"
#import "LYHomePageHttpTool.h"
#import "CHDoOrderBottomView.h"
#import "CHDoOrderHeardView.h"
#import "CHDoOrderell.h"
#import "ZSDetailModel.h"
#import "PTzsjlCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface CHDoOrderViewController ()
{
    CarInfoModel *carInfoModel;
}
@end

@implementation CHDoOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];

    // Do any additional setup after loading the view.
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"ids":self.ids};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getChiHeOrderWithParams:dic block:^(CarInfoModel *result) {
        carInfoModel=result;
        [_payBtn setTitle:[NSString stringWithFormat:@"马上支付（￥%@）",carInfoModel.all_info.all_amount] forState:0];
        [weakSelf.tableView reloadData];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return carInfoModel.cartlist.count;
        
    }
    else{
        return carInfoModel.managerList.count;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(carInfoModel){
        return 2;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 38;
    }else{
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CHDoOrderHeardView" owner:nil options:nil];
        CHDoOrderHeardView *headView= (CHDoOrderHeardView *)[nibView objectAtIndex:0];
        headView.jiubarImageView.layer.masksToBounds =YES;
        
        headView.jiubarImageView.layer.cornerRadius =headView.jiubarImageView.frame.size.width/2;
        [headView.jiubarImageView  setImageWithURL:[NSURL URLWithString:carInfoModel.barinfo.baricon]];
        headView.barNameLal.text=carInfoModel.barinfo.barname;
        headView.addressLal.text=carInfoModel.barinfo.address;
        
        return headView;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.text=@"选择我的VIP专属经理";
        
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        return view;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==1){
        return 1;
    }
    return 56;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==1){
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CHDoOrderBottomView" owner:nil options:nil];
    CHDoOrderBottomView *bottomView= (CHDoOrderBottomView *)[nibView objectAtIndex:0];
    bottomView.priceLal.text=carInfoModel.all_info.all_amount;
    
    return bottomView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            CarModel *carModel=carInfoModel.cartlist[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CHDoOrderell" forIndexPath:indexPath];
            if (cell) {
                CHDoOrderell * adCell = (CHDoOrderell *)cell;
                [adCell configureCell:carModel];
                
                
            }
        }
            break;
        
       
            
        default:
        {
            ZSDetailModel *zsModel=carInfoModel.managerList[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTzsjlCell" forIndexPath:indexPath];
            if (cell) {
                PTzsjlCell * adCell = (PTzsjlCell *)cell;
                [adCell configureCell:zsModel];
                adCell.selBtn.tag=indexPath.row;
                [adCell.selBtn addTarget:self action:@selector(chooseZS:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0:
        {
            h = 81;
        }
            break;
        
        default:
        {
            h = 76;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark 选择专属经理
-(void)chooseZS:(UIButton *)sender{
    ZSDetailModel *zsModel=carInfoModel.managerList[sender.tag];
    zsModel.issel=true;
    for (int i=0; i<carInfoModel.managerList.count; i++) {
        ZSDetailModel *zsModelTemp=carInfoModel.managerList[i];
        if(i!=sender.tag){
            zsModelTemp.issel=false;
        }
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)payAct:(UIButton *)sender {
    if(carInfoModel){
        
        
        
        bool issel = false;
        int userId=0;
        for (ZSDetailModel *detaiModel in carInfoModel.managerList) {
            if(detaiModel.issel){
                userId=detaiModel.userid;
                issel=true;
                break;
            }
        }
        if(!issel){
            [self showMessage:@"请选择专属经理!"];
            return;
        }
        
        NSDictionary *dic=@{@"ids":self.ids,@"checkuserid":[NSNumber numberWithInt:userId]};
        [[LYHomePageHttpTool shareInstance]setChiHeOrderInWithParams:dic complete:^(NSString *result) {
            if(result){
                [MyUtil showMessage:result];
                
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
            }
        }];
        
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

@end
