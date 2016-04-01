//
//  LYZSApplicationViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYZSApplicationViewController.h"
#import "LyZSuploadIdCardViewController.h"
#import "LYChooseJiuBaViewController.h"
#import "JiuBaModel.h"
@interface LYZSApplicationViewController ()<LYChooseJiuBaDelegate>
{
    JiuBaModel *jiuBaNow;
    
    NSString *idcard;//1.2.3
    NSString *wechatName;//1
    NSString *alipayaccount;//2
    NSString *alipayAccountName;//2
    NSString *bankCard;//3
    NSString *bankCardDeposit;//3
    NSString *bankCardUsername;//3
    
    
//    "idcard":"身份证",
//    "alipayaccount":"支付宝账户",
//    "bankCard":"银行卡号",
//    "alipayAccountName":"支付宝账号名称",
//    "bankCardDeposit":"银行卡开户行",
//    "bankCardUsername":"用户名",
}
@property (nonatomic, assign) int accountNum;
@end

@implementation LYZSApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 21;
    for (UIButton *button in self.chooseButtons) {
        button.selected = NO;
        [button addTarget:self action:@selector(chooseAccount:) forControlEvents:UIControlEventTouchUpInside];
    }
    _viewLine2.hidden = YES;
    _viewLine3.hidden = YES;
    _viewLine4.hidden = YES;
    _sfzTex.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setAccountNum:(int)accountNum{
    _accountNum = accountNum;
    if (accountNum == 1) {
        _viewLine2.hidden = NO;
        [_viewLabel2 setText:@"真实姓名"];
        [_yhkkhTex setText:@""];
        [_yhkkhTex setPlaceholder:@"请输入您的真实姓名"];
        
        _viewLine3.hidden = YES;
        _viewLine4.hidden = YES;
    }else if (accountNum == 2){
        _viewLine2.hidden = NO;
        [_viewLabel2 setText:@"支付宝账号"];
        [_yhkkhTex setText:@""];
        [_yhkkhTex setPlaceholder:@"请输入正确的帐号"];
        
        _viewLine3.hidden = NO;
        [_viewLabel3 setText:@"绑定姓名"];
        [_yhkKhmYhmTex setText:@""];
        [_yhkKhmYhmTex setPlaceholder:@"用户支付宝绑定姓名"];
        
        _viewLine4.hidden = YES;
    }else if (accountNum == 3){
        _viewLine2.hidden = NO;
        [_viewLabel2 setText:@"银行卡号"];
        [_yhkkhTex setText:@""];
        [_yhkkhTex setPlaceholder:@"请输入您的卡号"];
        _yhkkhTex.keyboardType = UIKeyboardTypeNumberPad;
        
        _viewLine3.hidden = NO;
        [_viewLabel3 setText:@"开户支行"];
        [_yhkKhmYhmTex setText:@""];
        [_yhkKhmYhmTex setPlaceholder:@"请输入您的开户支行"];
        
        _viewLine4.hidden = NO;
        [_viewLabel4 setText:@"开户姓名"];
        [_yhkyhmTex setText:@""];
        [_yhkyhmTex setPlaceholder:@"请输入您的开户姓名"];
    }
}

- (void)chooseAccount:(UIButton *)button{
    for (UIButton *btn in self.chooseButtons) {
        if (btn.tag == button.tag) {
            btn.selected = YES;
            [self setAccountNum:button.tag];
        }else{
            btn.selected = NO;
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
#pragma mark - 选择酒吧
- (IBAction)chooseJiuBaAct:(UIButton *)sender {
    LYChooseJiuBaViewController *chooseJiuBaViewController=[[LYChooseJiuBaViewController alloc]initWithNibName:@"LYChooseJiuBaViewController" bundle:nil];
    chooseJiuBaViewController.title=@"选择酒吧";
    chooseJiuBaViewController.delegate=self;
    [self.navigationController pushViewController:chooseJiuBaViewController animated:YES];
}

#pragma mark - 下一步
- (IBAction)nextAct:(UIButton *)sender {
//   [self.view makeToast:@"This is a piece of toast."];
    if(![self checkData]){
        return;
    }
    NSMutableDictionary *dic=
    [[NSMutableDictionary alloc]initWithDictionary:@{@"idcard":idcard,@"barid":[NSNumber numberWithInt:jiuBaNow.barid],@"userid":[NSNumber numberWithInt:self.userModel.userid],@"applyType":[NSNumber numberWithInt:_accountNum]}];
    if (_accountNum == 1) {
        if (wechatName.length) {
            [dic setObject:wechatName forKey:@"wechatName"];
        }
    }else if (_accountNum == 2){
        if (alipayaccount.length && alipayAccountName.length) {
            [dic setObject:alipayAccountName forKey:@"alipayAccountName"];
            [dic setObject:alipayaccount forKey:@"alipayaccount"];
        }
    }else if (_accountNum == 3){
        if (bankCardUsername.length && bankCardDeposit.length && bankCard.length) {
            [dic setObject:bankCard forKey:@"bankCard"];
            [dic setObject:bankCardDeposit forKey:@"bankCardDeposit"];
            [dic setObject:bankCardUsername forKey:@"bankCardUsername"];
        }
    }
    LyZSuploadIdCardViewController *suploadIdCardViewController=[[LyZSuploadIdCardViewController alloc]initWithNibName:@"LyZSuploadIdCardViewController" bundle:nil];
    suploadIdCardViewController.paramdic=dic;
    suploadIdCardViewController.title=@"上传身份证";
    [self.navigationController pushViewController:suploadIdCardViewController animated:YES];
}

#pragma mark - 检验
- (bool)checkData{
    if(!jiuBaNow){
        [MyUtil showMessage:@"请选择酒吧"];
        return false;
    }
    if(![MyUtil validateIdentityCard:self.sfzTex.text]){
        [MyUtil showMessage:@"你输入身份证有误"];
        return false;
    }
    if (_accountNum == 0) {
        [MyUtil showMessage:@"至少选一种支付方式！"];
        return false;
    }else if (_accountNum == 1){
        idcard = _sfzTex.text;
        wechatName = _yhkkhTex.text;
        if (!idcard.length || !wechatName.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
            return true;
        }
    }else if (_accountNum == 2){
        idcard = _sfzTex.text;
        alipayaccount = _yhkkhTex.text;
        alipayAccountName = _yhkKhmYhmTex.text;
        if (!idcard.length || !alipayAccountName.length || !alipayaccount.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
            return true;
        }
    }else if (_accountNum == 3){
        idcard = _sfzTex.text;
        bankCard = _yhkkhTex.text;
        bankCardDeposit = _yhkKhmYhmTex.text;
        bankCardUsername = _yhkyhmTex.text;
        if (!idcard.length || !bankCard.length || !bankCardDeposit.length || !bankCardUsername.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
            return true;
        }
    }
    return YES;
}

- (void)dealloc{
    NSLog(@"deall");
}

#pragma mark - 选择酒吧代理
- (void)chooseJiuBa:(JiuBaModel *)jiuBaModel{
    jiuBaNow=jiuBaModel;
    [self.jiubaLal setTextColor:RGBA(186, 40, 227, 1)];
    self.jiubaLal.text=jiuBaModel.barname;
}
- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
