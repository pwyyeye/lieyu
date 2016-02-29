//
//  PTjoinInViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTjoinInViewController.h"
#import "ZSManageHttpTool.h"
#import "CYTopShowCell.h"
#import "CYPayAmoutCell.h"
#import "CYInfoCell.h"
#import "PTTaoCanCell.h"
#import "ChoosePayController.h"
#import "LYHomePageHttpTool.h"
#import "LYMyOrderManageViewController.h"
@interface PTjoinInViewController ()

@end

@implementation PTjoinInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    //获取详细
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getdata];
}
#pragma mark - 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance]getZSOrderDetailWithParams:dic block:^(OrderInfoModel *result) {
        pinKeModel = result;
        [weakSelf.tableView reloadData];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==3){
        return pinKeModel.pinkerinfo.goodsDetailList.count;
        
    }else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(pinKeModel){
        return 4;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0  || section==2){
        return 1;
    }else{
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0 || section==2){
        return [[UIView alloc] initWithFrame:CGRectZero];
        
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        if(section==1){
            label.text=@"付款金额：";
        }else{
            label.text=@"套餐内容";
        }
        [view addSubview:label];
        return view;
    
    
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 134;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CYTopShowCell" forIndexPath:indexPath];
            if (cell) {
                CYTopShowCell * adCell = (CYTopShowCell *)cell;
                [adCell configureCell:pinKeModel];
                
                
            }
        }
            break;
        case 1:
        {
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"CYPayAmoutCell" forIndexPath:indexPath];
            CYPayAmoutCell *payAmoutCell = (CYPayAmoutCell *)cell;
            payAmoutCell.priceLal.text=[NSString stringWithFormat:@"￥%@",pinKeModel.pinkerNeedPayAmount];
            if(pinKeModel.pinkerNeedPayAmount.doubleValue==0.0){
                [_payBtn setTitle:@"免费参与" forState:UIControlStateNormal];
            }
            if(pinKeModel.orderStatus!=0){
                [_payBtn setTitle:@"人数已满" forState:UIControlStateNormal];
            }
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CYInfoCell" forIndexPath:indexPath];
            CYInfoCell *infoCell = (CYInfoCell *)cell;
            infoCell.addressLal.text=pinKeModel.barinfo.address;
            infoCell.timeLal.text=pinKeModel.reachtime;
            infoCell.numLal.text=pinKeModel.allnum;
        }
            break;
        
        default:
        {
            NSArray *arr=pinKeModel.pinkerinfo.goodsDetailList;
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanCell" forIndexPath:indexPath];
            PTTaoCanCell *taoCanCell = (PTTaoCanCell *)cell;
            [taoCanCell configureCell:arr[indexPath.row]];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://头部
        {
            h = 84;
        }
            break;
        case 1://
        {
            h = 56;
        }
            break;
        case 2://
        {
            h = 104;
        }
            break;
        
        
        default://
        {
            h = 46;
        }
            break;
    }
    return h;
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
#pragma mark - 立即支付
- (IBAction)payAct:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [[LYHomePageHttpTool shareInstance]inTogetherOrderInWithParams:@{@"id":[NSString stringWithFormat:@"%d",pinKeModel.id],@"payamount":pinKeModel.pinkerNeedPayAmount} complete:^(NSString *result) {
        if(result){
            //支付宝页面"data": "P130637201510181610220",
            //result的值就是P130637201510181610220
            if (pinKeModel.pinkerNeedPayAmount.doubleValue==0.0) {
                UIViewController *detailViewController;
                
                detailViewController  = [[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    
                [weakSelf.navigationController pushViewController:detailViewController animated:YES];

            }else{
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                detailViewController.payAmount=pinKeModel.pinkerNeedPayAmount.doubleValue;
                detailViewController.productName=pinKeModel.fullname;
                detailViewController.productDescription=@"暂无";
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:weakSelf action:nil];
                weakSelf.navigationItem.backBarButtonItem = left;
                [weakSelf.navigationController pushViewController:detailViewController animated:YES];
            }
           
        }
    }];
    

}
@end
