//
//  LYWithdrawTypeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWithdrawTypeViewController.h"
#import "IQKeyboardManager.h"
#import "ZSManageHttpTool.h"

@interface LYWithdrawTypeViewController ()<UITextFieldDelegate>
{
    NSArray *introArray;
    int isTody;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introlblLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introlblRight;

@end

@implementation LYWithdrawTypeViewController
- (void)loadView{
    [super loadView];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initAllPropertites];
    
    _shouxuLabel.hidden = YES;
    _poundageLabel.hidden = YES;
}

- (void)initAllPropertites{
    self.title = @"提现操作";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!_type.length || !_account.length) {
        [self.accountLbl setText:@"请先去绑定账号！"];
    }else{
        [self.accountLbl setText:[NSString stringWithFormat:@"%@ (%@)",_type,_account]];
    }
    if (!_balance.length) {
        [self.balanceLbl setText:@"0.00"];
    }else{
        [self.balanceLbl setText:[NSString stringWithFormat:@"¥%@",_balance]];
    }
    
    self.textview.delegate = self;
    self.textview.placeholder = _balance;
    self.textview.keyboardType = UIKeyboardTypeDecimalPad;
    self.textview.clearButtonMode = UITextFieldViewModeWhileEditing;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
    [self.withdrawBtn setEnabled:NO];
    self.withdrawBtn.layer.cornerRadius = 19;
    
    if (SCREEN_WIDTH == 320) {
        _introlblLeft.constant = 40;
        _introlblLeft.constant = 40;
    }
    
    [self.withdrawBtn addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    
    introArray = @[@"当日到账，1000元以内收取2元手续费，1000元以上收取2‰的手续费",@"次日到账，金额将于明天24点之前到账，不收取任何手续费"];
    UIButton *button = [self.chooseButtons objectAtIndex:0];
    [button setSelected:YES];
    for (UIButton *button in self.chooseButtons) {
        [button addTarget:self action:@selector(chooseWithdrawTime:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showPoundage{
    self.poundageLabel.hidden = NO;
    self.shouxuLabel.hidden = NO;
    if (self.textview.text.length) {
        if (isTody == 0) {
            if (([self.textview.text doubleValue] <= 1000)) {
                [_poundageLabel setText:@"2.00元"];
            }else{
                [_poundageLabel setText:[NSString stringWithFormat:@"%.2f元",[self.textview.text doubleValue] * 0.002]];
            }
        }else if (isTody == 1){
            [_poundageLabel setText:@"0.00元"];
        }
    }else{
        self.poundageLabel.hidden = YES;
        self.shouxuLabel.hidden = YES;
    }
}

- (void)hidePoundage{
    self.shouxuLabel.hidden = YES;
    self.poundageLabel.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSArray *array = [_textview.text componentsSeparatedByString:@"."];
    NSString *string1 = [array objectAtIndex:0];
    if ([string isEqualToString:@"0"] && range.length == 0 && range.location == 0) {
        return NO;
    }
    if (array.count > 1) {
        NSString *string2 = [array objectAtIndex:1];
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        if (string2.length >= 2 && string.length) {//小数点后
            if (range.location > string1.length) {
                return NO;
            }
        }
        if (string1.length >= 6 && string.length && range.location <= string1.length) {
            return NO;
        }
    }else if (string1.length >= 6 && ![string isEqualToString:@"."]) {
        return NO;
    }
    if ([string isEqualToString:@"."] && range.location == 0 && range.length == 0) {
        _textview.text = @"0";
    }
    return YES;
}

//钱包管理[编辑]
//【0001】managerAccountAction.do?action=add (已可用)申请提现[编辑]
//{
//    "isToday":"是否当日提现 0－今天 ，1-明天",
//    "amountStr":"提现金额"
//}

- (void)withdrawClick{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *dict = @{@"isToday":[NSString stringWithFormat:@"%d",isTody],
                           @"amountStr":[MyUtil encryptUseDES:_textview.text withKey:app.desKey]};
    [[ZSManageHttpTool shareInstance]applicationWithdrawWithParams:dict complete:^(NSString *message) {
        [MyUtil showLikePlaceMessage:message];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)chooseWithdrawTime:(UIButton *)button{
    for (UIButton *btn in self.chooseButtons) {
        if (btn.tag == button.tag) {
            isTody = (int)btn.tag - 1;
            btn.selected = YES;
            [_introduceLbl setText:[introArray objectAtIndex:btn.tag - 1]];
        }else{
            btn.selected = NO;
        }
    }
    [self textFieldDidEndEditing:_textview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *fieldText = textField.text;
    if ([fieldText doubleValue] <= [_balance doubleValue]) {
        NSArray *array = [fieldText componentsSeparatedByString:@"."];
        if(array.count > 2){
            [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
            [self.withdrawBtn setEnabled:NO];
//            [MyUtil showLikePlaceMessage:@"请输入正确金额！"];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [MyUtil showCleanMessage:@"请输入正确金额！"];
            [self hidePoundage];
//            });
        }else if(array.count == 2){
            NSString *string = [array objectAtIndex:1];
            if (string.length > 2) {
                [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
                [self.withdrawBtn setEnabled:NO];
//                [MyUtil showLikePlaceMessage:@"请输入正确金额！"];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyUtil showCleanMessage:@"请输入正确金额！"];
                [self hidePoundage];
//                });
            }else{
                if([fieldText doubleValue] < 2 && !isTody){
                    [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
                    [self.withdrawBtn setEnabled:NO];
                    [MyUtil showCleanMessage:@"提现金额不可少于两元！"];
                    [self hidePoundage];
                }else{
                    [self.withdrawBtn setBackgroundColor:RGB(186, 40, 227)];
                    [self.withdrawBtn setEnabled:YES];
                    [self showPoundage];
                }
            }
        }else{
            if([fieldText doubleValue] < 2 && !isTody){
                [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
                [self.withdrawBtn setEnabled:NO];
                [MyUtil showCleanMessage:@"提现金额不可少于两元！"];
                [self hidePoundage];
            }else{
                
                [self.withdrawBtn setBackgroundColor:RGB(186, 40, 227)];
                [self.withdrawBtn setEnabled:YES];
                [self showPoundage];
            }
        }
    }else{
        [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
        [self.withdrawBtn setEnabled:NO];
//        [MyUtil showLikePlaceMessage:@"请输入正确金额！"];
//        dispatch_async(dispatch_get_main_queue(), ^{
        [self hidePoundage];
            [MyUtil showCleanMessage:@"提现金额不可多于账户余额！"];
//        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
