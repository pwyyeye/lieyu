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
#import "SetMealInfoModel.h"
#import "SetMealVOModel.h"
#import "GoodsModel.h"
#import "ProductVOModel.h"
#import "ShopDetailmodel.h"
#import "NSObject+MJKeyValue.h"
#import "LYUserHttpTool.h"

@interface CheckOrderWithQRViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    int count;
    NSMutableArray *selectedArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation CheckOrderWithQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速核对订单";
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.checkBtn.layer.cornerRadius = 2;
    self.checkBtn.layer.masksToBounds = YES;
    self.checkBtn.backgroundColor = [UIColor lightGrayColor];
    self.checkBtn.enabled = NO;
    [self.checkBtn addTarget:self action:@selector(checkOrders) forControlEvents:UIControlEventTouchUpInside];
    selectedArray = [NSMutableArray array];
    for (int i = 0 ; i < _tempArr.count; i ++) {
        [selectedArray addObject:@"0"];
    }
    [self registerCells];
}

- (void)registerCells{
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderBody" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderBody"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderHeader"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QRCheckOrderFooter" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCheckOrderFooter"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegae的各个方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderInfoModel *model = [_tempArr objectAtIndex:section];
    QRCheckOrderFooter *footerView = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderFooter"];
    footerView.payment = model.amountPay;
//    QRCheckOrderFooter *footerView = [[[NSBundle mainBundle]loadNibNamed:@"QRCheckOrderFooter" owner:nil options:nil]firstObject];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderInfoModel *model = [_tempArr objectAtIndex:section];
    QRCheckOrderHeader *headerView = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderHeader"];
    headerView.orderinfo = model;
    headerView.IsSelected.tag = section;
    if ([[selectedArray objectAtIndex:section] isEqualToString:@"1"]) {
        headerView.IsSelected.selected = YES;
    }
    [headerView.IsSelected addTarget:self action:@selector(selectGoodForSection:) forControlEvents:UIControlEventTouchUpInside];
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
    OrderInfoModel *orderInfoMode = _tempArr[indexPath.section];
    QRCheckOrderBody *bodyCell = [self.myTableView dequeueReusableCellWithIdentifier:@"QRCheckOrderBody" forIndexPath:indexPath] ;
    bodyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShopDetailmodel *shopDetailModel = [[ShopDetailmodel alloc]init];
    if (orderInfoMode.ordertype == 0) {//0-－套餐订单
        SetMealInfoModel *setMealInfoModel = orderInfoMode.setMealInfo;
        SetMealVOModel *setMealVOModel = setMealInfoModel.setMealVO;
        shopDetailModel.img = setMealVOModel.linkUrl;
        shopDetailModel.name = setMealInfoModel.fullName;
        shopDetailModel.youfeiPrice = setMealVOModel.price;
        shopDetailModel.count = orderInfoMode.allnum;
    }else if (orderInfoMode.ordertype == 1){//1--拼客
        SetMealVOModel *setMealVO = orderInfoMode.pinkerinfo;
        shopDetailModel.name = setMealVO.smname;
        shopDetailModel.img = setMealVO.linkUrl;
        shopDetailModel.youfeiPrice = setMealVO.price;
        shopDetailModel.count = orderInfoMode.allnum;
    }else{//吃喝转成
        NSArray *arr = orderInfoMode.goodslist;
        NSDictionary *dicTemp = arr[indexPath.row];
        GoodsModel *goodModel = [GoodsModel mj_objectWithKeyValues:dicTemp];
        ProductVOModel *productVOModel = goodModel.productVO;
        shopDetailModel.name = goodModel.fullName;
        shopDetailModel.img = productVOModel.image;
        shopDetailModel.youfeiPrice = productVOModel.price;
        shopDetailModel.count = [NSString stringWithFormat:@"%@(%@)",goodModel.quantity,goodModel.productVO.unit];
    }
    bodyCell.model = shopDetailModel;
    return bodyCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 109;
}

#pragma mark - 点击选择按钮后
- (void)selectGoodForSection:(UIButton *)button{
    if (button.selected == NO) {//未选择
        [selectedArray setObject:@"1" atIndexedSubscript:button.tag];
        button.selected = YES;
        count ++;
        if (count > 0 && _checkBtn.enabled == NO) {//count大于0，_checkBtn不可用，即止修改一次
            _checkBtn.backgroundColor = RGB(186, 40, 227);
            _checkBtn.enabled = YES;
        }
    }else{
        button.selected = NO;
        [selectedArray setObject:@"0" atIndexedSubscript:button.tag];
        count --;
        if (count <= 0) {
            _checkBtn.backgroundColor = [UIColor lightGrayColor];
            _checkBtn.enabled = NO;
        }
    }
}

#pragma mark - 点击核对按钮之后的操作
- (void)checkOrders{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"是否确认为用户当时消费订单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableString *orderID = [NSMutableString string];
    NSMutableString *consumerID = [NSMutableString string];
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    if(buttonIndex == 0){
        for(int i = 0 ; i < selectedArray.count ; i ++){
            if ([[selectedArray objectAtIndex:i] isEqualToString:@"1"]) {
                OrderInfoModel *model = [_tempArr objectAtIndex:i];
                [orderID appendString:[NSString stringWithFormat:@"%d",model.id]];
                [orderID appendString:@","];
                NSString *consumer = [MyUtil decryptUseDES:model.consumptionCode withKey:app.desKey];
                [consumerID appendString:consumer];
                [consumerID appendString:@","];
            }
        }//将消费码以及订单号拼接好，但是末尾多了一个“，”
        [orderID deleteCharactersInRange:NSMakeRange(orderID.length - 1, 1)];
        [consumerID deleteCharactersInRange:NSMakeRange(consumerID.length - 1, 1)];
        NSString *DNS_consumerID = [MyUtil encryptUseDES:consumerID withKey:app.desKey];
        NSDictionary *dic = @{@"ids":orderID,
                              @"consumptionCodes":DNS_consumerID};
        [LYUserHttpTool QuickCheckOrderWithParam:dic complete:^(NSString *message) {
//            if ([message isEqualToString:@""]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [MyUtil showLikePlaceMessage:message];
//            }
        }];
    }else if (buttonIndex == 1){
        NSLog(@"1");
    }
}

@end
