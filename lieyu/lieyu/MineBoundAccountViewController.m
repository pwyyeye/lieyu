//
//  MineBoundAccountViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineBoundAccountViewController.h"
#import "wechatCheckAccountViewController.h"

@interface MineBoundAccountViewController ()

@property (nonatomic, assign) NSInteger choosedIndex;

@end

@implementation MineBoundAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _finishButton.layer.cornerRadius = 19;
    _finishButton.layer.masksToBounds = YES;
    [_finishButton addTarget:self action:@selector(sendAccountInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _choosedIndex = 1;
    
    UIButton *button = [[UIButton alloc]init];
    button.tag = 1;
    [self withdrawButtonClick:button];
}

- (void)setButtonSelected:(int)index{
    for (UIButton *button in _withdrawButtons) {
        if (button.tag == index) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)withdrawButtonClick:(UIButton *)sender {
    [_firstTextField setText:@""];
    [_secondTextField setText:@""];
    [_thirdTextField setText:@""];
    [self setButtonSelected:(int)sender.tag];
    _choosedIndex = sender.tag;
    if (sender.tag == 1) {
        [_firstLabel setText:@"微信号"];
        [_firstTextField setPlaceholder:@"请输入您的微信号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeDefault];
        [_secondLabel setText:@"姓名"];
        [_secondTextField setPlaceholder:@"请输入您的姓名"];
        _thirdLabel.hidden = YES;
        _thirdTextField.hidden = YES;
        _seperateLabel.hidden = YES;
        _viewHeight.constant = 101;
        _wechatLabel.hidden = NO;
    }else if (sender.tag == 2){
        [_firstLabel setText:@"支付宝账号"];
        [_firstTextField setPlaceholder:@"请输入您的支付宝账号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeDefault];
        [_secondLabel setText:@"姓名"];
        [_secondTextField setPlaceholder:@"请输入支付宝绑定的姓名"];
        _thirdLabel.hidden = YES;
        _thirdTextField.hidden = YES;
        _seperateLabel.hidden = YES;
        _viewHeight.constant = 101;
        _wechatLabel.hidden = YES;
    }else{
        [_firstLabel setText:@"银行卡号"];
        [_firstTextField setPlaceholder:@"请输入您的银行卡号"];
        [_firstTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_secondLabel setText:@"开户支行"];
        [_secondTextField setPlaceholder:@"请输入您的开户支行"];
        [_thirdLabel setText:@"开户姓名"];
        [_thirdTextField setPlaceholder:@"请输入您的开户姓名"];
        _thirdLabel.hidden = NO;
        _thirdTextField.hidden = NO;
        _seperateLabel.hidden = NO;
        _viewHeight.constant = 151;
        _wechatLabel.hidden = YES;
    }
}

- (void)sendAccountInfo{
    if ([MyUtil isEmptyString:_firstTextField.text] || [MyUtil isEmptyString:_secondTextField.text] || ([MyUtil isEmptyString:_thirdTextField.text] && _choosedIndex == 3)) {
        [MyUtil showPlaceMessage:@"请将信息填写完整"];
        return;
    }
    NSDictionary *dict ;
    if (_choosedIndex == 1) {
        dict = @{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid],
                 @"wechatName":_secondTextField.text,
                 @"wechatId":_firstTextField.text};
    }else if (_choosedIndex == 2){
        dict = @{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid],
                 @"alipayaccount":_firstTextField.text,
                 @"alipayAccountName":_secondTextField.text};
    }else if (_choosedIndex == 3){
        dict = @{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid],
                 @"bankCard":_firstTextField.text,
                 @"bankCardDeposit":_secondTextField.text,
                 @"bankCardUsername":_thirdTextField.text};
    }
    //进行网络请求
    if (_choosedIndex == 3) {
        wechatCheckAccountViewController *wechatCheckAccountVC = [[wechatCheckAccountViewController alloc]initWithNibName:@"wechatCheckAccountViewController" bundle:nil];
        [self.navigationController pushViewController:wechatCheckAccountVC animated:YES];
    }
}


@end
