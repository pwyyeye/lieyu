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
//    _balance = @"888.22";
//    _type = @"0";
//    _account = @"sfdkjhsfjka";
}

- (void)initAllPropertites{
    self.title = @"提现操作";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.accountLbl setText:[NSString stringWithFormat:@"%@ (%@)",_type,_account]];
    [self.balanceLbl setText:[NSString stringWithFormat:@"¥%@",_balance]];
    
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
    
    introArray = @[@"当日到账，100元以内收取2元手续费，100元以上收取2‰的手续费",@"次日到账，金额将于明天24点之前到账，不收取任何手续费"];
    UIButton *button = [self.chooseButtons objectAtIndex:0];
    [button setSelected:YES];
    for (UIButton *button in self.chooseButtons) {
        [button addTarget:self action:@selector(chooseWithdrawTime:) forControlEvents:UIControlEventTouchUpInside];
    }
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
    }];
}

- (void)chooseWithdrawTime:(UIButton *)button{
    for (UIButton *btn in self.chooseButtons) {
        if (btn.tag == button.tag) {
            isTody = btn.tag - 1;
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
