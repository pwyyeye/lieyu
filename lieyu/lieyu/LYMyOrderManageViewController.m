//
//  LYMyOrderManageViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyOrderManageViewController.h"

#import "LYUserHttpTool.h"
#import "UIImage+GIF.h"
#import "OrderInfoModel.h"
#import "LYOrderBottomView.h"
#import "LYOrderBottomForFinishView.h"
#import "OrderHeadView.h"
#import "OrderDetailCell.h"
#import "ShopDetailmodel.h"
#import "PinkInfoModel.h"
#import "GoodsModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderHandleButton.h"
#import <RongIMKit/RongIMKit.h>
#import "LYOrderDetailViewController.h"
#import "UMSocial.h"
#import "UserModel.h"
#import "ChoosePayController.h"
#import "LYEvaluationController.h"
#import "IQKeyboardManager.h"
#import "PinkerShareController.h"

@interface LYMyOrderManageViewController ()

@end

@implementation LYMyOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn_yue addTarget:self action:@selector(jumpToYue) forControlEvents:UIControlEventTouchUpInside];
    self.btn_yue.layer.cornerRadius = 5;
    self.btn_yue.layer.masksToBounds = YES;  
    
    //自定义返回
//    UIImage *buttonImage = [UIImage imageNamed:@"btn_back"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
//    [button addTarget:self action: @selector(gotoBack)
//     forControlEvents:UIControlEventTouchUpInside];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
//    [view addSubview:button];
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
//    self.navigationItem.leftBarButtonItem = customBarItem;
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = left;
    self.title=@"我的订单";
    pageCount=1;
    perCount=5;
    [self.tableView setHidden:YES];
    [self.nodataView setHidden:NO];
    [self.kongImageView setImage:[UIImage sd_animatedGIFNamed:@"gouGif"]];
    dataList=[[NSMutableArray alloc]init];
    [self getMenuHrizontal];
    
    
    __weak LYMyOrderManageViewController *weakSelf = self;
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
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    switch (_orderType) {
        case 0:
            [self getAllOrder];
            break;
        case 1:
            [self getDaiFuKuan];
            break;
        case 2:
            [self getDaiXiaoFei];
            break;
        case 3:
            [self getDaiPingjia];
            break;
        case 4:
            [self getDaiFanLi];
            break;
        case 5:
            [self getTuiDan];
            break;
        default:
            break;
    }
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
}

//-(void)BaseGoBack{
//    for (UIViewController *viewController in self.navigationController.viewControllers) {
//        if([viewController isKindOfClass:[LYMyOrderManageViewController class]]){
//            [self.navigationController popToViewController:viewController animated:YES];
//            return;
//        }
//    }
//    LYMyOrderManageViewController *detailViewController =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
//    [self.navigationController pushViewController:detailViewController animated:YES];
//}


- (void)dealloc{
    NSLog(@"----->dealloc");
}

- (void)jumpToYue{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFirstViewController" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden=NO;
        [self.navigationController setNavigationBarHidden:NO];
    }

}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)BaseGoBack{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChoosePayController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        if ([controller isKindOfClass:[PinkerShareController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
//    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[ChoosePayController class]]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else{
       [self.navigationController popViewControllerAnimated:YES];
//    }
    
    

    
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
#pragma mark 获取所有订单数据
-(void)getAllOrder{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount]};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取待付款数据
-(void)getDaiFuKuan{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"0"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取待消费数据
-(void)getDaiXiaoFei{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"1,2"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取已返利数据
-(void)getYiFanLi{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"8,9"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取待评价数据
-(void)getDaiPingjia{
    pageCount=1;
    //    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"8"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}


#pragma mark 获取待返利数据
-(void)getDaiFanLi{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"7"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取退款数据
-(void)getTuiDan{
    pageCount=1;
//    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"orderStatus":@"3,4,5,10"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    
    [self getOrderWithDic:dic];
}
#pragma mark 获取订单数据
-(void)getOrderWithDic:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyOrderListWithParams:dic block:^(NSMutableArray *result) {
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        if(dataList.count>0){
            [weakSelf.tableView setHidden:NO];
            [weakSelf.nodataView setHidden:YES];
            pageCount++;
//            [weakSelf.tableView.mj_footer resetNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
            [weakSelf.tableView setHidden:YES];
            [weakSelf.nodataView setHidden:NO];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        
        
        
    }];
    [self.tableView.mj_header endRefreshing];
    
    
}
#pragma mark 获取更多订单数据
-(void)getOrderWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyOrderListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView.mj_footer noticeNoMoreData];
        }
        
        
        
    }];
    [self.tableView.mj_footer endRefreshing];
    
}
#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSArray *menuArrNew=@[@"订单",@"待付款",@"待消费",@"待评价",@"待返利",@"退款"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5.5), 34);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGBA(153, 50, 204, 1) set];
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
        [itemTemp setObject:[NSNumber numberWithFloat:SCREEN_WIDTH/5.5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@""  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(_menuView.origin.x, _menuView.origin.y, SCREEN_WIDTH, _menuView.frame.size.height) ButtonItems:barArr andOrderType:_orderType];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderInfoModel *orderInfoModel=dataList[section];
    if(orderInfoModel.ordertype==2){
        return orderInfoModel.goodslist.count;
    }else if(orderInfoModel.ordertype==0){
        return 1;
    }else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    OrderInfoModel *orderInfoModel=dataList[section];
    if( orderInfoModel.orderStatus == 7 || orderInfoModel.orderStatus == 3 || orderInfoModel.orderStatus == 4
       || orderInfoModel.orderStatus == 5 || orderInfoModel.orderStatus == 10){
         return 90;
    }
    
    return 134;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
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
    OrderInfoModel *orderInfoModel=dataList[section];
    
    //订单状态是 3  4   5 10 7 的底部不一样
    if( orderInfoModel.orderStatus == 7 || orderInfoModel.orderStatus == 3 || orderInfoModel.orderStatus == 4
       || orderInfoModel.orderStatus == 5 || orderInfoModel.orderStatus == 10){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYOrderBottomForFinishView" owner:nil options:nil];
        LYOrderBottomForFinishView *orderBottomView= (LYOrderBottomForFinishView *)[nibView objectAtIndex:0];
        BOOL isFaqi=false;
        if(orderInfoModel.ordertype==1){
            //拼客
            //判断是否发起人
            
            
            if(orderInfoModel.userid==self.userModel.userid){
                isFaqi=true;
            }
        }
        if(orderInfoModel.orderStatus==7 ){
            if(orderInfoModel.ordertype==1){
                NSString *moneyStr=@"0";
                NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
                if(pinkerList.count>0){
                    for (PinkInfoModel *pinkInfoModel in pinkerList) {
                        if(pinkInfoModel.inmember==self.userModel.userid){
                            if(pinkInfoModel.paymentStatus==1){
                                moneyStr=pinkInfoModel.price;
                            }
                        }
                    }
                }
                orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",moneyStr];
                if(!isFaqi){
                    orderBottomView.miaosuCenterLal.text=@"消费完成等待系统确定";
                }else{
                    
                    orderBottomView.miaosuCenterLal.text=@"猎娱承诺返利金额会予以3个工作日发放个人账户中";
                }
            }else{
                orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
                orderBottomView.miaosuCenterLal.text=@"猎娱承诺返利金额会予以3个工作日发放个人账户中";
            }
            
        }else{
            orderBottomView.titleLal.text=@"交易金额";
            orderBottomView.titleTwoLal.text=@"退款金额";
            [orderBottomView.titleTwoLal setHidden:false];
            orderBottomView.moneyOnelal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            [orderBottomView.moneyOnelal setHidden:false];
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%.2f",orderInfoModel.amountPay.doubleValue- orderInfoModel.penalty.doubleValue];
            if(orderInfoModel.ordertype==1){
                NSString *moneyStr=@"0";
                
                NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
                if(pinkerList.count>0){
                    for (PinkInfoModel *pinkInfoModel in pinkerList) {
                        if(pinkInfoModel.inmember==self.userModel.userid){
                            if(pinkInfoModel.paymentStatus==1){
                                moneyStr=pinkInfoModel.price;
                                
                            }
                        }
                    }
                }
                orderBottomView.moneyOnelal.text=[NSString stringWithFormat:@"￥%@",moneyStr];
                if(isFaqi){
                    
                    orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%.2f",moneyStr.doubleValue-orderInfoModel.penalty.doubleValue];
                }else{
                    
                    orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",moneyStr];
                }
            }
            if(orderInfoModel.penalty.doubleValue<0.1){
                orderBottomView.deTitleOne.text=@"未违约";
            }else{
                
                if(orderInfoModel.ordertype==1){
                    if(isFaqi){
                        orderBottomView.deTitleOne.text=@"违约金:";
                        orderBottomView.weiyuejinLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.penalty];
                    }else{
                       orderBottomView.deTitleOne.text=@"未违约";
                    }
                }else{
                    orderBottomView.deTitleOne.text=@"违约金:";
                    orderBottomView.weiyuejinLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.penalty];
                }
            }
            if(orderInfoModel.orderStatus==10){
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView setHidden:false];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else{
                orderBottomView.delTitelTwoLal.text=@"待退款";
                
            }
        }
        
//        [orderBottomView.duimaBtn addTarget:self action:@selector(duimaAct:) forControlEvents:UIControlEventTouchUpInside];
//        [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
//        orderBottomView.duimaBtn.tag=section;
//        orderBottomView.siliaoBtn.tag=section;
//        orderBottomView.dianhuaBtn.tag=section;
        //    view.backgroundColor=[UIColor yellowColor];
        return orderBottomView;
    }else{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYOrderBottomView" owner:nil options:nil];
        LYOrderBottomView *orderBottomView= (LYOrderBottomView *)[nibView objectAtIndex:0];
        
        [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
        [orderBottomView.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
        orderBottomView.phoneBtn.tag=section;
        orderBottomView.siliaoBtn.tag=section;
        orderBottomView.zsUserImageView.layer.masksToBounds =YES;
        orderBottomView.zsUserImageView.layer.cornerRadius =orderBottomView.zsUserImageView.width/2;
        
        
        //根据订单类型 订单状态设置底部按钮
        if(orderInfoModel.ordertype==0){
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            NSString *str=orderInfoModel.checkUserAvatar_img ;
            [orderBottomView.zsUserImageView setImageWithURL:[NSURL URLWithString:str]];
            orderBottomView.zsUserNameLal.text=orderInfoModel.checkUserName;
            if(orderInfoModel.orderStatus==0){
                [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.secondBtn setTitle:@"立即付款" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
                
            }else if(orderInfoModel.orderStatus==1){
                if(orderInfoModel.consumptionStatus==0){
                    [orderBottomView.oneBtn setTitle:@"取消订单" forState:0];
                    [orderBottomView.oneBtn setHidden:NO];
                    [orderBottomView.oneBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    [orderBottomView.secondBtn setTitle:@"一定会去" forState:UIControlStateSelected];
                    orderBottomView.secondBtn.selected=YES;
                    [orderBottomView.secondBtn addTarget:self action:@selector(yiDinHuiQuAct:) forControlEvents:UIControlEventTouchUpInside];
                    orderBottomView.oneBtn.tag=section;
                    orderBottomView.secondBtn.tag=section;
                }else{
                    [orderBottomView.miaosuLal setHidden:YES];
                    [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                    [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    orderBottomView.secondBtn.tag=section;
                }
                
            }else if(orderInfoModel.orderStatus==2){
                [orderBottomView.miaosuLal setHidden:NO];
                [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==9 ){
                
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }
            //订单为8 待评价
            if (orderInfoModel.orderStatus==8) {
                [orderBottomView.secondBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                orderBottomView.secondBtn.tag=section;
                [orderBottomView.secondBtn addTarget:self action:@selector(gotoPingjia:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setHidden:NO];
                [orderBottomView.oneBtn setHidden:YES];
            }
        }else if(orderInfoModel.ordertype==1){
            //拼客
            //判断是否发起人
            BOOL isFaqi=false;
            
            if(orderInfoModel.userid==self.userModel.userid){
                isFaqi=true;
            }
            bool isfu=false;
            NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
            NSString *moneyStr=@"0";
            if(pinkerList.count>0){
                for (PinkInfoModel *pinkInfoModel in pinkerList) {
                    if(pinkInfoModel.inmember==self.userModel.userid){
                        moneyStr=pinkInfoModel.price;
                        if(pinkInfoModel.paymentStatus==1){
                            isfu=true;
                            
                        }
                    }
                }
            }
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",moneyStr];
            if(isFaqi){
                NSString *str=orderInfoModel.checkUserAvatar_img;
                [orderBottomView.zsUserImageView setImageWithURL:[NSURL URLWithString:str]];
                orderBottomView.zsUserNameLal.text=orderInfoModel.checkUserName;
            }else{
                NSString *str=orderInfoModel.avatar_img ;
                [orderBottomView.zsUserImageView setImageWithURL:[NSURL URLWithString:str]];
                orderBottomView.zsUserNameLal.text=orderInfoModel.username;
            }
            
            //订单为8 待评价
            if (orderInfoModel.orderStatus==8&&isFaqi) {
                [orderBottomView.secondBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                orderBottomView.secondBtn.tag=section;
                [orderBottomView.secondBtn addTarget:self action:@selector(gotoPingjia:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setHidden:NO];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.oneBtn setHidden:YES];
            }
            
            if(orderInfoModel.orderStatus==0){
                
                if(isFaqi){
                    if(isfu){
                        BOOL isFree=NO;//是否免费发起
                        NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
                        for (PinkInfoModel *pinkInfoModel in pinkerList) {
                            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

                            if(pinkInfoModel.inmember==app.userModel.userid){
                                if (pinkInfoModel.price.doubleValue==0.0) {
                                    isFree=YES;
                                }
                            }
                        }
                        [orderBottomView.oneBtn setTitle:isFree?@"删除订单":@"取消订单" forState:0];
                        [orderBottomView.oneBtn setHidden:NO];
                        if (isFree) {
                            [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            [orderBottomView.oneBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        if(orderInfoModel.pinkerList.count<orderInfoModel.allnum.intValue){
                            [orderBottomView.secondBtn setTitle:@"立即拼客" forState:UIControlStateSelected];
                            orderBottomView.secondBtn.selected=YES;
                            [orderBottomView.secondBtn addTarget:self action:@selector(pinkeAct:) forControlEvents:UIControlEventTouchUpInside];
                            NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"订单详情",@"titleName":@"立即拼客"};
                            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
//                            [orderBottomView.secondBtn addTarget:self action:@selector(pinkeAct:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            [orderBottomView.secondBtn setTitle:[NSString stringWithFormat:@"%@人",orderInfoModel.allnum] forState:UIControlStateSelected];
                            orderBottomView.secondBtn.selected=YES;
                            
                        }
                        
                        
                        orderBottomView.oneBtn.tag=section;
                        orderBottomView.secondBtn.tag=section;
                    }else{
                        [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                        [orderBottomView.oneBtn setHidden:NO];
                        [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                        [orderBottomView.secondBtn setTitle:@"立即付款" forState:UIControlStateSelected];
                        orderBottomView.secondBtn.selected=YES;
                        [orderBottomView.secondBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                        orderBottomView.oneBtn.tag=section;
                        orderBottomView.secondBtn.tag=section;
                    }
                }else{
                    if(isfu){
                        [orderBottomView.secondBtn setTitle:[NSString stringWithFormat:@"%d人",orderInfoModel.pinkerCount] forState:UIControlStateSelected];
                        orderBottomView.secondBtn.selected=YES;
                        
                        
                    }else{
                        [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                        [orderBottomView.oneBtn setHidden:NO];
                        [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanByCanYuAct:) forControlEvents:UIControlEventTouchUpInside];
                        [orderBottomView.secondBtn setTitle:@"立即付款" forState:UIControlStateSelected];
                        orderBottomView.secondBtn.selected=YES;
                        [orderBottomView.secondBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                        orderBottomView.oneBtn.tag=section;
                        orderBottomView.secondBtn.tag=section;
                    }
                }
                
            }else if(orderInfoModel.orderStatus==1){
                if(isFaqi){
                    
                    [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                    [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    orderBottomView.secondBtn.tag=section;
                }else{
                    [orderBottomView.secondBtn setTitle:[NSString stringWithFormat:@"%d人",orderInfoModel.pinkerCount] forState:UIControlStateSelected];
                    orderBottomView.secondBtn.selected=YES;
                }
                
            }else if(orderInfoModel.orderStatus==2){
                if(isFaqi){
                    [orderBottomView.miaosuLal setHidden:NO];
                    [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                    [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    orderBottomView.secondBtn.tag=section;
                }else{
                    [orderBottomView.secondBtn setTitle:[NSString stringWithFormat:@"%d人",orderInfoModel.pinkerCount] forState:UIControlStateSelected];
                    orderBottomView.secondBtn.selected=YES;
                }
                
            }else if(orderInfoModel.orderStatus==9 ){
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                if(isFaqi){
                  [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                orderBottomView.secondBtn.tag=section;
            }
        }else{
            NSString *str=orderInfoModel.checkUserAvatar_img ;
            [orderBottomView.zsUserImageView setImageWithURL:[NSURL URLWithString:str]];
            orderBottomView.zsUserNameLal.text=orderInfoModel.checkUserName;
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            if(orderInfoModel.orderStatus==0){
                [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setTitle:@"立即付款" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==1 || orderInfoModel.orderStatus==2){
                [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==9 ){
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }
            
            //订单为8 待评价
            if (orderInfoModel.orderStatus==8) {
                [orderBottomView.secondBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                orderBottomView.secondBtn.tag=section;
                [orderBottomView.secondBtn addTarget:self action:@selector(gotoPingjia:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setHidden:NO];
                [orderBottomView.secondBtn setSelected:YES];
                [orderBottomView.oneBtn setHidden:YES];
            }
        }
        
        

        
        return orderBottomView;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
    OrderInfoModel *orderInfoModel=dataList[section];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
    OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
    orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",orderInfoModel.id];
    orderHeadView.orderTimeLal.text=orderInfoModel.createDate;
    //获取酒吧信息
    if(orderInfoModel.ordertype==1){
        BOOL isFaqi=false;
        
        if(orderInfoModel.userid==self.userModel.userid){
            isFaqi=true;
        }
        if(isFaqi){
            if(orderInfoModel.consumptionCode){
                if(orderInfoModel.consumptionCode.length>0){
                    orderHeadView.detLal.text=[NSString stringWithFormat:@"消费码:%@",orderInfoModel.consumptionCode];
                }
            }
        }
    }else{
        if(orderInfoModel.consumptionCode){
            if(orderInfoModel.consumptionCode.length>0){
                orderHeadView.detLal.text=[NSString stringWithFormat:@"消费码:%@",orderInfoModel.consumptionCode];
            }
        }
    }
    
    orderHeadView.nameLal.text=orderInfoModel.barinfo.barname;
    orderHeadView.userImgeView.layer.masksToBounds =YES;
    orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
    NSString *str=orderInfoModel.barinfo.baricon ;
    [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
    //
    if(orderInfoModel.ordertype==0){
        [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"tao"]];
        //orderHeadView.detLal.text=orderInfoModel.reachtime;
    }else if(orderInfoModel.ordertype==1){
        [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"pin"]];
        //orderHeadView.detLal.text=orderInfoModel.reachtime;
    }else{
        [orderHeadView.orderTypeView setImage:[UIImage imageNamed:@"dan"]];
    }
    if(orderInfoModel.orderStatus==0){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"kuan"]];
    }else if(orderInfoModel.orderStatus==3 || orderInfoModel.orderStatus==4 || orderInfoModel.orderStatus==5 ){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"shen"]];
    }else if(orderInfoModel.orderStatus==1 || orderInfoModel.orderStatus==2){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"xiao"]];
    }else if(orderInfoModel.orderStatus==7){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"li"]];
    }else if(orderInfoModel.orderStatus==8 || orderInfoModel.orderStatus==9  ){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"wan"]];
    }else if(orderInfoModel.orderStatus==10){
        [orderHeadView.orderStuImageView setImage:[UIImage imageNamed:@"tui"]];
        
    }
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return orderHeadView;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderDetailCell";
    
    OrderDetailCell *cell = (OrderDetailCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (OrderDetailCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    OrderInfoModel *orderInfoModel;
    ShopDetailmodel *shopDetailmodel=[[ShopDetailmodel alloc]init];
    orderInfoModel= dataList[indexPath.section];
    if(orderInfoModel.ordertype==0){
        //0-－套餐订单
        
        
        SetMealInfoModel *setMealInfoModel=orderInfoModel.setMealInfo;
        SetMealVOModel *setMealVOModel=setMealInfoModel.setMealVO;
        shopDetailmodel.name=setMealInfoModel.fullName;
        shopDetailmodel.img=setMealVOModel.linkUrl;
        shopDetailmodel.youfeiPrice=setMealVOModel.price;
        shopDetailmodel.money=setMealVOModel.marketprice;
        shopDetailmodel.count=[NSString stringWithFormat:@"[适合%@-%@人]",setMealVOModel.minnum,setMealVOModel.maxnum];
        shopDetailmodel.rebate=setMealVOModel.rebate;
        cell.timeLal.text=[NSString stringWithFormat:@"X%@",orderInfoModel.allnum];
    }else if(orderInfoModel.ordertype==1){
        SetMealVOModel *setMealVOModel=orderInfoModel.pinkerinfo;
        shopDetailmodel.name=setMealVOModel.smname;
        shopDetailmodel.img=setMealVOModel.linkUrl;
        shopDetailmodel.youfeiPrice=setMealVOModel.price;
        shopDetailmodel.money=setMealVOModel.marketprice;
        shopDetailmodel.rebate=setMealVOModel.rebate;
//        if(mMenuHriZontal.selectIndex==1||mMenuHriZontal.selectIndex==2){
//            shopDetailmodel.count=[NSString stringWithFormat:@"拼客人数%@（%d人参与）",orderInfoModel.allnum,(int)orderInfoModel.pinkerList.count];
//        }else{
        

            shopDetailmodel.count=[NSString stringWithFormat:@"%@人拼客",orderInfoModel.allnum];
//        }
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
        shopDetailmodel.count=[NSString stringWithFormat:@"X%@(%@)",goodsModel.quantity,goodsModel.productVO.unit];
        shopDetailmodel.rebate=productVOModel.rebate;
    }
    
    cell.nameLal.text=shopDetailmodel.name;
    cell.delLal.text=shopDetailmodel.count;
    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",shopDetailmodel.rebate.doubleValue*100];
    if(orderInfoModel.orderStatus!=10&&orderInfoModel.orderStatus!=3&&orderInfoModel.orderStatus!=4&&orderInfoModel.orderStatus!=5){
        [cell.yjBtn setHidden:NO];
        [cell.yjBtn setTitle:flTem forState:0];
    }else{
        [cell.yjBtn setHidden:YES];
    }
    if(orderInfoModel.ordertype==1){
        //拼客订单
        BOOL isFaqi=false;
        
        if(orderInfoModel.userid==self.userModel.userid){
            isFaqi=true;
        }
        if(!isFaqi){
           [cell.yjBtn setHidden:YES];
        }
    }
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",shopDetailmodel.youfeiPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",shopDetailmodel.money] attributes:attribtDic];
    cell.moneyLal.attributedText=attribtStr;
    cell.timeLal.text = [NSString stringWithFormat:@"X%d",orderInfoModel.pinkerNum];
    NSString *str=shopDetailmodel.img ;
    [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:str]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoModel *orderInfoModel= dataList[indexPath.section];
    LYOrderDetailViewController *orderDetailViewController=[[LYOrderDetailViewController alloc]init];
    orderDetailViewController.title=@"订单详情";
    orderDetailViewController.delegate=self;
    orderDetailViewController.orderInfoModel=orderInfoModel;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
//    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 私聊
-(void)siliaoAct:(OrderHandleButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    BOOL isFaqi=false;
    if(orderInfoModel.ordertype==1){
        //拼客
        //判断是否发起人
        if(orderInfoModel.userid==self.userModel.userid){
            isFaqi=true;
        }
        if(isFaqi){
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
            conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = orderInfoModel.checkUserImUserid; // 接收者的 targetId，这里为举例。
            conversationVC.userName =orderInfoModel.checkUserName; // 接受者的 username，这里为举例。
            conversationVC.title =orderInfoModel.checkUserName; // 会话的 title。
            [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].isAdd = YES;
            // 把单聊视图控制器添加到导航栈。
            UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
            conversationVC.navigationItem.leftBarButtonItem = left;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }else{
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
            conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = orderInfoModel.imuserid; // 接收者的 targetId，这里为举例。
            conversationVC.userName =orderInfoModel.username; // 接受者的 username，这里为举例。
            conversationVC.title =orderInfoModel.username; // 会话的 title。
            [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].isAdd = YES;
            // 把单聊视图控制器添加到导航栈。
            UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
            conversationVC.navigationItem.leftBarButtonItem = left;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
    }else{
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = orderInfoModel.checkUserImUserid; // 接收者的 targetId，这里为举例。
        conversationVC.userName =orderInfoModel.checkUserName; // 接受者的 username，这里为举例。
        conversationVC.title =orderInfoModel.checkUserName; // 会话的 title。
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
        [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
        // 把单聊视图控制器添加到导航栈。
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
        conversationVC.navigationItem.leftBarButtonItem = left;
        
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
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
    orderInfoModel=dataList[sender.tag];
    
    
    
    if( [MyUtil isPureInt:orderInfoModel.checkUserMobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",orderInfoModel.checkUserMobile];
        if(orderInfoModel.ordertype==1){
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (app.userModel.userid!=orderInfoModel.userid) {
                str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",orderInfoModel.phone];
            }
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    switch (aIndex) {
            
        case 0://订单
        {
            [self getAllOrder];
            break;
        }
            
        case 1:// 待付款
        {
            [self getDaiFuKuan];
            break;
        }
            
        case 2:// 待消费
        {
            [self getDaiXiaoFei];
            break;
        }
            
        case 3:// 待评价
        {
            
            [self getDaiPingjia];
            break;
        }
        case 4:// 返利
        {
            [self getDaiFanLi];
            break;
        }
        default://退款
        {
            [self getTuiDan];
            break;
        }
            
    }
    
}
#pragma mark 删除订单
-(void)shanChuDinDanAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要删除订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
            [[LYUserHttpTool shareInstance]delMyOrder:dic complete:^(BOOL result) {
                if(result){
                    [MyUtil showMessage:@"删除成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                    if(orderInfoModel.ordertype==1){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"YunoticeToReload" object:nil];

                    }

                    [weakSelf refreshData];
                }
            }];
        }
    }];
    [alert show];
    
    
}
#pragma mark 参与人删除订单
-(void)shanChuDinDanByCanYuAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    __weak __typeof(self)weakSelf = self;
    NSArray *pinkerList=[PinkInfoModel mj_objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
    int orderid=0;
    if(pinkerList.count>0){
        for (PinkInfoModel *pinkInfoModel in pinkerList) {
            if(pinkInfoModel.inmember==self.userModel.userid){
                
                orderid=pinkInfoModel.id;
            }
        }
    }
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderid]};
            [[LYUserHttpTool shareInstance]delMyOrderByCanYu:dic complete:^(BOOL result) {
                if(result){
                    [MyUtil showMessage:@"取消成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];

                    [weakSelf refreshData];
                }
            }];

        }
    }];
    [alert show];
    
}
#pragma mark 付款
-(void)payAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    detailViewController.orderNo=orderInfoModel.sn;
    detailViewController.payAmount=orderInfoModel.amountPay.doubleValue;
    detailViewController.productName=orderInfoModel.fullname;
    detailViewController.productDescription=@"暂无";
    //如果是拼客 特殊处理
    if(orderInfoModel.ordertype==1){
        if(orderInfoModel.pinkerList.count>0){
            for (NSDictionary *dic in orderInfoModel.pinkerList) {
                PinkInfoModel *pinkInfoModel =[PinkInfoModel mj_objectWithKeyValues:dic];
                if(pinkInfoModel.inmember==self.userModel.userid){
                     detailViewController.orderNo=pinkInfoModel.sn;
                     detailViewController.payAmount=pinkInfoModel.price.doubleValue;
                    detailViewController.isPinker=YES;
                    if (pinkInfoModel.inmember==orderInfoModel.userid) {
                        detailViewController.isFaqi=YES;
                    }else{
                        detailViewController.isFaqi=NO;
                    }
                }
            }
        }
    }
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = left;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
#pragma mark 取消订单
- (void)queXiaoDinDanAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要取消订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
            [[LYUserHttpTool shareInstance]cancelMyOrder:dic complete:^(BOOL result) {
                if(result){
                    [MyUtil showMessage:@"取消订单成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];

                    [weakSelf refreshData];
                }
            }];
        }
    }];
    [alert show];
    
    

}
#pragma mark 立即评价
- (void)gotoPingjia:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    
    LYEvaluationController *eva=[[LYEvaluationController alloc]initWithNibName:@"LYEvaluationController" bundle:nil];
    eva.orderInfoModel=orderInfoModel;
    
    [self.navigationController pushViewController:eva animated:YES];
}

#pragma mark 一定会去
- (void)yiDinHuiQuAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderInfoModel.id]};
    [[LYUserHttpTool shareInstance]sureMyOrder:dic complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"设置成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];

            [weakSelf refreshData];
        }
    }];
}
#pragma mark 立即拼客
- (void)pinkeAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    
    orderInfoModel=dataList[sender.tag];
    
    __weak __typeof(self)weakSelf = self;
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"选择分享平台" message:@"" cancelButtonTitle:@"分享到娱" otherButtonTitles:@"其他平台" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
            
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到娱"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            
            PinkerShareController *zujuVC = [[PinkerShareController alloc]initWithNibName:@"PinkerShareController" bundle:nil];
            zujuVC.orderid=orderInfoModel.id;
            [weakSelf.navigationController pushViewController:zujuVC animated:YES];
        }else if (buttonIndex == 1){
            //确定
            NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"订单详情",@"titleName":@"分享",@"value":@"分享到其他平台"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            //http://121.40.229.133:8001/lieyu/inPinkerWebAction.do?id=77
            NSString *ss=[NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩～",weakSelf.userModel.usernick,orderInfoModel.barinfo.barname];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,orderInfoModel.id];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@inPinkerWebAction.do?id=%d",LY_SERVER,orderInfoModel.id];
            @try {
                [UMSocialSnsService presentSnsIconSheetView:weakSelf
                                                     appKey:UmengAppkey
                                                  shareText:ss
                                                 shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderInfoModel.pinkerinfo.linkUrl]]]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                                   delegate:nil];
            }
            @catch (NSException *exception) {
                [MyUtil showCleanMessage:@"无法分享！"];
            }
            @finally {
                
            }
        }
    }];
    [alert show];
    
    
    
    
    
}
- (void)refreshTable{
    [MyUtil showMessage:@"操作成功"];
    [self refreshData];
    
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

- (IBAction)gohomeAct:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
