//
//  ChoosePayController.m
//  haitao
//
//  Created by pwy on 15/8/9.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChoosePayController.h"
#import "LYMyOrderManageViewController.h"
#import "SingletonTenpay.h"
@interface ChoosePayController ()

@end

@implementation ChoosePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
    self.title=@"选择支付方式";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    _data=@[
            @{@"payname":@"支付宝支付",@"paydetail":@"推荐有支付宝帐户的用户使用",@"payicon":@"AlipayIcon"},
           @{@"payname":@"微信支付",@"paydetail":@"推荐有微信帐户的用户使用",@"payicon":@"TenpayIcon"}
            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoBack{
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[TariffViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//            return;
//        }
//    }
    UIViewController *detailViewController;
    
    detailViewController  = [[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    
//    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
//    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    delegate.navigationController.navigationItem.backBarButtonItem=item;
    [self.navigationController pushViewController:detailViewController animated:YES];
   
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _data.count;
}

-
(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //订单号    

    NSLog(@"----pass-_orderNo%@---",_orderNo);
    if ([MyUtil isEmptyString:_orderNo]) {
        return;
    }
    if (_payAmount==0) { 
        return;
    }
    if ([MyUtil isEmptyString:_productName]) {
        return;
    }
    if ([MyUtil isEmptyString:_productDescription]) {
        return;
    }
    
    if (indexPath.row==0) {
        AlipayOrder *order=[[AlipayOrder alloc] init];
        //
        order.tradeNO = _orderNo; //订单ID（由商家自行制定）
        order.productName = _productName; //商品标题
        order.productDescription = _productDescription; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",_payAmount];
        //    order.amount=[NSString stringWithFormat:@"%.2f",0.01];
        
        SingletonAlipay *alipay=[SingletonAlipay singletonAlipay];
        alipay.delegate=self;
        [alipay payOrder:order];
    }else{
        SingletonTenpay *tenpay=[SingletonTenpay singletonTenpay];

        [tenpay preparePay:@{@"orderNo":_orderNo,@"payAmount":[NSString stringWithFormat:@"%.0f",_payAmount*100],@"productDescription":_productName} complete:^(BaseReq *result) {
            if (result) {
                [tenpay onReq:result];
            }
        }];
    }
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayCell *cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"paycell"];

    NSDictionary *dic= _data[indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"payname"];
    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
    cell.textLabel.textColor=RGB(51, 51, 51);
    
    cell.detailTextLabel.text=[dic objectForKey:@"paydetail"];
    cell.detailTextLabel.font= [UIFont systemFontOfSize:11];
    cell.detailTextLabel.textColor=RGB(128, 128, 128);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image=[UIImage imageNamed:[dic objectForKey:@"payicon"]];

    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - alipay delegate
-(void)callBack:(NSDictionary *)resultDic{
    if (resultDic.count==0) {
        [MyUtil showMessage:@"支付订单失败，如果您确定已经付款成功，请及时联系客服！"];
        return;
        
    }
    //9000订单支付成功 且 success＝＝true
    if ([[resultDic objectForKey:@"partner"] rangeOfString:@"success=\"true\""].location == NSNotFound) {
          [MyUtil showMessage:@"支付订单失败，如果您确定已经付款成功，请及时联系客服！"];
        return;
    }
    if ([[resultDic objectForKey:@"resultStatus"] longLongValue]==9000) {
           [MyUtil showMessage:@"支付成功！"];
        LYMyOrderManageViewController *detailViewController =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    
      //  detailViewController.orderNoString=_orderNo;
      //  detailViewController.payAmountString=[NSString stringWithFormat:@"%.2f",_payAmount];
        
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if([[resultDic objectForKey:@"resultStatus"] longLongValue]==6001){
        UIViewController *detailViewController;
        
      
            detailViewController  =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];

        
        
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        //    delegate.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
        
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        delegate.navigationController.navigationItem.backBarButtonItem=item;
        [delegate.navigationController pushViewController:detailViewController animated:YES];
        
        
        
    }
    
    
}
@end
