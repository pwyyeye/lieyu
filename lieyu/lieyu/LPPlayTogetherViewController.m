//
//  LPPlayTogetherViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPPlayTogetherViewController.h"
#import "BarInfoTableViewCell.h"
#import "TaocanTableViewCell.h"
#import "AddressTableViewCell.h"
#import "BitianTableViewCell.h"
#import "ContentTableViewCell.h"
#import "LiuchengTableViewCell.h"


#import "LYHomePageHttpTool.h"
#import "ContentView.h"
#import "LPAttentionViewController.h"
#import "LPBuyViewController.h"
#import "LYtimeChooseTimeController.h"
#import "TimePickerView.h"

@interface LPPlayTogetherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BitianTableViewCell *biTianCell;
@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) TimePickerView *LPtimeView;

@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) NSString *defaultString;
@property (nonatomic, strong) NSDate *defaultDate;

@end

@implementation LPPlayTogetherViewController
//- (UIViewController *)childViewControllerForStatusBarStyle{
//    UIViewController *statusview = [[UIViewController alloc]init];
//    statusview.view.frame = CGRectMake(0, 0, 320, 20);
//    statusview.view.backgroundColor = [UIColor purpleColor];
//    return statusview;
//}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultString = @"请选择消费方式";
    self.defaultDate = [NSDate date];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.labelArray = @[@"我请客",
                        @"AA付款",
                        @"自由付款"];
    [self.backBtn addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareTaocan) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self action:@selector(likeTaocan) forControlEvents:UIControlEventTouchUpInside];
    [self getdata];
}

- (void)backForword{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareTaocan{
    NSLog(@"Share Success!");
}

- (void)likeTaocan{
    NSLog(@"Like Success!");
}

- (void)addStatusView{
    UIView *status = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    status.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:status];
}

- (void)getdata{
    NSDictionary *dic = @{@"smid":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherDetailWithParams:dic block:^(PinKeModel *result) {
        _pinKeModel = result;
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height;
    switch (indexPath.section) {
        case 0:
            height = 360;
            break;
        case 1:
            height = 146;
            break;
        case 2:
            height = 60;
            break;
        case 3:
            height = 184;
            break;
        case 4:
            height = 66 + 44 * (int)self.pinKeModel.goodsList.count;
            break;
        case 5:
            height = 216;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        BarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barInfo"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BarInfoTableViewCell" owner:nil options:nil]firstObject];
        }
        if(self.pinKeModel){
            NSDictionary *dict = @{@"barName":self.pinKeModel.barinfo.barname,@"stars":@"4",@"imageURL":self.pinKeModel.banner[0]};
            [cell cellConfigure:dict];
        }
        return cell;
    }else if(indexPath.section == 1){
        TaocanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taocan"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TaocanTableViewCell" owner:nil options:nil]firstObject];
        }
        if(self.pinKeModel){
            NSDictionary *dict = @{
                                   @"taocanInfo":self.pinKeModel.title,                           @"price":self.pinKeModel.price,
                                   @"marketPrice":self.pinKeModel.marketprice,
                                   @"profit":self.pinKeModel.rebate};
            cell.dict = dict;
            [cell cellConfigure];
        }
        return cell;
    }else if(indexPath.section == 2){
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddressTableViewCell" owner:nil options:nil]firstObject];
        }
        if(self.pinKeModel){
            NSLog(@"%@",self.pinKeModel.barinfo.address);
            [cell cellConfigure:self.pinKeModel.barinfo.address];
        }
        return cell;
    }else if(indexPath.section == 3){
        _biTianCell = [tableView dequeueReusableCellWithIdentifier:@"biTian"];
        if(!_biTianCell){
            _biTianCell = [[[NSBundle mainBundle]loadNibNamed:@"BitianTableViewCell" owner:nil options:nil]firstObject];
            [_biTianCell.chooseTime addTarget:self action:@selector(chooseTimeForTaocan) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.chooseWay addTarget:self action:@selector(chooseWayForTaocan) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.addBtn addTarget:self action:@selector(addPeople) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.lessBtn addTarget:self action:@selector(lessPeople) forControlEvents:UIControlEventTouchUpInside];
        }
        return _biTianCell;
    }else if(indexPath.section == 4){
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ContentTableViewCell" owner:nil options:nil]firstObject];
        }
        if(self.pinKeModel){
            cell.goodList = self.pinKeModel.goodsList;
            [cell cellConfigure];
        }
        return cell;
    }else{
        LiuchengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liucheng"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LiuchengTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }
}

#pragma 实现代理的方法
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenWay:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        for (int index = 0 ; index < _contentView.buttonStatusArray.count; index ++) {
            if([_contentView.buttonStatusArray[index] isEqualToString:@"1"]){
                [self.biTianCell.chooseWay setTitle:self.labelArray[index] forState:UIControlStateNormal];
                self.defaultString = self.labelArray[index];
            }
        }
        
    }
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
//        for (int index = 0 ; index < _contentView.buttonStatusArray.count; index ++) {
            self.defaultDate = _LPtimeView.timePicker.date;
            NSLog(@"--------%@",_LPtimeView.timePicker.date);
//            NSLog(@"--------2%@",_LPtimeView.timePicker.c)
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM月dd日 EEE HH:mm"];
            NSString *dateString = [formatter stringFromDate:self.defaultDate];
            [self.biTianCell.chooseTime setTitle:dateString forState:UIControlStateNormal];
//        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (void)chooseTimeForTaocan{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"确定", @"取消", nil];
    alertView.delegate = self;
    _LPtimeView = [[[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:nil options:nil]firstObject];
    _LPtimeView.tag = 11;
//    [_timeView showTimeWithDate:self.defaultDate];
    _LPtimeView.timePicker.date = self.defaultDate;
    alertView.contentView = _LPtimeView;
    _LPtimeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
    [alertView show];
}

- (void)chooseWayForTaocan{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"确定", @"取消", nil];
    alertView.delegate = self;
    _contentView = [[[NSBundle mainBundle]loadNibNamed:@"ContentView" owner:nil options:nil]firstObject];
    _contentView.tag = 12;
    _contentView.defaultString = self.defaultString;
    [_contentView contentViewChooseBtn];
    _contentView.frame = CGRectMake(10, SCREEN_HEIGHT- 320, SCREEN_WIDTH - 20, 250);
    alertView.contentView = _contentView;
    [alertView show];
}

- (void)addPeople{
    
}

- (void)lessPeople{
    
}

- (IBAction)ZiXunLieyu:(UIButton *)sender {
}

- (IBAction)ZhuYiShixiang:(UIButton *)sender {
    LPAttentionViewController *LPattentionVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPattention"];
    [self.navigationController pushViewController:LPattentionVC animated:YES];
}

- (IBAction)BuyNow:(UIButton *)sender {
    LPBuyViewController *LPBuyVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPBuyVC"];
    LPBuyVC.pinkeModel = self.pinKeModel;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy年MM月dd日 EEE HH:mm"];
    NSString *dateString = [formatter stringFromDate:self.defaultDate];
    
    NSDictionary *dict = @{@"time":dateString,
                           @"way":self.defaultString,
                           @"money":@"800",
                           @"number":@"5"};
    LPBuyVC.InfoDict = dict;
    [self.navigationController pushViewController:LPBuyVC animated:YES];
}

- (IBAction)LikeClick:(UIButton *)sender {
}

- (IBAction)ShareClick:(UIButton *)sender {
}
@end
