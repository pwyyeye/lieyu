//
//  ZSOrderViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSOrderViewController.h"
#import "OrderBottomView.h"
#import "OrderHeadView.h"
#import "OrderHandleButton.h"
#import "DetailCell.h"
#import "ShopDetailmodel.h"
#import "OrderInfoModel.h"
#import "SerchHeadView.h"
#import "OrderBottomForLWView.h"
#import "OrderBottomForCCView.h"
#import "OrderBottomForXFView.h"
#import "ZSManageHttpTool.h"
#import "GoodsModel.h"
#import "IQKeyboardManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <RongIMKit/RongIMKit.h>
@interface ZSOrderViewController (){
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
}

@end
@implementation ZSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];

    
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    self.view.backgroundColor=RGB(237, 237, 237 );
    daiXiaoFei=[[NSMutableArray alloc]init];
    serchDaiXiaoFei=[[NSMutableArray alloc]init];
    self.menuView.backgroundColor=[UIColor clearColor];
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatterUp= [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatterUp setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.timeLal.text=dateStr;
    nowDate=[NSDate new];
    self.title=@"订单管理";
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    
    pageCount=1;
    perCount=10;
    
    
    [self getMenuHrizontal];
    [self getDaiXiaoFei];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    // 设置header
    //    [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer =[MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
    
    
    
    //ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
//orderstatus:
//    0－未付款
//    1-已付款
//    2-经理确认即 完成
//    3-取消/退款－－（未违约）
//    4-经理取消/退款－－（未违约）
//    5-取消/退款－－（违约）
//    6-删除
//    7－已完成
//    8-已返利
//    9-已评价
//    10-退款
//    "consumptionStatus": 0,1  0  不一定去 1 一定去
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 刷新
-(void)refreshData{
    pageCount=1;
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [self getOrderWithDic:nowDic];
    
}
#pragma mark 下拉加载更多
-(void)loadMoreData{
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [self getOrderWithDicMore:nowDic];
    
}

#pragma mark 获取更多订单数据
-(void)getOrderWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [daiXiaoFei addObjectsFromArray:result];
            pageCount++;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        
    }];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark 获取待消费数据
-(void)getOrderWithDic:(NSDictionary *)dic{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
    
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
        [daiXiaoFei addObjectsFromArray:result];
        serchDaiXiaoFei=[daiXiaoFei mutableCopy];
        
        if (mMenuHriZontal.selectIndex==0) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SerchHeadView" owner:nil options:nil];
            SerchHeadView *serchHeadView= (SerchHeadView *)[nibView objectAtIndex:0];
            [serchHeadView.serchText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [serchHeadView.serchText addTarget:self action:@selector(serchTextValChange:) forControlEvents:UIControlEventEditingChanged];
            _tableView.tableHeaderView=serchHeadView;
                
        }else{
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
            view1.backgroundColor=[UIColor whiteColor];
            _tableView.tableHeaderView=view1;
        }

        if(daiXiaoFei.count>0){
//            [weakSelf.tableView setHidden:NO];
            pageCount++;
            //            [weakSelf.tableView.mj_footer resetNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
//            [weakSelf.tableView setHidden:YES];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
    
    
    
}


#pragma mark 获取待消费数据
-(void)getDaiXiaoFei{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
//    NSString *dateStr=[dateFormatterUp stringFromDate:nowDate];
//    NSDictionary *dic=@{@"orderStatus":@"2",@"createDate":dateStr};
//    NSDictionary *dic=@{@"orderStatus":@"1,2"};
//    __weak __typeof(self)weakSelf = self;
//    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
//        [daiXiaoFei addObjectsFromArray:result];
//        serchDaiXiaoFei=[daiXiaoFei mutableCopy];
//        
//        
//        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SerchHeadView" owner:nil options:nil];
//        SerchHeadView *serchHeadView= (SerchHeadView *)[nibView objectAtIndex:0];
//        [serchHeadView.serchText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
//        [serchHeadView.serchText addTarget:self action:@selector(serchTextValChange:) forControlEvents:UIControlEventEditingChanged];
//        _tableView.tableHeaderView=serchHeadView;
//        [weakSelf.tableView reloadData];
//    }];
//    
    pageCount=1;
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"1,2"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
    
}
#pragma mark 获取待留位数据
-(void)getDaiLiuWei{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
    NSString *dateStr=[dateFormatterUp stringFromDate:nowDate];
    NSDictionary *dic=@{@"orderStatus":@"1",@"createDate":dateStr,@"consumptionStatus":@"1"};
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
        [daiXiaoFei addObjectsFromArray:result];
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view1.backgroundColor=[UIColor whiteColor];
        _tableView.tableHeaderView=view1;
        [weakSelf.tableView reloadData];
    }];
    

}
#pragma mark 获取待催促数据
-(void)getDaiCuiCu{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
    NSString *dateStr=[dateFormatterUp stringFromDate:nowDate];
    NSDictionary *dic=@{@"orderStatus":@"1",@"createDate":dateStr,@"consumptionStatus":@"0"};
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
        [daiXiaoFei addObjectsFromArray:result];
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view1.backgroundColor=[UIColor whiteColor];
        _tableView.tableHeaderView=view1;
        [weakSelf.tableView reloadData];
    }];
    
    
}
#pragma mark 搜索已消费
-(void) getYiXiaoFei{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
//    NSString *dateStr=[dateFormatterUp stringFromDate:nowDate];
//    NSDictionary *dic=@{@"orderStatus":@"7,8,9",@"createDate":dateStr};
//    NSDictionary *dic=@{@"orderStatus":@"7,8,9"};
//    __weak __typeof(self)weakSelf = self;
//    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
//        [daiXiaoFei addObjectsFromArray:result];
//        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
//        view1.backgroundColor=[UIColor whiteColor];
//        _tableView.tableHeaderView=view1;
//        [weakSelf.tableView reloadData];
//    }];
    
    pageCount=1;
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"7,8,9"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
     [self getOrderWithDic:dic];
}



#pragma mark 退款
-(void) getTuiDan{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
//    NSString *dateStr=[dateFormatterUp stringFromDate:nowDate];
//    NSDictionary *dic=@{@"orderStatus":@"3,4,5",@"createDate":dateStr};
//    NSDictionary *dic=@{@"orderStatus":@"3,4,5"};
//    __weak __typeof(self)weakSelf = self;
//    [[ZSManageHttpTool shareInstance]getZSOrderListWithParams:dic block:^(NSMutableArray *result) {
//        [daiXiaoFei addObjectsFromArray:result];
//        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
//        view1.backgroundColor=[UIColor whiteColor];
//        _tableView.tableHeaderView=view1;
//        [weakSelf.tableView reloadData];
//    }];
    
    pageCount=1;
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"3,4,5"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getOrderWithDic:dic];
    
}
#pragma mark 搜索
-(void)serchTextValChange:(UITextField *)sender{
    NSString *ss=sender.text;
    [serchDaiXiaoFei removeAllObjects];
    if([ss isEqualToString:@""]){
        serchDaiXiaoFei =[daiXiaoFei mutableCopy];
    }else{
        for (OrderInfoModel *orderInfoModel in daiXiaoFei) {
            NSString *orderNo=[NSString stringWithFormat:@"%d",orderInfoModel.id];
            
            NSRange range = [orderNo rangeOfString:ss];//匹配得到的下标
            NSLog(@"rang:%@",NSStringFromRange(range));
            if (range.length >0){
                [serchDaiXiaoFei addObject:orderInfoModel ];
            }
        }
    }
    [_tableView reloadData];
    NSLog(@"*****%@",ss);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            ////ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            if(orderInfoModel.ordertype==2){
                return orderInfoModel.goodslist.count;
            }else if(orderInfoModel.ordertype==0){
                return 1;
            }else{
                return 1;
            }
            
            break;
        }
            
//        case 1:// 待留位
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            if(orderInfoModel.ordertype==2){
//                return orderInfoModel.goodslist.count;
//            }else if(orderInfoModel.ordertype==0){
//                return 1;
//            }else{
//                return 1;
//            }
//            
//            break;
//           
//        }
//            
//        case 2:// 待催促
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            if(orderInfoModel.ordertype==2){
//                return orderInfoModel.goodslist.count;
//            }else if(orderInfoModel.ordertype==0){
//                return 1;
//            }else{
//                return 1;
//            }
//            
//            break;
//        }
            
        case 1:// 已消费
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            if(orderInfoModel.ordertype==2){
                return orderInfoModel.goodslist.count;
            }else if(orderInfoModel.ordertype==0){
                return 1;
            }else{
                return 1;
            }
            break;
        }
        default://退单
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            if(orderInfoModel.ordertype==2){
                return orderInfoModel.goodslist.count;
            }else if(orderInfoModel.ordertype==0){
                return 1;
            }else{
                return 1;
            }
            break;
        }
            
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            return serchDaiXiaoFei.count;
            break;
        }
//            
//        case 1:// 待留位
//        {
//            return daiXiaoFei.count;
//            break;
//        }
//            
//        case 2:// 待催促
//        {
//            return daiXiaoFei.count;
//            break;
//        }
            
        case 1:// 已消费
        {
            return daiXiaoFei.count;
            break;
        }
        default://退单
        {
            return daiXiaoFei.count;
            break;
        }
            
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(mMenuHriZontal.selectIndex==1){
        return 48;
    }
    if(mMenuHriZontal.selectIndex==2){
        return 48;
    }
    return 84;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(daiXiaoFei.count==0) return [[UIView alloc] initWithFrame:CGRectZero];
    
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
           
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            if (orderInfoModel.orderStatus==1) {
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForLWView" owner:nil options:nil];
                OrderBottomForLWView *orderBottomView= (OrderBottomForLWView *)[nibView objectAtIndex:0];
                orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
                [orderBottomView.kazuoBtn addTarget:self action:@selector(kazuoAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.kazuoBtn.tag=section;
                orderBottomView.siliaoBtn.tag=section;
                orderBottomView.dianhuaBtn.tag=section;
                return orderBottomView;
            }else{
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomView" owner:nil options:nil];
                OrderBottomView *orderBottomView= (OrderBottomView *)[nibView objectAtIndex:0];
                orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
                [orderBottomView.duimaBtn addTarget:self action:@selector(duimaAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
                
                [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.duimaBtn.tag=section;
                orderBottomView.siliaoBtn.tag=section;
                orderBottomView.dianhuaBtn.tag=section;
                return orderBottomView;
            }
            
            //    view.backgroundColor=[UIColor yellowColor];
            
            break;
        }
            
//        case 1:// 待留位
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            
//            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForLWView" owner:nil options:nil];
//            OrderBottomForLWView *orderBottomView= (OrderBottomForLWView *)[nibView objectAtIndex:0];
//            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
//            [orderBottomView.kazuoBtn addTarget:self action:@selector(kazuoAct:) forControlEvents:UIControlEventTouchUpInside];
//            [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
//            [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
//            orderBottomView.kazuoBtn.tag=section;
//            orderBottomView.siliaoBtn.tag=section;
//            orderBottomView.dianhuaBtn.tag=section;
//            //    view.backgroundColor=[UIColor yellowColor];
//            return orderBottomView;
//            break;
//        }
            
//        case 2:// 待催促
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            
//            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForCCView" owner:nil options:nil];
//            OrderBottomForCCView *orderBottomView= (OrderBottomForCCView *)[nibView objectAtIndex:0];
//            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
//            [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
//            [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
//            orderBottomView.siliaoBtn.tag=section;
//            orderBottomView.dianhuaBtn.tag=section;
//            //    view.backgroundColor=[UIColor yellowColor];
//            return orderBottomView;
//            break;
//        }
            
        case 1:// 已消费
        {
            
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForXFView" owner:nil options:nil];
            OrderBottomForXFView *orderBottomView= (OrderBottomForXFView *)[nibView objectAtIndex:0];
            orderBottomView.fukuanLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            orderBottomView.jiesuanLal.text=[NSString stringWithFormat:@"￥%.2f",orderInfoModel.amountPay.doubleValue- orderInfoModel.rebateAmout.doubleValue];
            orderBottomView.yjLal.text=[NSString stringWithFormat:@"佣金:￥%@",orderInfoModel.commission];
            //    view.backgroundColor=[UIColor yellowColor];
            return orderBottomView;
            break;
        }
        default://退单
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForXFView" owner:nil options:nil];
            OrderBottomForXFView *orderBottomView= (OrderBottomForXFView *)[nibView objectAtIndex:0];
            orderBottomView.titleOneLal.text=@"实际退款";
            orderBottomView.titleTwoLal.textColor=RGB(234, 79, 79);
            if(orderInfoModel.orderStatus==5){
                orderBottomView.titleTwoLal.text=@"已违约（违约金）";
                orderBottomView.jiesuanLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.penalty];
            }else{
                orderBottomView.titleTwoLal.text=@"未违约";
            }
            orderBottomView.fukuanLal.text=[NSString stringWithFormat:@"￥%.2f",orderInfoModel.amountPay.doubleValue- orderInfoModel.penalty.doubleValue];
            
//            if(orderInfoModel.isWeiYue){
//                orderBottomView.titleTwoLal.text=@"已违约（违约金）";
//                orderBottomView.jiesuanLal.text=orderInfoModel.jiesuanmoney;
//            }else{
//                orderBottomView.titleTwoLal.text=@"未违约";
//                
//            }
//            
//            orderBottomView.fukuanLal.text=orderInfoModel.money;
            
            //    view.backgroundColor=[UIColor yellowColor];
            return orderBottomView;
            break;
        }
            
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(daiXiaoFei.count==0) return [[UIView alloc] initWithFrame:CGRectZero];
    //ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
            if (orderInfoModel.orderStatus==1) {
                OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
                orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
                orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
                orderHeadView.nameLal.text=orderInfoModel.username;
                orderHeadView.userImgeView.layer.masksToBounds =YES;
                orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
                NSString *str=orderInfoModel.avatar_img ;
                [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
                //
                if(orderInfoModel.ordertype==0){
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
                    orderHeadView.detLal.text=orderInfoModel.reachtime;
                }else if(orderInfoModel.ordertype==1){
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
                    orderHeadView.detLal.text=orderInfoModel.reachtime;
                }else{
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
                }
                [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"zuo"]];
            }else{
                orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
                orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
                orderHeadView.nameLal.text=orderInfoModel.username;
                orderHeadView.userImgeView.layer.masksToBounds =YES;
                orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
                NSString *str=orderInfoModel.avatar_img ;
                [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
                //
                if(orderInfoModel.ordertype==0){
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
                    orderHeadView.detLal.text=orderInfoModel.reachtime;
                }else if(orderInfoModel.ordertype==1){
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
                    orderHeadView.detLal.text=orderInfoModel.reachtime;
                }else{
                    [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
                }
                [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"orderDai"]];
            }
            
//            orderHeadView.detLal.text=orderInfoModel.paytime;
            //    view.backgroundColor=[UIColor yellowColor];
            return orderHeadView;
            break;
        }
            
//        case 1:// 待留位
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            
//            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
//            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
//            orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
//            orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
//            orderHeadView.nameLal.text=orderInfoModel.username;
//            orderHeadView.userImgeView.layer.masksToBounds =YES;
//            orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
//            NSString *str=orderInfoModel.avatar_img ;
//            [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
//            //
//            if(orderInfoModel.ordertype==0){
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
//                orderHeadView.detLal.text=orderInfoModel.reachtime;
//            }else if(orderInfoModel.ordertype==1){
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
//                orderHeadView.detLal.text=orderInfoModel.reachtime;
//            }else{
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
//            }
//            [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"zuo"]];
////            orderHeadView.nameLal.text=orderInfoModel.name;
////            
////            orderHeadView.detLal.text=orderInfoModel.paytime;
//            //    view.backgroundColor=[UIColor yellowColor];
//            return orderHeadView;
//            break;
//        }
            
//        case 2:// 待催促
//        {
//            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
//            
//            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
//            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
//            orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
////            orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
//            orderHeadView.nameLal.text=orderInfoModel.username;
//            orderHeadView.userImgeView.layer.masksToBounds =YES;
//            orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
//            NSString *str=orderInfoModel.avatar_img ;
//            [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
//            //
//            if(orderInfoModel.ordertype==0){
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
//                orderHeadView.detLal.text=orderInfoModel.reachtime;
//            }else if(orderInfoModel.ordertype==1){
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
//                orderHeadView.detLal.text=orderInfoModel.reachtime;
//            }else{
//                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
//            }
//            [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"cui"]];
////            orderHeadView.nameLal.text=orderInfoModel.name;
//            
//            //            orderHeadView.detLal.text=orderInfoModel.paytime;
//            //    view.backgroundColor=[UIColor yellowColor];
//            return orderHeadView;
//            break;
//        }
            
        case 1:// 已消费
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
            orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
            orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
            orderHeadView.nameLal.text=orderInfoModel.username;
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *consumptionCode=[MyUtil decryptUseDES:orderInfoModel.consumptionCode withKey:app.desKey];
            orderHeadView.detLal.text=[NSString stringWithFormat:@"消费码:%@",consumptionCode];
            orderHeadView.userImgeView.layer.masksToBounds =YES;
            orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
            NSString *str=orderInfoModel.avatar_img ;
            [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
            //
            if(orderInfoModel.ordertype==0){
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
                orderHeadView.detLal.text=orderInfoModel.reachtime;
            }else if(orderInfoModel.ordertype==1){
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
                orderHeadView.detLal.text=orderInfoModel.reachtime;
            }else{
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
            }
            [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"wan"]];
//            orderHeadView.nameLal.text=orderInfoModel.name;
//            orderHeadView.detLal.text=orderInfoModel.paytime;
            //            orderHeadView.detLal.text=orderInfoModel.paytime;
            //    view.backgroundColor=[UIColor yellowColor];
            return orderHeadView;
            break;
        }
        default://退单
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
            orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *consumptionCode=[MyUtil decryptUseDES:orderInfoModel.consumptionCode withKey:app.desKey];
            orderHeadView.nameLal.text=[NSString stringWithFormat:@"消费码:%@",consumptionCode];
            orderHeadView.nameLal.text=orderInfoModel.username;
            orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
            orderHeadView.userImgeView.layer.masksToBounds =YES;
            orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
            NSString *str=orderInfoModel.avatar_img ;
            [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
            //
            if(orderInfoModel.ordertype==0){
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
                orderHeadView.detLal.text=orderInfoModel.reachtime;
            }else if(orderInfoModel.ordertype==1){
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
                orderHeadView.detLal.text=orderInfoModel.reachtime;
            }else{
                [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
            }
            if(orderInfoModel.orderStatus==5){
                [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"tui"]];
            }else{
                [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"wei"]];
            }
            
//            orderHeadView.nameLal.text=orderInfoModel.name;
//            orderHeadView.detLal.text=orderInfoModel.paytime;
            //            orderHeadView.detLal.text=orderInfoModel.paytime;
            //    view.backgroundColor=[UIColor yellowColor];
            return orderHeadView;
            break;
        }
            
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DetailCell";
    
    DetailCell *cell = (DetailCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DetailCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    OrderInfoModel *orderInfoModel;
    ShopDetailmodel *shopDetailmodel=[[ShopDetailmodel alloc]init];
    if(mMenuHriZontal.selectIndex==0){
        orderInfoModel=serchDaiXiaoFei[indexPath.section];

    }else{
        orderInfoModel=daiXiaoFei[indexPath.section];
    }
    
    NSLog(@"******套餐类型%@*****",[NSString stringWithFormat:@"%d",orderInfoModel.ordertype ]);
    if(orderInfoModel.ordertype==0){
    //0-－套餐订单
        
        
        SetMealInfoModel *setMealInfoModel=orderInfoModel.setMealInfo;
        SetMealVOModel *setMealVOModel=setMealInfoModel.setMealVO;
        shopDetailmodel.name=setMealInfoModel.fullName;
        shopDetailmodel.img=setMealVOModel.linkUrl;
        shopDetailmodel.youfeiPrice=setMealVOModel.price;
        shopDetailmodel.money=setMealVOModel.marketprice;
        shopDetailmodel.count=[NSString stringWithFormat:@"[适合%@-%@人]",setMealVOModel.minnum,setMealVOModel.maxnum];
    }else if(orderInfoModel.ordertype==1){
    //拼客订单
        
        SetMealVOModel *setMealVOModel=orderInfoModel.pinkerinfo;
        shopDetailmodel.name=setMealVOModel.smname;
        shopDetailmodel.img=setMealVOModel.linkUrl;
        shopDetailmodel.youfeiPrice=setMealVOModel.price;
        shopDetailmodel.money=setMealVOModel.marketprice;
        if(mMenuHriZontal.selectIndex==1||mMenuHriZontal.selectIndex==2){
//            shopDetailmodel.count=[NSString stringWithFormat:@"拼客人数%@（%d人参与）",orderInfoModel.allnum,(int)orderInfoModel.pinkerList.count];
            shopDetailmodel.count=[NSString stringWithFormat:@"拼客人数%@",orderInfoModel.allnum];
        }else{
            shopDetailmodel.count=[NSString stringWithFormat:@"%@人拼客",orderInfoModel.allnum];
        }
        
    }else{
        //吃喝订单
        NSArray *arr=orderInfoModel.goodslist;
        NSDictionary *dicTemp=arr[indexPath.row];
        GoodsModel *goodsModel=[GoodsModel mj_objectWithKeyValues:dicTemp];
        ProductVOModel *productVOModel=goodsModel.productVO;
        shopDetailmodel.name=goodsModel.fullName;
        shopDetailmodel.img=productVOModel.image;
        shopDetailmodel.youfeiPrice=productVOModel.price;
        shopDetailmodel.money=productVOModel.marketprice;
        shopDetailmodel.count=[NSString stringWithFormat:@"X%@",goodsModel.quantity];
    }
    
    cell.nameLal.text=shopDetailmodel.name;
    cell.countLal.text=shopDetailmodel.count;
    if(mMenuHriZontal.selectIndex==0){
        cell.countLal.text=shopDetailmodel.count;
    }else if(mMenuHriZontal.selectIndex==1){
        cell.countLal.text=shopDetailmodel.count;
    }
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",shopDetailmodel.youfeiPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",shopDetailmodel.money] attributes:attribtDic];
    cell.moneylal.attributedText=attribtStr;
    NSString *str=shopDetailmodel.img ;
    [cell.detImageView setImageWithURL:[NSURL URLWithString:str]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSArray *menuArrNew=@[@"待处理",@"已消费",@"退单"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/3), 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGBA(186, 40, 227, 1) set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject:normalImg forKey:NOMALKEY];
        
        // 使用颜色创建UIImage //选中颜色
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject: selectedImg forKey:HEIGHTKEY];
        [itemTemp setObject: ss forKey:TITLEKEY];
//        [itemTemp setObject:[NSNumber numberWithFloat:self.view.width/5]  forKey:TITLEWIDTH];
        [itemTemp setObject:[NSNumber numberWithFloat:SCREEN_WIDTH/3]  forKey:TITLEWIDTH];
        [itemTemp setObject:@"88"  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }

    if (mMenuHriZontal == nil) {
//        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:self.menuView.frame ButtonItems:barArr];
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.menuView.frame)) ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];

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
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    switch (aIndex) {
            
        case 0://待消费
        {
            [self getDaiXiaoFei];
            break;
        }
            
//        case 1:// 待留位
//        {
//            [self getDaiLiuWei];
//            break;
//        }
//            
//        case 2:// 待催促
//        {
//            [self getDaiCuiCu];
//            break;
//        }
            
        case 1:// 已消费
        {
            [self getYiXiaoFei];
            break;
        }
        default://退单
        {
            [self getTuiDan];
            break;
        }
            
    }
    
}
#pragma mark 对码
-(void)duimaAct:(OrderHandleButton *)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"XiaoFeiMaUiew" owner:nil options:nil];
    xiaoFeiMaUiew= (XiaoFeiMaUiew *)[nibView objectAtIndex:0];
    xiaoFeiMaUiew.top=-xiaoFeiMaUiew.height;
    xiaoFeiMaUiew.width=SCREEN_WIDTH;
    [xiaoFeiMaUiew.xiaofeiMaTextField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    xiaoFeiMaUiew.xiaofeiMaTextField.tag=sender.tag;
    xiaoFeiMaUiew.xiaofeiMaTextField.keyboardType = UIKeyboardTypeNumberPad;
    xiaoFeiMaUiew.xiaofeiMaTextField.returnKeyType=UIReturnKeyDone;
    xiaoFeiMaUiew.xiaofeiMaTextField.delegate=self;
    [xiaoFeiMaUiew.xiaofeiMaTextField setCustomDoneTarget:self action:@selector(duimaReturn:)];
    [_bgView addSubview:xiaoFeiMaUiew];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:xiaoFeiMaUiew cache:NO];
    xiaoFeiMaUiew.top=0;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,xiaoFeiMaUiew.top+xiaoFeiMaUiew.height, SCREEN_WIDTH, SCREEN_HEIGHT-xiaoFeiMaUiew.top);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappearForDuiMa:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];

}
#pragma mark return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self SetViewDisappearForDuiMa:nil];
    //对码
    if ([MyUtil isEmptyString:textField.text]) {
        return YES;
    }
    OrderInfoModel *orderInfoModel=serchDaiXiaoFei[textField.tag];
    
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id],@"consumptionCode":textField.text};
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] setManagerConfirmOrderWithParams:dic complete:^(BOOL result) {
        if(result){
            [weakSelf showMessage:@"消费码兑换成功！"];
            [weakSelf getDaiXiaoFei];
        }
    }];
    return YES;
}

- (void)duimaReturn:(UITextField *)textField{
    [self SetViewDisappearForDuiMa:nil];
    //对码
    if ([MyUtil isEmptyString:textField.text]) {
        return;
    }
    OrderInfoModel *orderInfoModel=serchDaiXiaoFei[textField.tag];
    
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id],@"consumptionCode":textField.text};
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] setManagerConfirmOrderWithParams:dic complete:^(BOOL result) {
        if(result){
            [weakSelf showMessage:@"消费码兑换成功！"];
            [weakSelf getDaiXiaoFei];
        }
    }];
}

#pragma mark 私聊
-(void)siliaoAct:(OrderHandleButton *)sender{
    OrderInfoModel *orderInfoModel;
    if(mMenuHriZontal.selectIndex==0){
        orderInfoModel=serchDaiXiaoFei[sender.tag];
    }else{
        orderInfoModel=daiXiaoFei[sender.tag];
    }
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = orderInfoModel.imuserid; // 接收者的 targetId，这里为举例。
    conversationVC.userName =orderInfoModel.username; // 接受者的 username，这里为举例。
    conversationVC.title =orderInfoModel.username; // 会话的 title。
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    // 把单聊视图控制器添加到导航栈。
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
//    conversationVC.navigationItem.leftBarButtonItem = left;
//    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    conversationVC.navigationItem.leftBarButtonItem = item;

    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 电话
-(void)dianhuaAct:(OrderHandleButton *)sender{
    OrderInfoModel *orderInfoModel;
    if(mMenuHriZontal.selectIndex==0){
        orderInfoModel=serchDaiXiaoFei[sender.tag];
    }else{
        orderInfoModel=daiXiaoFei[sender.tag];
    }
    
    
    if( [MyUtil isPureInt:orderInfoModel.phone]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",orderInfoModel.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}
#pragma mark 卡座
-(void)kazuoAct:(OrderHandleButton *)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"KaZuoView" owner:nil options:nil];
    kaZuoView= (KaZuoView *)[nibView objectAtIndex:0];
    kaZuoView.top=SCREEN_HEIGHT;
    [kaZuoView.SureBtn addTarget:self action:@selector(SetViewDisappearForKaZuoSure:) forControlEvents:UIControlEventTouchDown];
//    kaZuoView.frame = CGRectMake(0, SCREEN_HEIGHT - 129, SCREEN_WIDTH, 129);
    kaZuoView.width = SCREEN_WIDTH;
    [_bgView addSubview:kaZuoView];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:kaZuoView cache:NO];
    kaZuoView.top=SCREEN_HEIGHT-kaZuoView.height-64;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-kaZuoView.height-64);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappearForKaZuo:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
}

- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)timeChooseAct:(UIButton *)sender {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    
    [self.view addSubview:_bgView];

    self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 266+45)];
    self.calendarView.draggble = YES;
    
    
    /*
    //左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToPreviousMonth:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [_bgView addGestureRecognizer:swipeLeft];
    
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextMonth:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [_bgView addGestureRecognizer:swipeRight];
    */
    [_bgView addSubview:self.calendarView];
    
    
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    [self.calendarLogic reloadCalendarView:self.calendarView];
    surebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT+50+266+45, SCREEN_WIDTH,45 );
    [surebutton setBackgroundColor:RGB(114, 5, 147)];
    [surebutton setTitle:@"确定" forState:0];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [surebutton addTarget:self action:@selector(SetViewDisappearForSure:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:surebutton aboveSubview:_bgView];
    
    //上下月
    monView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    monView.backgroundColor=[UIColor whiteColor];
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preBtn.frame = (CGRect){25, 3, 60, 44};
    [preBtn addTarget:self action:@selector(goToPreviousMonth:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [monView addSubview:preBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = (CGRect){SCREEN_WIDTH - 85, 3, 60, 44};
    [nextBtn addTarget:self action:@selector(goToNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [monView addSubview:nextBtn];
    
    CGRect labelRect = (CGRect){SCREEN_WIDTH / 2 - 50, 3, 100, 44};
    self.monthLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    self.monthLabel.textColor = [UIColor blackColor];
    [monView addSubview:self.monthLabel];
    [_bgView insertSubview:monView aboveSubview:_bgView];
    
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.calendarView cache:NO];
    monView.frame=CGRectMake(0, SCREEN_HEIGHT-266-45-50, SCREEN_WIDTH, 50);
    self.calendarView.frame= CGRectMake(0, SCREEN_HEIGHT-266-45, SCREEN_WIDTH, 266+45);
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT-45, SCREEN_WIDTH,45 );
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-266-45-50);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
    
    
//    button.backgroundColor=[UIColor clearColor];
}
//
-(void)SetViewDisappear:(id)sender
{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             self.calendarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
-(void)SetViewDisappearForSure:(id)sender{
    
    self.timeLal.text=[dateFormatter stringFromDate:[self.calendarLogic.selectedCalendarDay date]];
    nowDate=[self.calendarLogic.selectedCalendarDay date];
    [self SetViewDisappear:sender];
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            ////ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
            [self getDaiXiaoFei];
            
            break;
        }
//            
//        case 1:// 待留位
//        {
//            [self getDaiLiuWei];
//            break;
//            
//        }
//            
//        case 2:// 待催促
//        {
//            [self getDaiCuiCu];
//            break;
//        }
            
        case 1:// 已消费
        {
            [self getDaiXiaoFei];
            
            break;
        }
        default://退单
        {
            [self getTuiDan];
            
            break;
        }
            
    }
    
//    if (_bgView)
//    {
//        _bgView.backgroundColor=[UIColor clearColor];
//        [UIView animateWithDuration:.5
//                         animations:^{
//                             
//                             self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
//                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
//                             _bgView.alpha=0.0;
//                         }];
//        [_bgView performSelector:@selector(removeFromSuperview)
//                      withObject:nil
//                      afterDelay:2];
//        
//        
//    }
}
-(void)SetViewDisappearForDuiMa:(id)sender{
    
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             xiaoFeiMaUiew.top=-xiaoFeiMaUiew.height;
                             _bgView.frame=CGRectMake(0, -SCREEN_HEIGHT, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
-(void)SetViewDisappearForKaZuoSure:(UIButton *)sender{
    [self SetViewDisappearForKaZuo:sender];
    OrderInfoModel *orderInfoModel=daiXiaoFei[sender.tag];
    __weak __typeof(self)weakSelf = self;
    if(kaZuoView.YesKaZuoBtn.selected==true){
        //留座位
        NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
        
        [[ZSManageHttpTool shareInstance] setManagerConfirmSeatWithParams:dic complete:^(BOOL result) {
            if(result){
                [weakSelf showMessage:@"留座成功！"];
                [weakSelf getDaiLiuWei];
            }
        }];
    }else{
        //取消订单
        NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
        
        [[ZSManageHttpTool shareInstance] setMangerCancelWithParams:dic complete:^(BOOL result) {
            if(result){
                [weakSelf showMessage:@"取消订单成功！"];
                [weakSelf getDaiLiuWei];
            }
        }];

    }
    
}
-(void)SetViewDisappearForKaZuo:(id)sender{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             kaZuoView.top=SCREEN_HEIGHT;
                             _bgView.frame=CGRectMake(0,SCREEN_HEIGHT, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
}
#pragma mark -

- (void)goToNextMonth:(id)sender
{
    [self.calendarLogic goToNextMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    

}

- (void)goToPreviousMonth:(id)sender
{
    [self.calendarLogic goToPreviousMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    

}
-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
}
-(void)dealloc{
    _bgView=nil;
    monView=nil;
    dateFormatter=nil;
    surebutton=nil;
    mMenuHriZontal=nil;
    daiXiaoFei=nil;
    serchDaiXiaoFei=nil;
    xiaoFeiMaUiew=nil;
    kaZuoView=nil;
}
@end
