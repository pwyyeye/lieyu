//
//  LPOrderDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPOrderDetailViewController.h"
#import "LPOrdersHeaderView.h"
#import "LPOrdersBodyCell.h"
#import "LPOrdersFooterCell.h"
#import "DetailUserInfoCell.h"
#import "DetailPlaceTimeCell.h"
#import "DetailLabelView.h"

@interface LPOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LPOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCells];
}

- (void)registerCells{
    [self.myTableView registerNib:[UINib nibWithNibName:@"LPOrdersBodyCell" bundle:nil] forCellReuseIdentifier:@"LPOrdersBodyCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"LPOrdersFooterCell" bundle:nil] forCellReuseIdentifier:@"LPOrdersFooterCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailUserInfoCell" bundle:nil] forCellReuseIdentifier:@"DetailUserInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailPlaceTimeCell" bundle:nil] forCellReuseIdentifier:@"DetailPlaceTimeCell"];
}

- (void)initBottomView{
    if (self.orderInfoModel.orderStatus == 2 || self.orderInfoModel.orderStatus == 1) {
        //待消费
        self.consumerCodeLbl.hidden = NO;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *consumer = [MyUtil decryptUseDES:self.orderInfoModel.consumptionCode withKey:app.desKey];
        [self.consumerCodeLbl setText:[NSString stringWithFormat:@"消费码：%@",consumer]];
    }else{
        self.consumerCodeLbl.hidden = YES;
    }
    _firstButton.layer.cornerRadius = 14;
    _secondButton.layer.cornerRadius = 14;
    if (self.orderInfoModel.orderStatus == 0) {
        _firstButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        _firstButton.layer.borderWidth = 0.5;
        [_firstButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (self.orderInfoModel.ordertype == 1) {
            if(self.orderInfoModel.userid == self.userModel.userid){
                [_firstButton setTitle:@"" forState:UIControlStateNormal];
                [_secondButton setTitle:@"" forState:UIControlStateNormal];
            }else{
                [_firstButton setTitle:@"" forState:UIControlStateNormal];
                [_secondButton setTitle:@"" forState:UIControlStateNormal];
            }
        }else{
            [_firstButton setTitle:@"" forState:UIControlStateNormal];
            [_secondButton setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderInfoModel.ordertype == 1) {
        if (self.orderInfoModel.userid == self.userModel.userid) {
            return 4;
        }else{
            return 3;
        }
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.orderInfoModel.pinkerList.count;
    }else if(section == 0){
        if (self.orderInfoModel.ordertype == 2) {
            return self.orderInfoModel.goodslist.count;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LPOrdersBodyCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"LPOrdersBodyCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderInfoModel;
        return cell;
    }else if (indexPath.section == 1){
        DetailPlaceTimeCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailPlaceTimeCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 2){
        DetailUserInfoCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailUserInfoCell" forIndexPath:indexPath];
        return cell;
    }else{
        DetailUserInfoCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"DetailUserInfoCell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 76;
    }else if (indexPath.section == 1){
        return 56;
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        LPOrdersHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"LPOrdersHeaderView" owner:nil options:nil]firstObject];
        headerView.model = self.orderInfoModel;
        return headerView;
    }else if(section == 2){
        DetailLabelView *labelView = [[[NSBundle mainBundle]loadNibNamed:@"DetailLabelView" owner:nil options:nil]firstObject];
        [labelView configureManager];
        return labelView;
    }else if (section == 3){
        DetailLabelView *labelView = [[[NSBundle mainBundle]loadNibNamed:@"DetailLabelView" owner:nil options:nil]firstObject];
        [labelView configureNumber:self.orderInfoModel.pinkerCount];
        return labelView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 58;
    }else if (section == 2){
        return 26;
    }else if (section == 3){
        return 26;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        LPOrdersFooterCell *footerView = [[[NSBundle mainBundle]loadNibNamed:@"LPOrdersFooterCell" owner:nil options:nil]firstObject];
        footerView.model = self.orderInfoModel;
        return footerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }else{
        return 0;
    }
}


@end
