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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *userModel= app.userModel;
    
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    if(pinKeModel.pinkerList.count>0){
        for (NSDictionary *dic in pinKeModel.pinkerList) {
            PinkInfoModel *pinkInfoModel=[PinkInfoModel objectWithKeyValues:dic];
            if(pinkInfoModel.inmember==userModel.userid){
                detailViewController.orderNo=pinkInfoModel.sn;
                detailViewController.payAmount=pinkInfoModel.price.doubleValue;
            }
        }
    }

    detailViewController.productName=pinKeModel.fullname;
    detailViewController.productDescription=@"暂无";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}
@end
