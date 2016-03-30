//
//  LYWithdrawTypeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWithdrawTypeViewController.h"
#import "IQKeyboardManager.h"

@interface LYWithdrawTypeViewController ()<UITextFieldDelegate>
{
    NSArray *introArray;
}
@end

@implementation LYWithdrawTypeViewController
- (void)loadView{
    [super loadView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"提现操作";
    _balance = @"888.22";
    _type = @"0";
    _account = @"sfdkjhsfjka";
    [self.accountLbl setText:[NSString stringWithFormat:@"%@ (%@)",[_type isEqualToString:@"0"] ? @"支付宝" : @"微信钱包",_account]];
    [self.balanceLbl setText:[NSString stringWithFormat:@"¥%@",_balance]];
    self.textview.delegate = self;
    self.textview.placeholder = _balance;
    self.textview.keyboardType = UIKeyboardTypeDecimalPad;
    self.textview.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.textview addObserver:self forKeyPath:@"text" options:0 context:nil];
    [self.textview addTarget:self action:@selector(valueChanges) forControlEvents:UIControlEventEditingChanged];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [self.textview becomeFirstResponder];
    [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
    [self.withdrawBtn setEnabled:NO];
    self.withdrawBtn.layer.cornerRadius = 19;
    introArray = @[@"当日到账，100元以内收取2元的手续费，100元以上收取％2的手续费",@"次日到账，金额将于明天24点之前到账，不收取任何手续费"];
    UIButton *button = [self.chooseButtons objectAtIndex:0];
    [button setSelected:YES];
    for (UIButton *button in self.chooseButtons) {
        [button addTarget:self action:@selector(chooseWithdrawTime:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)valueChanges{
    NSLog(@"1:%@",_textview.text);
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"---%@",change);
}

- (void)chooseWithdrawTime:(UIButton *)button{
    for (UIButton *btn in self.chooseButtons) {
        if (btn.tag == button.tag) {
            btn.selected = YES;
            [_introduceLbl setText:[introArray objectAtIndex:btn.tag - 1]];
        }else{
            btn.selected = NO;
        }
    }
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
//            });
        }else if(array.count == 2){
            NSString *string = [array objectAtIndex:1];
            if (string.length > 2) {
                [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
                [self.withdrawBtn setEnabled:NO];
//                [MyUtil showLikePlaceMessage:@"请输入正确金额！"];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyUtil showCleanMessage:@"请输入正确金额！"];
//                });
            }else{
                [self.withdrawBtn setBackgroundColor:RGB(186, 40, 227)];
                [self.withdrawBtn setEnabled:YES];
            }
        }else{
            [self.withdrawBtn setBackgroundColor:RGB(186, 40, 227)];
            [self.withdrawBtn setEnabled:YES];
        }
    }else{
        [self.withdrawBtn setBackgroundColor:RGBA(153, 153, 153, 1)];
        [self.withdrawBtn setEnabled:NO];
//        [MyUtil showLikePlaceMessage:@"请输入正确金额！"];
//        dispatch_async(dispatch_get_main_queue(), ^{
            [MyUtil showCleanMessage:@"请输入正确金额！"];
//        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
