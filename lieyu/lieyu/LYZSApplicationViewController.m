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
}
@end

@implementation LYZSApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    [[NSMutableDictionary alloc]initWithDictionary:@{@"introduction":_zwjsTex.text,@"idcard":self.sfzTex.text,@"barid":[NSNumber numberWithInt:jiuBaNow.barid],@"userid":[NSNumber numberWithInt:self.userModel.userid]}];
    if((self.zfbTex.text.length>0)&& (self.zfbzhTex.text.length>0)){
        [dic setObject:self.zfbzhTex.text forKey:@"alipayaccount"];
        [dic setObject:self.zfbTex.text forKey:@"alipayAccountName"];
    }
    if((self.yhkkhTex.text.length>0)&& (self.yhkKhmYhmTex.text.length>0)&& (self.yhkyhmTex.text.length>0)){
        [dic setObject:self.yhkkhTex.text forKey:@"bankCard"];
        [dic setObject:[NSString stringWithFormat:@"%@+%@",self.yhkKhmYhmTex.text,self.yhkyhmTex.text] forKey:@"bankCardDeposit"];
    }

    LyZSuploadIdCardViewController *suploadIdCardViewController=[[LyZSuploadIdCardViewController alloc]initWithNibName:@"LyZSuploadIdCardViewController" bundle:nil];
    suploadIdCardViewController.paramdic=dic;
    suploadIdCardViewController.title=@"上传身份证";
    [self.navigationController pushViewController:suploadIdCardViewController animated:YES];
}
#pragma mark - 选择酒吧代理
- (bool)checkData{
    
    if(![MyUtil validateIdentityCard:self.sfzTex.text]){
        [MyUtil showMessage:@"你输入身份证有误"];
        return false;
    }
    if(!jiuBaNow){
        [MyUtil showMessage:@"请选择酒吧"];
        return false;
    }
    if((self.zfbTex.text.length>0)&& (self.zfbzhTex.text.length>0)){
        return true;
    }
    if((self.yhkkhTex.text.length>0)&& (self.yhkKhmYhmTex.text.length>0)&& (self.yhkyhmTex.text.length>0)){
        return true;
    }
    [MyUtil showMessage:@"至少选一种支付方式！"];
    return false;
}
#pragma mark - 选择酒吧代理
- (void)chooseJiuBa:(JiuBaModel *)jiuBaModel{
    jiuBaNow=jiuBaModel;
    self.jiubaLal.text=jiuBaModel.barname;
}
- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
