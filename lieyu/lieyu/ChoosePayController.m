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
#import "PayButton.h"
#import "PinkerShareController.h"
#import "HDDetailViewController.h"
#import "CHDoOrderViewController.h"
#import "ZujuViewController.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "PTjoinInViewController.h"
#import "LPMyOrdersViewController.h"
#import "MineBalanceViewController.h"
#import "MineYubiViewController.h"
#import "WatchLiveShowViewController.h"

@interface ChoosePayController ()
{
    UITableViewCell *_payCell;
    NSInteger _selectIndex;
    UIButton *_payBtn;
}
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic, strong) ZSBalance *balanceModel;

@property (assign, nonatomic) BOOL isBalanceEnough;

@end

@implementation ChoosePayController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-107);
        _payBtn.frame = CGRectMake(10, SCREEN_HEIGHT - 123, SCREEN_WIDTH - 20, 52);
    }
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
    self.title=@"支付方式";
    _btnArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self createPayButton];//创建支付按钮
}

- (void)getData{
    __weak __typeof(self)weakSelf = self;
    [LYUserHttpTool getMyMoneyBagBalanceAndCoinWithParams:nil complete:^(ZSBalance *balance) {
        _balanceModel = balance;
        if (_payAmount > [_balanceModel.balances doubleValue] || _isRechargeBalance) {
            _isBalanceEnough = NO;
            if (_isRechargeBalance) {
                _data=@[
                        @{@"payname":@"余额支付",@"paydetail":@"不能使用余额进行此项操作",@"payicon":@"balanceIcon"},
                        @{@"payname":@"支付宝支付",@"paydetail":@"推荐有支付宝帐户的用户使用",@"payicon":@"AlipayIcon"},
                        @{@"payname":@"微信支付",@"paydetail":@"推荐有微信帐户的用户使用",@"payicon":@"TenpayIcon"}
                        ];
            }else{
                _data=@[
                        @{@"payname":@"余额支付",@"paydetail":@"余额不足",@"payicon":@"balanceIcon"},
                        @{@"payname":@"支付宝支付",@"paydetail":@"推荐有支付宝帐户的用户使用",@"payicon":@"AlipayIcon"},
                        @{@"payname":@"微信支付",@"paydetail":@"推荐有微信帐户的用户使用",@"payicon":@"TenpayIcon"}
                        ];
            }
            _selectIndex = 1;
        }else{
            _isBalanceEnough = YES;
            _data=@[
                    @{@"payname":@"余额支付",@"paydetail":@"推荐余额优先支付",@"payicon":@"balanceIcon"},
                    @{@"payname":@"支付宝支付",@"paydetail":@"推荐有支付宝帐户的用户使用",@"payicon":@"AlipayIcon"},
                    @{@"payname":@"微信支付",@"paydetail":@"推荐有微信帐户的用户使用",@"payicon":@"TenpayIcon"}
                    ];
            _selectIndex = 0;
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)createPayButton{
    _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 123, SCREEN_WIDTH - 20, 44)];
//    [_payBtn setBackgroundImage:[UIImage imageNamed:@"purpleBtnBG"] forState:UIControlStateNormal];
    [_payBtn setBackgroundColor:COMMON_PURPLE];
//    [_payBtn setBackgroundImage:[UIImage imageNamed:@"LoginNew"] forState:UIControlStateNormal];
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [_payBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payBtn];
}

#pragma mark 支付按钮
- (void)payClick{
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
    if (_isPinker&&_createDate!=nil) {
        NSTimeInterval orderTime = [_createDate timeIntervalSinceNow];
        NSLog(@"----pass-pass=%.f---",orderTime);

       if(orderTime < -300){
           [MyUtil showLikePlaceMessage:@"订单超时无法支付"];
            return;
       }

    }
    __weak __typeof(self) weakSelf = self;
    if (_selectIndex == 1l) {//支付宝
        AlipayOrder *order=[[AlipayOrder alloc] init];
        order.tradeNO = _orderNo; //订单ID（由商家自行制定）
        order.productName = _productName; //商品标题
        order.productDescription = _productDescription; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",_payAmount];
        //    order.amount=[NSString stringWithFormat:@"%.2f",0.01];
        SingletonAlipay *alipay=[SingletonAlipay singletonAlipay];
        alipay.delegate=self;
        [alipay payOrder:order];
    }else if (_selectIndex == 2l) {//微信
        SingletonTenpay *tenpay=[SingletonTenpay singletonTenpay];
        tenpay.orderNO=_orderNo;
        tenpay.isFaqi=_isFaqi;
        tenpay.isPinker=_isPinker;
        [tenpay preparePay:@{@"orderNo":_orderNo,@"payAmount":[NSString stringWithFormat:@"%.0f",_payAmount*100],@"productDescription":_productName} complete:^(BaseReq *result) {
            if (result) {
                [tenpay onReq:result];
                if ([weakSelf.delegate respondsToSelector:@selector(rechargeDelegateRefreshData)] && weakSelf.delegate) {
                    [weakSelf.delegate rechargeDelegateRefreshData];
                }
                [weakSelf gotoBack];
            }else{
                [MyUtil showMessage:@"无法调起微信支付！"];
            }
        }];
    }else if (_selectIndex == 0){//余额支付
        NSDictionary *dict = @{@"offBalances":[NSString stringWithFormat:@"%f",_payAmount]};
        [LYUserHttpTool rechargeCoinWithParams:dict complete:^(BOOL result) {
            if (result) {
                if ([weakSelf.delegate respondsToSelector:@selector(rechargeDelegateRefreshData)] && weakSelf.delegate) {
                [weakSelf.delegate rechargeDelegateRefreshData];
                }
                [weakSelf gotoBack];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoBack{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[HDDetailViewController class]] || [controller isKindOfClass:[CHDoOrderViewController class]] || [controller isKindOfClass:[ZujuViewController class]] || [controller isKindOfClass:[LYwoYaoDinWeiMainViewController class]]||[controller isKindOfClass:[PTjoinInViewController class]]){
            LPMyOrdersViewController *detailViewController = [[LPMyOrdersViewController alloc]init];
            [self.navigationController pushViewController:detailViewController animated:YES];
            return;
        }else if ([controller isKindOfClass:[WatchLiveShowViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (!section) {
        return 1;
    }
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section) {
        return 60;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section) {
        return 8;
    }else{
        return 36.5;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section) {
//        UIView *view = [[UIView alloc]init];
//        view.frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
//    }
//}

/*
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
*/
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"总需支付";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%g 元",_payAmount];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            _payCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
            if (!_payCell) {
                _payCell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
            }
            _payCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *dic= _data[indexPath.row];
            _payCell.textLabel.text=[dic objectForKey:@"payname"];
            _payCell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
            _payCell.textLabel.textColor=RGB(26, 26, 26);
            
            _payCell.detailTextLabel.text=[dic objectForKey:@"paydetail"];
            _payCell.detailTextLabel.font= [UIFont systemFontOfSize:14];
            _payCell.detailTextLabel.textColor=RGB(102, 101, 102);
            _payCell.imageView.image=[UIImage imageNamed:[dic objectForKey:@"payicon"]];
            
            PayButton *selectBtn = [[PayButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 230,0, 230, 80)];
//            [selectBtn setBackgroundColor:[UIColor redColor]];
            if (!indexPath.row && _isBalanceEnough) {
                selectBtn.isSelect = YES;
            }else if (indexPath.row == 1 && !_isBalanceEnough){
                selectBtn.isSelect = YES;
            }else{
                selectBtn.isSelect = NO;
            }
            if (!indexPath.row && !_isBalanceEnough) {
                selectBtn.enabled = NO;
            }else{
                selectBtn.enabled = YES;
            }
//            if (!indexPath.row) {
//                    selectBtn.isSelect = YES;
//            }else{
//                selectBtn.isSelect = NO;
//            }
            selectBtn.tag = indexPath.row;

            [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            [_payCell addSubview:selectBtn];
            [_btnArray addObject:selectBtn];
            
            return _payCell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)selectClick:(PayButton *)button{
    NSLog(@"selectClick:%ld",button.tag);
    _selectIndex = button.tag;
    for (PayButton *btn in _btnArray) {
        btn.isSelect = NO;
    }
    button.isSelect = YES;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
        
        NSDictionary *dict = @{@"result":@"支付宝支付成功"};
        [MTA trackCustomKeyValueEvent:@"payEvent" props:dict];
        if ([self.delegate respondsToSelector:@selector(rechargeDelegateRefreshData)] && self.delegate) {
            [self.delegate rechargeDelegateRefreshData];
        }
        if (_isPinker && _isFaqi) {
            PinkerShareController *zujuVC = [[PinkerShareController alloc]initWithNibName:@"PinkerShareController" bundle:nil];
            zujuVC.sn=_orderNo;
            [self.navigationController pushViewController:zujuVC animated:YES];
        }else{
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if([controller isKindOfClass:[MineBalanceViewController class]] || [controller isKindOfClass:[MineYubiViewController class]]){
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    LPMyOrdersViewController *detailViewController = [[LPMyOrdersViewController alloc]init];
//                    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
//                    self.navigationItem.leftBarButtonItem = left;
//                    
//                    [self.navigationController pushViewController:detailViewController animated:YES];
//                }
//            }
            [self gotoBack];
        }
        
    }else if([[resultDic objectForKey:@"resultStatus"] longLongValue]==6001){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[MineBalanceViewController class]] || [controller isKindOfClass:[MineYubiViewController class]]){
//                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        UIViewController *detailViewController;
        detailViewController = [[LPMyOrdersViewController alloc]init];
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:nil action:nil];
        delegate.navigationController.navigationItem.backBarButtonItem=item;
        [delegate.navigationController pushViewController:detailViewController animated:YES];
    }
}
@end
