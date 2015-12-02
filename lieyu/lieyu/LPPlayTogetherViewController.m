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

@interface LPPlayTogetherViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LPPlayTogetherViewController
//- (UIViewController *)childViewControllerForStatusBarStyle{
//    UIViewController *statusview = [[UIViewController alloc]init];
//    statusview.view.frame = CGRectMake(0, 0, 320, 20);
//    statusview.view.backgroundColor = [UIColor purpleColor];
//    return statusview;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self getdata];
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
            height = 200;
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
        TaocanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taoCan"];
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
        BitianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"biTian"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BitianTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.section == 4){
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ContentTableViewCell" owner:nil options:nil]firstObject];
        }
        if(self.pinKeModel){
            for(int i = 0 ; i < self.pinKeModel.goodsList.count ; i ++){
                NSString *str1 = self.pinKeModel.goodsList[i][@"_name"];
                
            }
//            cell.goodList = self.pinKeModel.goodsList;
//            [cell cellConfigure];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
@end
