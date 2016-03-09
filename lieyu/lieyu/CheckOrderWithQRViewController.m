//
//  CheckOrderWithQRViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CheckOrderWithQRViewController.h"
#import "OrderInfoModel.h"
#import "QRCheckOrderBody.h"
#import "QRCheckOrderFooter.h"
#import "QRCheckOrderHeader.h"

@interface CheckOrderWithQRViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation CheckOrderWithQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速核对订单";
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderBody" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderBody"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderHeader"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderFooter" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderFooter"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegae的各个方法
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    QRCheckOrderFooter *footerView = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderFooter"];
//    QRCheckOrderFooter *footerView = [[[NSBundle mainBundle]loadNibNamed:@"QRCheckOrderFooter" owner:nil options:nil]firstObject];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QRCheckOrderHeader *headerView = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderHeader"];
//    QRCheckOrderHeader *headerView = [[[NSBundle mainBundle]loadNibNamed:@"QRCheckOrderHeader" owner:nil options:nil]firstObject];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tempArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderInfoModel *orderInfoModel = self.tempArr[section];
    if (orderInfoModel.ordertype == 2) {
        return orderInfoModel.goodslist.count;
    }else if (orderInfoModel.ordertype == 0){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    OrderInfoModel *orderInfoMode = _tempArr[indexPath.section];
    QRCheckOrderBody *bodyCell = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderBody"];
    return bodyCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 109;
}

@end
