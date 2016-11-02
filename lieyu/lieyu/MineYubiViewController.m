//
//  MineYubiViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineYubiViewController.h"
#import "MineYubiRechargeTableViewCell.h"
#import "ChoosePayController.h"
#import "LYUserHttpTool.h"
#import "MineCoinRecordViewController.h"
#import <StoreKit/StoreKit.h>


@interface MineYubiViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,RechargeDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *yubiAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;


@property (strong, nonatomic) NSString *productID;

@end

@implementation MineYubiViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"娱币充值";
    [self getData];
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getData];
    [self initRightItem];
    
    [self initItems];
}

- (void)getData{
    [LYUserHttpTool getMyMoneyBagBalanceAndCoinWithParams:nil complete:^(ZSBalance *balance) {
        _coinAmount = balance.coin;
        _balance = balance.balances;
        
        [_yubiAmountLabel setText:_coinAmount];
    }];
}

- (void)initRightItem{
    UIButton *listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [listButton setTitle:@"充值记录" forState:UIControlStateNormal];
    [listButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [listButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [listButton setTitleColor:NAVIGATIONBARTITLECOLOR forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(withdrawListClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initItems{
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1)];
    
    if (SCREEN_HEIGHT - 64 < 603) {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 603);
    }else{
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _rechargeButton.layer.cornerRadius = 19;
    [_rechargeButton addTarget:self action:@selector(rechargeCustomClick) forControlEvents:UIControlEventTouchUpInside];
    _withdrawButton.layer.cornerRadius = 19;
    [_withdrawButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [_tableView registerNib:[UINib nibWithNibName:@"MineYubiRechargeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MineYubiRechargeTableViewCell"];
}

#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineYubiRechargeTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MineYubiRechargeTableViewCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIButton *button = [[UIButton alloc]init];
//    button.tag = indexPath.row;
//    [self rechargeButtonClick:button];
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self requestProductData:@"lieyuIcon800"];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件

- (void)withdrawListClick:(UIButton *)button{
    MineCoinRecordViewController *coinRecordVC = [[MineCoinRecordViewController alloc]init];
    [self.navigationController pushViewController:coinRecordVC animated:YES];
}


- (void)rechargeButtonClick:(UIButton *)button{
    NSString *message;;
    if (button.tag == 0) {
        message = @"8";
        [self rechargeWithAmount:@"8"];
    }else if (button.tag == 1){
        message = @"38";
        [self rechargeWithAmount:@"38"];
    }else if (button.tag == 2){
        message = @"88";
        [self rechargeWithAmount:@"88"];
    }
}

- (void)rechargeCustomClick{
    UIAlertView *rechargeAlertview = [[UIAlertView alloc]initWithTitle:nil message:@"充值越多赠送越多" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    rechargeAlertview.tag = 1;
    [rechargeAlertview setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *rechargeField = [rechargeAlertview textFieldAtIndex:0];
    rechargeField.textAlignment = NSTextAlignmentCenter;
    rechargeField.keyboardType = UIKeyboardTypeNumberPad;
    rechargeField.placeholder = @"请输入自定义金额";
    [rechargeAlertview show];
    
}

- (void)rechargeWithAmount:(NSString *)money{
    if ([money doubleValue] <= 0.0) {
        [MyUtil showPlaceMessage:@"充值金额不可为0或更小！"];
        return;
    }
    NSDictionary *dict = @{@"amount":money,
                           @"isToCoin":@"1"};
    __weak __typeof(self) weakSelf = self;
    [LYUserHttpTool rechargeMoneyBagWithParams:dict complete:^(NSString *result) {
        ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
        detailViewController.orderNo=result;
        detailViewController.isRechargeCoin = YES;
        detailViewController.delegate = weakSelf;
        detailViewController.payAmount=[money doubleValue];
        detailViewController.productName=@"钱包余额充值";
        detailViewController.productDescription=@"暂无";
        [weakSelf.navigationController pushViewController:detailViewController animated:YES];
    }];
}

- (void)rechargeDelegateRefreshData{
//    [self getData];
//    if ([self.delegate respondsToSelector:@selector(MineYubiWithdrawDelegate:)]) {
//        [self.delegate MineYubiWithdrawDelegate:0];
//    }
}

- (void)rechargeCoinDelegate:(double)amount{
    _yubiAmountLabel.text = [NSString stringWithFormat:@"%g",[_yubiAmountLabel.text doubleValue] + amount * 100];
    if ([self.delegate respondsToSelector:@selector(MineYubiWithdrawDelegate:)]) {
        [self.delegate MineYubiWithdrawDelegate:0];
    }
}

- (void)withdrawClick{
    UIAlertView *withdrawAlertView = [[UIAlertView alloc]initWithTitle:@"请输入兑换娱币数目" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"兑现", nil];
    withdrawAlertView.tag = 2;
    [withdrawAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *withdrawField = [withdrawAlertView textFieldAtIndex:0];
    withdrawField.textAlignment = NSTextAlignmentCenter;
    withdrawField.keyboardType = UIKeyboardTypeNumberPad;
    withdrawField.text = _coinAmount;
    [withdrawAlertView show];
}

#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self rechargeWithAmount:textField.text];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex == 1) {
            if ([textField.text doubleValue] > [_coinAmount doubleValue]) {
                [MyUtil showPlaceMessage:@"娱币不足，请重新输入！"];
            }else{
                NSDictionary *dict = @{@"subamount":textField.text};
                __weak __typeof(self) weakSelf = self;
                [LYUserHttpTool coinChangeToMoneyWithParams:dict complete:^(BOOL result) {
                    if (result) {
                        [MyUtil showPlaceMessage:[NSString stringWithFormat:@"恭喜您，成功兑换%@娱币！",textField.text]];
                        double amount = [_coinAmount doubleValue] - [textField.text doubleValue];
                        [_yubiAmountLabel setText:[NSString stringWithFormat:@"%g",amount]];
                        if ([weakSelf.delegate respondsToSelector:@selector(MineYubiWithdrawDelegate:)]) {
                            [weakSelf.delegate MineYubiWithdrawDelegate:amount];
                        }
                    }
                }];
            }
        }
    }
}

//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

#pragma mark - IAP代理
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
}

- (void)requestDidFinish:(SKRequest *)request{
    
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions{
}


//交易结束
// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
}


@end
