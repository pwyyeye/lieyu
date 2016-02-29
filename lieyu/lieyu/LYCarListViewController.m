//
//  LYCarListViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCarListViewController.h"
#import "MJRefresh.h"
#import "CarHeadView.h"
#import "CarBottomView.h"
#import "CarInfoCell.h"
#import "LYHomePageHttpTool.h"
#import "CarInfoModel.h"
#import "CarModel.h"
#import "CHDoOrderViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface LYCarListViewController ()
{
    NSMutableArray *dataList;
    UILabel *warningLabel;
}
@end

@implementation LYCarListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"购物车";
    dataList=[[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self getData];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carnumChange) name:@"carnumChange" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"carnumChange" object:nil];
}
-(void)carnumChange{
    [self getData];
}
#pragma mark - 获取数据
-(void)getData{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCarListWithParams:nil block:^(NSMutableArray *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [dataList removeAllObjects];
        dataList=[result mutableCopy];
        if(dataList.count > 0){
            [warningLabel removeFromSuperview];
            for (CarInfoModel *carInfoModel in dataList) {
                carInfoModel.isSel=true;
                for (CarModel *carModel in carInfoModel.cartlist) {
                    carModel.isSel=true;
                }
            }
        }else{
            warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 40, 200, 20)];
            warningLabel.textAlignment = NSTextAlignmentCenter;
            warningLabel.textColor = RGB(186, 40, 227);
            warningLabel.text = @"购物车空空如也～";
            warningLabel.font = [UIFont systemFontOfSize:14];
            [weakSelf.view addSubview:warningLabel];
        }
        
        [weakSelf.tableView reloadData];
    }];
    [_tableView.mj_header endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CarInfoModel *carInfoModel=dataList[section];
    return carInfoModel.cartlist.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CarBottomView" owner:nil options:nil];
    CarBottomView *bottomView= (CarBottomView *)[nibView objectAtIndex:0];
    bottomView.jiesuanBtn.tag=section;
    [bottomView.jiesuanBtn addTarget:self action:@selector(jiesuanAct:) forControlEvents:UIControlEventTouchUpInside];
    CarInfoModel *carInfoModel=dataList[section];
    double payAmount=0;
    for (CarModel * carModel in carInfoModel.cartlist) {
        if(carModel.isSel){
            double price=carModel.product.price.doubleValue;
            double num =carModel.quantity.doubleValue;
            payAmount=payAmount+price*num;
        }
    }
    bottomView.priceLal.text =[NSString stringWithFormat:@"￥%.2f",payAmount];
    return bottomView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CarInfoModel *carInfoModel=dataList[section];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CarHeadView" owner:nil options:nil];
    CarHeadView *headView= (CarHeadView *)[nibView objectAtIndex:0];
    headView.jiubarImageView.layer.masksToBounds =YES;
    
    headView.jiubarImageView.layer.cornerRadius =headView.jiubarImageView.frame.size.width/2;
    [headView.jiubarImageView  setImageWithURL:[NSURL URLWithString:carInfoModel.barinfo.baricon]];
    headView.barNameLal.text=carInfoModel.barinfo.barname;
    headView.addressLal.text=carInfoModel.barinfo.address;
    headView.selBtn.tag=section;
    headView.chooseBtn.tag = section;
    [headView.selBtn setSelected:carInfoModel.isSel];
    [headView.selBtn addTarget:self action:@selector(sectionSel:) forControlEvents:UIControlEventTouchUpInside];
    [headView.chooseBtn addTarget:self action:@selector(sectionSel:) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*********cellForRowAtIndexPath%d*******",dataList.count);
    static NSString *CellIdentifier = @"CarInfoCell";
    
    CarInfoCell *cell = (CarInfoCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CarInfoCell *)[nibArray objectAtIndex:0];
    }
    CarInfoModel *carInfoModel=dataList[indexPath.section];
    CarModel *carModel=carInfoModel.cartlist[indexPath.row];
    
    [cell configureCell:carModel];
    [cell.selBtn setSelected:carModel.isSel];
    [cell.selBtn addTarget:self action:@selector(rowSel:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseBtn addTarget:self action:@selector(rowSel:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return YES;
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak __typeof(self)weakSelf = self;
        CarInfoModel *carInfoModel=dataList[indexPath.section];
        CarModel *carModel=carInfoModel.cartlist[indexPath.row];
        NSDictionary *dic=@{@"ids":[NSNumber numberWithInt:carModel.id]};
        [[LYHomePageHttpTool shareInstance] delcarWithParams:dic complete:^(BOOL result) {
            if(result){
                [MyUtil showLikePlaceMessage:@"删除成功"];
                [weakSelf getData];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"lessGood" object:nil];
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}


#pragma mark - 列表选中
- (void)rowSel:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    CarInfoModel *carInfoModel=dataList[indexPath.section];
    CarModel *carModel=carInfoModel.cartlist[indexPath.row];
    carModel.isSel=!carModel.isSel;
    BOOL isall=true;
    for (CarModel *modelTemp in carInfoModel.cartlist) {
        if(!modelTemp.isSel){
            isall=false;
            break;
        }
    }
    carInfoModel.isSel=isall;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 表头选中
- (void)sectionSel:(UIButton *)sender{
    CarInfoModel *carInfoModel=dataList[sender.tag];
    carInfoModel.isSel=!carInfoModel.isSel;
    if(carInfoModel.isSel){
        for (CarModel *modelTemp in carInfoModel.cartlist) {
            modelTemp.isSel=YES;
        }
    }else{
        for (CarModel *modelTemp in carInfoModel.cartlist) {
            modelTemp.isSel=false;
        }
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sender.tag];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 结算按钮
-(void)jiesuanAct:(UIButton *)sender{
    CarInfoModel *carInfoModel=dataList[sender.tag];
    NSMutableString *ss=[[NSMutableString alloc]init];
    BOOL isChoose=false;
    
    //统计结算按钮的点击事件
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"购物车",@"titleName":@"结算"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    for (int i=0;i< carInfoModel.cartlist.count ; i++) {
        CarModel *modelTemp =carInfoModel.cartlist[i];
        if(modelTemp.isSel){
            [ss appendFormat:@"%d",modelTemp.id];
            isChoose=true;
            if(i!=carInfoModel.cartlist.count-1){
                [ss appendString:@","];
            }
        }
    }
    if(!isChoose){
        [MyUtil showMessage:@"请勾选要购买的物品"];
        return;
    }
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    CHDoOrderViewController *doOrderViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHDoOrderViewController"];
    doOrderViewController.title=@"确认订单";
    doOrderViewController.ids=ss;
    [self.navigationController pushViewController:doOrderViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToCHView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
