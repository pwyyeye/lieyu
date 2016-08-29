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

@interface MineYubiViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *yubiAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;

@property (nonatomic, assign) CGFloat yubiAmount;

@end

@implementation MineYubiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"娱币充值";
    [self initItems];
    _yubiAmount = 500;
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
    [cell.rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (void)rechargeButtonClick:(UIButton *)button{
    if (button.tag == 0) {
        [self rechargeWithAmount:@"8"];
    }else if (button.tag == 1){
        [self rechargeWithAmount:@"38"];
    }else if (button.tag == 2){
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
    NSLog(@"充值：%@",money);
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    //            detailViewController.orderNo=result;
    detailViewController.payAmount=[money doubleValue];
    detailViewController.productName=@"钱包娱币充值";
    detailViewController.productDescription=@"暂无";
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)withdrawClick{
    UIAlertView *withdrawAlertView = [[UIAlertView alloc]initWithTitle:@"请输入兑换娱币数目" message:@"平台将收取30%手续费" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"兑现", nil];
    withdrawAlertView.tag = 2;
    [withdrawAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *withdrawField = [withdrawAlertView textFieldAtIndex:0];
    withdrawField.textAlignment = NSTextAlignmentCenter;
    withdrawField.keyboardType = UIKeyboardTypeNumberPad;
    withdrawField.text = [NSString stringWithFormat:@"%g",_yubiAmount];
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
            if ([textField.text doubleValue] > _yubiAmount) {
                [MyUtil showPlaceMessage:@"娱币不足，请重新输入！"];
            }else{
                [MyUtil showPlaceMessage:[NSString stringWithFormat:@"恭喜您，成功兑换%@娱币！",textField.text]];
            }
            NSLog(@"兑现%@",textField.text);
        }
    }
}

@end
