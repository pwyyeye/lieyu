//
//  LYOrderDetailViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYOrderDetailViewController.h"
#import "orderDetailHeadView.h"
#import "OrderDetailSectionBottomForTuiKuanPinView.h"
#import "PinkInfoModel.h"
#import "OrderDetailSectionBottomView.h"
#import "OrderDetailSectionHeadView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderDetailCell.h"
#import "ShopDetailmodel.h"
#import "ChoosePayController.h"
#import "GoodsModel.h"
#import "MyChooseZSCell.h"
#import "MyPKfriendCell.h"
#import "OrderDetailSectionBottomForDanPinView.h"
#import "LYUserHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import "OrderHandleButton.h"

#import "UMSocial.h"
@interface LYOrderDetailViewController ()

@end

@implementation LYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    aboutTitle=@"";
    aboutContent=@"";
    sectionNum=0;
    CGRect rect;
    userId=self.userModel.userid;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    isFaqi=false;
    if(_orderInfoModel.ordertype==1){
        //拼客
        //判断是否发起人
        
        
        if(_orderInfoModel.userid==userId){
            isFaqi=true;
        }
        isfu=false;
        NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
        fukuanPKStr=@"0";
        if(pinkerList.count>0){
            for (PinkInfoModel *pinkInfoModel in pinkerList) {
                if(pinkInfoModel.inmember==self.userModel.userid){
                    fukuanPKStr=pinkInfoModel.price;
                    if(pinkInfoModel.paymentStatus==1){
                        isfu=true;
                        
                    }
                }
            }
        }
    }
    bool isShow=true;
    if(_orderInfoModel.ordertype==0){
        if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4  || _orderInfoModel.orderStatus==5){
            isShow=false;
        }
    }else if(_orderInfoModel.ordertype==1){
        //是否参与
        if(isFaqi){
            if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4  || _orderInfoModel.orderStatus==5){
                isShow=false;
            }
        }else{
            if(_orderInfoModel.orderStatus==0){
                if(isfu){
                    isShow=false;
                }else{
                    isShow=true;
                }
                
            }else{
                if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9 || _orderInfoModel.orderStatus==10){
                    isShow=true;
                }else{
                   isShow=false;
                }
            }

        }
        
    }else{
        if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4  || _orderInfoModel.orderStatus==5){
            isShow=false;
        }
    }
    
    if(isShow){
        tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-rect.size.height-rectNav.size.height-43} style:UITableViewStyleGrouped];
        dibuView =[[UIView alloc]initWithFrame:(CGRect){0,tableView.height+tableView.top,SCREEN_WIDTH,43}];
        dibuView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:tableView];
        [self.view addSubview:dibuView];
        [self getButton];
    }else{
        tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-rect.size.height-rectNav.size.height} style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
    }
    
    
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorColor=[UIColor clearColor];
    [self getDataList];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 初始化按钮
-(void)getButton{
    if(_orderInfoModel.ordertype==0){
        if(_orderInfoModel.orderStatus==0){
            UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
            btn2.backgroundColor=RGB(229, 229, 229);
            
            [btn2 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn2 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn2];
            
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            NSString *jiaGeStr=[NSString stringWithFormat:@"马上支付（￥%@）",_orderInfoModel.amountPay];
            [btn1 setTitle:jiaGeStr forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==1){
            if(_orderInfoModel.consumptionStatus==0){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
                btn1.backgroundColor=RGB(229, 229, 229);
                
                [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
                
                UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
                btn2.backgroundColor=RGB(247, 138, 79);
                
                [btn2 setTitle:@"一定会去" forState:UIControlStateNormal];
                btn2.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn2 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn2 addTarget:self action:@selector(yiDinHuiQuAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn2];
            }else{
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(229, 229, 229);
                [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }
        }else if(_orderInfoModel.orderStatus==2){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(229, 229, 229);
            [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==7){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"电话咨询" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(dhzxAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==10){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }
    }else if (_orderInfoModel.ordertype==1){
        if(isFaqi){
            if(_orderInfoModel.orderStatus==0){
                if(isfu){
                    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
                    btn2.backgroundColor=RGB(229, 229, 229);
                    
                    [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn2 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                    [btn2 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn2];
                    
                    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
                    btn1.backgroundColor=RGB(35, 166, 116);
                    if(_orderInfoModel.pinkerList.count<_orderInfoModel.allnum.intValue){
                        [btn1 setTitle:@"邀请好友" forState:UIControlStateNormal];
                        [btn1 addTarget:self action:@selector(yaoQinAct:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        [btn1 setTitle:@"人数已满" forState:UIControlStateNormal];
                    }
                    
                    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                    
                    [dibuView addSubview:btn1];
                    

                }else{
                    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
                    btn2.backgroundColor=RGB(229, 229, 229);
                    
                    [btn2 setTitle:@"删除订单" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn2 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                    [btn2 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn2];
                    
                    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
                    btn1.backgroundColor=RGB(247, 138, 79);
                    
                        if(_orderInfoModel.pinkerList.count>0){
                            for (NSDictionary *dic in _orderInfoModel.pinkerList) {
                                PinkInfoModel *pinkInfoModel =[PinkInfoModel objectWithKeyValues:dic];
                                if(pinkInfoModel.inmember==userId){
                                    NSString *jiaGeStr=[NSString stringWithFormat:@"马上支付（￥%@）",pinkInfoModel.price];
                                    [btn1 setTitle:jiaGeStr forState:UIControlStateNormal];
                                    
                                }
                            }
                        }
                    
//                    NSString *jiaGeStr=[NSString stringWithFormat:@"马上支付（￥%@）",_orderInfoModel.amountPay];
//                    [btn1 setTitle:jiaGeStr forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                    [btn1 addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn1];
                }
                
            }else if(_orderInfoModel.orderStatus==1){
                
                    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                    btn1.backgroundColor=RGB(229, 229, 229);
                    [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                    [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn1];
                
            }else if(_orderInfoModel.orderStatus==2){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(229, 229, 229);
                [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }else if(_orderInfoModel.orderStatus==7){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(247, 138, 79);
                [btn1 setTitle:@"电话咨询" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(dhzxAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(247, 138, 79);
                [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }else if(_orderInfoModel.orderStatus==10){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(247, 138, 79);
                [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }
        }else{
            if(_orderInfoModel.orderStatus==0){
                if(!isfu){
                   
                    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
                    btn2.backgroundColor=RGB(229, 229, 229);
                    
                    [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn2 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                    [btn2 addTarget:self action:@selector(shanChuDinDanByCanYuAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn2];
                    
                    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
                    btn1.backgroundColor=RGB(247, 138, 79);
                    if(_orderInfoModel.pinkerList.count>0){
                        for (NSDictionary *dic in _orderInfoModel.pinkerList) {
                            PinkInfoModel *pinkInfoModel =[PinkInfoModel objectWithKeyValues:dic];
                            if(pinkInfoModel.inmember==userId){
                                NSString *jiaGeStr=[NSString stringWithFormat:@"马上支付（￥%@）",pinkInfoModel.price];
                                [btn1 setTitle:jiaGeStr forState:UIControlStateNormal];
                                
                            }
                        }
                    }
                    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                    [btn1 addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                    [dibuView addSubview:btn1];
                }
                
            }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(247, 138, 79);
                [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }else if(_orderInfoModel.orderStatus==10){
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(247, 138, 79);
                [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
            }
        }
    }else{
        if(_orderInfoModel.orderStatus==0){
            UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width/2, dibuView.height)];
            btn2.backgroundColor=RGB(229, 229, 229);
            
            [btn2 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn2 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn2];
            
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(dibuView.width/2, 0, dibuView.width/2, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            NSString *jiaGeStr=[NSString stringWithFormat:@"马上支付（￥%@）",_orderInfoModel.amountPay];
            [btn1 setTitle:jiaGeStr forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==1){
            
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
                btn1.backgroundColor=RGB(229, 229, 229);
                [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [dibuView addSubview:btn1];
           
        }else if(_orderInfoModel.orderStatus==2){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(229, 229, 229);
            [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(153, 153, 153)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==7){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"电话咨询" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(dhzxAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }else if(_orderInfoModel.orderStatus==10){
            UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dibuView.width, dibuView.height)];
            btn1.backgroundColor=RGB(247, 138, 79);
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn1 setTitleColor:RGB(255, 255, 255)  forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
            [dibuView addSubview:btn1];
        }

    }
}
#pragma mark 初始化数据
-(void)getDataList{
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
    NSString *nowB;
    NSString *nextB;
    
    //顶部状态描述
    if(_orderInfoModel.ordertype==0){
        sectionNum=3;
        if(_orderInfoModel.orderStatus==0){
            sectionNum=2;
            nowB=@"还未付款";
            nextB=@"支付消费";
            
        }else if(_orderInfoModel.orderStatus==1){
            if(_orderInfoModel.consumptionStatus==0){
                nowB=@"还没想去";
                nextB=@"一定会去";
                aboutTitle=@"关于还没想去";
                aboutContent=@"对于不确定一定会去的用户来说，我们专属经理不会为您留位；当用户决定一定会去的时候，只要点击一定会去按钮，我们的专属经理将会在为您预订卡座。";
            }else{
                nowB=@"一定会去";
                nextB=@"等待留位";
                aboutTitle=@"关于等待留位";
                aboutContent=@"请您耐心等待，VIP专属经理将会帮您预留座位，如预留成功，您将会收到短信消费码提示。";
            }
            
        }else if(_orderInfoModel.orderStatus==2){
            nowB=@"已经留位";
            nextB=@"到店消费";
            aboutTitle=@"关于卡座预订费";
            aboutContent=@"VIP专属经理已经帮你预留座位，请您提前30分钟到店消费。如取消退款将会收取您20%的卡座占用费（100元封顶），如有不便，敬请谅解！";
            
        }else if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5){
            sectionNum=1;
            nowB=@"取消订单";
            nextB=@"等待退款";
        }else if(_orderInfoModel.orderStatus==7){
            nowB=@"已经消费";
            nextB=@"等待返利";
            aboutTitle=@"关于返利";
            aboutContent=@"用户只需在线下单并消费成功，即可获得对应的订单返利。猎娱平台承若返利金额将会在15个工作日内汇到用户在猎娱平台支付的对应账户内。";
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            sectionNum=2;
            nowB=@"已经返利";
            nextB=@"继续消费";
        }else{
            sectionNum=1;
            nowB=@"已经退款";
            nextB=@"删除订单";
        }
    }else if(_orderInfoModel.ordertype==1){
        sectionNum=4;
        if(_orderInfoModel.orderStatus==0){
            if(isFaqi){
                if(isfu){
                    sectionNum=4;
                    nowB=@"开始拼客";
                    nextB=@"等待拼成";
                    aboutTitle=@"关于发起拼客";
                    aboutContent=@"您已经发起了的拼客活动，请您分享您的参与玩友，记得电话问问，拼成效率更高哦！";
                }else{
                    sectionNum=3;
                    nowB=@"还未付款";
                    nextB=@"支付消费";
                }
            }else{
                if(isfu){
                    sectionNum=2;
                    nowB=@"已经参与";
                    nextB=@"等待拼成";
                }else{
                    sectionNum=2;
                    nowB=@"还未付款";
                    nextB=@"立即付款";
                }
            }
            
            
        }else if(_orderInfoModel.orderStatus==1){
            sectionNum=4;
            if(_orderInfoModel.consumptionStatus==0){
                nowB=@"已经拼成";
                nextB=@"等待留位";
            }else{
                nowB=@"已经拼成";
                nextB=@"等待留位";
            }
            if(!isFaqi){
                sectionNum=2;
            }
        }else if(_orderInfoModel.orderStatus==2){
            sectionNum=4;
            nowB=@"已经留位";
            nextB=@"到店消费";
            if(!isFaqi){
                sectionNum=2;
            }else{
                aboutTitle=@"关于卡座预订费";
                aboutContent=@"VIP专属经理已经帮你预留座位，请您提前30分钟到店消费。如取消退款将会收取您20%的卡座占用费（100元封顶），如有不便，敬请谅解！";
            }
        }else if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5){
            sectionNum=1;
            nowB=@"取消订单";
            nextB=@"等待退款";
        }else if(_orderInfoModel.orderStatus==7){
            if(isFaqi){
                sectionNum=4;
                nowB=@"已经消费";
                nextB=@"等待返利";
                aboutTitle=@"关于返利";
                aboutContent=@"用户只需在线下单并消费成功，即可获得对应的订单返利。猎娱平台承若返利金额将会在15个工作日内汇到用户在猎娱平台支付的对应账户内。";
            }else{
                sectionNum=2;
                nowB=@"已经消费";
                nextB=@"系统审核";
            }
            
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            sectionNum=3;
            if(isFaqi){
                nowB=@"已经返利";
                nextB=@"继续消费";
            }else{
                nowB=@"消费完成";
                nextB=@"删除订单";
                sectionNum=2;
            }
            
        }else{
            sectionNum=1;
            nowB=@"已经退款";
            nextB=@"删除订单";
        }
        
    }else{
        sectionNum=2;
        if(_orderInfoModel.orderStatus==0){
            nowB=@"还未付款";
            nextB=@"支付消费";
            
        }else if(_orderInfoModel.orderStatus==1){
                nowB=@"已经付款";
                nextB=@"等待消费";
            
            
        }else if(_orderInfoModel.orderStatus==2){
            nowB=@"已经付款";
            nextB=@"等待消费";
            
        }else if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5){
            sectionNum=1;
            nowB=@"取消订单";
            nextB=@"等待退款";
        }else if(_orderInfoModel.orderStatus==7){
            sectionNum=3;
            nowB=@"已经消费";
            nextB=@"等待返利";
            aboutTitle=@"关于返利";
            aboutContent=@"用户只需在线下单并消费成功，即可获得对应的订单返利。猎娱平台承若返利金额将会在15个工作日内汇到用户在猎娱平台支付的对应账户内。";
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            sectionNum=2;
            nowB=@"已经返利";
            nextB=@"继续消费";
        }else{
            sectionNum=1;
            nowB=@"已经退款";
            nextB=@"删除订单";
        }
    }
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderDetailHeadView" owner:nil options:nil];
    OrderDetailHeadView *orderDetailHeadView= (OrderDetailHeadView *)[nibView objectAtIndex:0];
    orderDetailHeadView.titleOneLal.text=nowB;
    orderDetailHeadView.titleTwoLal.text=nextB;
    tableView.tableHeaderView=orderDetailHeadView;
    [tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        if(_orderInfoModel.ordertype==2){
            return _orderInfoModel.goodslist.count;
        }else if(_orderInfoModel.ordertype==0){
            return 1;
        }else{
            return 1;
        }

    }else if(section==1){
        if(_orderInfoModel.ordertype==1){
            if(isFaqi){
                return _orderInfoModel.pinkerList.count;
            }else{
                return 1;
            }
            
        }else{
            return 1;
        }
    }else if(section==2){
        
            return 1;
        
    }else{
        
            return 1;
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return sectionNum;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 68;
    }else{
        return 35;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section==0){
        if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5 || _orderInfoModel.orderStatus==10){
            return 95;
        }
        if(_orderInfoModel.ordertype==2){
            return 81;
        }else{
            return 117;
        }

    }else{
        return 0;
    }
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
    
    if(section==0){
        if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5 || _orderInfoModel.orderStatus==10){
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderDetailSectionBottomForTuiKuanPinView" owner:nil options:nil];
            OrderDetailSectionBottomForTuiKuanPinView *orderDetailSectionBottomForTuiKuanView= (OrderDetailSectionBottomForTuiKuanPinView *)[nibView objectAtIndex:0];
            NSString *fukuanStr=@"￥0";
            NSString *tuiKuanStr=@"￥0";
            NSString *weiYueStr=@"￥0";
            if(_orderInfoModel.ordertype==1){
                
                double payVule=0.0;
                NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
                if(pinkerList.count>0){
                    for (PinkInfoModel *pinkInfoModel in pinkerList) {
                        if(pinkInfoModel.inmember==userId){
                            if(pinkInfoModel.paymentStatus==1){
                                fukuanStr=[NSString stringWithFormat:@"￥%@",pinkInfoModel.price];
                                payVule=fukuanStr.doubleValue;
                            }
                        }
                    }
                }
                if(isFaqi){
                   tuiKuanStr=[NSString stringWithFormat:@"￥%.2f",payVule - _orderInfoModel.penalty.doubleValue];
                    weiYueStr=[NSString stringWithFormat:@"￥%@",_orderInfoModel.penalty];
                }else{
                    tuiKuanStr=fukuanStr;
                    weiYueStr=@"￥0";
                }
            }else{
                fukuanStr= [NSString stringWithFormat:@"￥%@",_orderInfoModel.amountPay];
                tuiKuanStr=[NSString stringWithFormat:@"￥%.2f",_orderInfoModel.amountPay.doubleValue- _orderInfoModel.penalty.doubleValue];
                weiYueStr=[NSString stringWithFormat:@"￥%@",_orderInfoModel.penalty];
            }
            orderDetailSectionBottomForTuiKuanView.payLal.text=fukuanStr;
            orderDetailSectionBottomForTuiKuanView.flLal.text=tuiKuanStr;
            orderDetailSectionBottomForTuiKuanView.wyjLal.text=weiYueStr;
            orderDetailSectionBottomForTuiKuanView.dizhiLal.text=_orderInfoModel.barinfo.address;
            
            return orderDetailSectionBottomForTuiKuanView;
        }
        if(_orderInfoModel.ordertype==2){
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderDetailSectionBottomForDanPinView" owner:nil options:nil];
            OrderDetailSectionBottomForDanPinView *orderDetailSectionBottomForDanPinView= (OrderDetailSectionBottomForDanPinView *)[nibView objectAtIndex:0];
            
            NSString *fukuanStr=@"￥0";
            NSString *flStr=@"￥0";
            fukuanStr = [NSString stringWithFormat:@"￥%@",_orderInfoModel.amountPay];
            flStr = [NSString stringWithFormat:@"￥%@",_orderInfoModel.rebateAmout];
            orderDetailSectionBottomForDanPinView.dizhiLal.text=_orderInfoModel.barinfo.address;
            orderDetailSectionBottomForDanPinView.payLal.text=fukuanStr;
            orderDetailSectionBottomForDanPinView.flLal.text=flStr;
            return orderDetailSectionBottomForDanPinView;
        }else{
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderDetailSectionBottomView" owner:nil options:nil];
            OrderDetailSectionBottomView *orderDetailSectionBottomView= (OrderDetailSectionBottomView *)[nibView objectAtIndex:0];
            
            NSString *fukuanStr=@"￥0";
            NSString *flStr=@"￥0";
            if(_orderInfoModel.ordertype==1){
                NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
                if(pinkerList.count>0){
                    for (PinkInfoModel *pinkInfoModel in pinkerList) {
                        if(pinkInfoModel.inmember==userId){
                            if(pinkInfoModel.paymentStatus==1){
                                fukuanStr=[NSString stringWithFormat:@"￥%@",pinkInfoModel.price];
                            }
                        }
                    }
                }
                if(isFaqi){
                    flStr=[NSString stringWithFormat:@"￥%@",_orderInfoModel.rebateAmout];
                }
                
            }else{
                fukuanStr = [NSString stringWithFormat:@"￥%@",_orderInfoModel.amountPay];
                flStr = [NSString stringWithFormat:@"￥%@",_orderInfoModel.rebateAmout];
            }
            orderDetailSectionBottomView.dizhiLal.text=_orderInfoModel.barinfo.address;
            orderDetailSectionBottomView.payTimelal.text=_orderInfoModel.reachtime;
            orderDetailSectionBottomView.payLal.text=fukuanStr;
            orderDetailSectionBottomView.flLal.text=flStr;
            return orderDetailSectionBottomView;
        }

    }else{
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    return  nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //ordertype:订单类别  （0-－套餐订单 ，1、拼客订单, 2-－吃喝订单  ）
    if(section==0){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderDetailSectionHeadView" owner:nil options:nil];
        OrderDetailSectionHeadView *orderHeadView= (OrderDetailSectionHeadView *)[nibView objectAtIndex:0];
        orderHeadView.orderNoLal.text=[NSString stringWithFormat:@"%d",_orderInfoModel.id];
        orderHeadView.orederTime.text=_orderInfoModel.createDate;
        //获取酒吧信息
        orderHeadView.userImgeView.layer.masksToBounds =YES;
        orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
        NSString *str=_orderInfoModel.barinfo.baricon ;
        [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:str]];
        orderHeadView.nameLal.text=_orderInfoModel.barinfo.barname;
        
        if(_orderInfoModel.ordertype==1){
            if(isFaqi){
                if(_orderInfoModel.consumptionCode){
                    if(_orderInfoModel.consumptionCode.length>0){
                        orderHeadView.detLal.text=[NSString stringWithFormat:@"消费码:%@",_orderInfoModel.consumptionCode];
                    }
                }
            }
        }else{
            if(_orderInfoModel.consumptionCode){
                if(_orderInfoModel.consumptionCode.length>0){
                    orderHeadView.detLal.text=[NSString stringWithFormat:@"消费码:%@",_orderInfoModel.consumptionCode];
                }
            }
        }
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return orderHeadView;
    }else if(section==1){
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        
        if(_orderInfoModel.ordertype==1){
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(215, 11, 90, 12)];
            label1.font=[UIFont systemFontOfSize:12];
            label1.textColor=RGB(240, 77, 109);
            label1.textAlignment=NSTextAlignmentRight;
            label1.text=[NSString stringWithFormat:@"%ld/%@",_orderInfoModel.pinkerList.count,_orderInfoModel.allnum];
            [view addSubview:label1];
            if(isFaqi){
                //"pinkertype":"0"// 0、请客 1、AA付款 2、自由付款 （发起人自由 其他AA）
                NSString *pinkType;
                if(_orderInfoModel.pinkerType==0){
                    pinkType=@"我请客";
                }else if(_orderInfoModel.pinkerType==1){
                    pinkType=@"AA付款";
                }else{
                    pinkType=@"自由付款";
                }
                label.text=[NSString stringWithFormat:@"我的拼客好友(%@)",pinkType];
            }else{
                NSString *pinkType;
                if(_orderInfoModel.pinkerType==0){
                    pinkType=@"他请客";
                }else if(_orderInfoModel.pinkerType==1){
                    pinkType=@"AA付款";
                }else{
                    pinkType=@"自由付款";
                }

                label.text=[NSString stringWithFormat:@"邀请我的好友(%@)",pinkType];
            }
            
        }else{
            label.text=@"我选择的VIP专属经理";
        }
        return view;
    }else if(section==2){
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        
        if(_orderInfoModel.ordertype==1){
            label.text=@"我们选择的VIP专属经理";
        }else{
            label.text=aboutTitle;
        }
        return view;
        
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];

        label.text=aboutTitle;
        
        return view;
    }
    return  nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        NSString *CellIdentifier = @"OrderDetailCell";
        
        OrderDetailCell *cell = (OrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (OrderDetailCell *)[nibArray objectAtIndex:0];
            cell.backgroundColor=[UIColor whiteColor];
            
            
        }
        OrderInfoModel *orderInfoModel=_orderInfoModel;
        ShopDetailmodel *shopDetailmodel=[[ShopDetailmodel alloc]init];
        if(_orderInfoModel.ordertype==0){
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
        }else if(_orderInfoModel.ordertype==1){
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
            GoodsModel *goodsModel=[GoodsModel objectWithKeyValues:dicTemp];
            ProductVOModel *productVOModel=goodsModel.productVO;
            shopDetailmodel.name=goodsModel.fullName;
            shopDetailmodel.img=productVOModel.image;
            shopDetailmodel.youfeiPrice=productVOModel.price;
            shopDetailmodel.money=productVOModel.marketprice;
            shopDetailmodel.count=[NSString stringWithFormat:@"X%@",goodsModel.quantity];
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
            if(!isFaqi){
                [cell.yjBtn setHidden:YES];
            }
        }
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [cell addSubview:lineLal];
        cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",shopDetailmodel.youfeiPrice];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",shopDetailmodel.money] attributes:attribtDic];
        cell.moneyLal.attributedText=attribtStr;
        NSString *str=shopDetailmodel.img ;
        [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:str]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section==1){
        if(_orderInfoModel.ordertype==1){
            NSString *CellIdentifier = @"MyPKfriendCell";
            
            MyPKfriendCell *cell = (MyPKfriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (MyPKfriendCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                cell.pkUserimageView.layer.masksToBounds =YES;
                cell.pkUserimageView.layer.cornerRadius =cell.pkUserimageView.width/2;
                
            }
            NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
            PinkInfoModel *pinkInfoModel;
            if(isFaqi){
                pinkInfoModel=pinkerList[indexPath.row];
            }else{
                for (PinkInfoModel *pinkInfoModelTemp in pinkerList){
                    if(pinkInfoModelTemp.inmember==_orderInfoModel.userid){
                        pinkInfoModel=pinkInfoModelTemp;
                    }
                }
            }
            
            NSString *str=pinkInfoModel.inmenberAvatar_img ;
            [cell.pkUserimageView  setImageWithURL:[NSURL URLWithString:str]];
            cell.pkNameLal.text=pinkInfoModel.inmemberName;
            if(userId!=pinkInfoModel.inmember){
                [cell.siliaoBtn setHidden:NO];
                [cell.phoneBtn setHidden:NO];
                [cell.siliaoBtn addTarget:self action:@selector(siliaoActForPK:) forControlEvents:UIControlEventTouchUpInside];
                [cell.phoneBtn addTarget:self action:@selector(dianhuaActForPK:) forControlEvents:UIControlEventTouchUpInside];
                cell.phoneBtn.tag=indexPath.row;
                cell.siliaoBtn.tag=indexPath.row;
            }else{
                [cell.siliaoBtn setHidden:YES];
                [cell.phoneBtn setHidden:YES];
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 45.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            //vip专属经理列表
            NSString *CellIdentifier = @"MyChooseZSCell";
            
            MyChooseZSCell *cell = (MyChooseZSCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (MyChooseZSCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                cell.userImageView.layer.masksToBounds =YES;
                cell.userImageView.layer.cornerRadius =cell.userImageView.width/2;
                
            }
            NSString *str=_orderInfoModel.checkUserAvatar_img ;
            [cell.userImageView setImageWithURL:[NSURL URLWithString:str]];
            cell.nameLal.text=_orderInfoModel.checkUserName;
            cell.ageLal.text=[NSString stringWithFormat:@"年龄：%@",_orderInfoModel.checkUserAge];
            if(_orderInfoModel.orderStatus==0 || _orderInfoModel.orderStatus==1 || _orderInfoModel.orderStatus==2){
                [cell.siliaoBtn setHidden:false];
                [cell.phoneBtn setHidden:false];
                [cell.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
                [cell.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
                cell.phoneBtn.tag=indexPath.section;
                cell.siliaoBtn.tag=indexPath.section;
            }else{
                [cell.siliaoBtn setHidden:YES];
                [cell.phoneBtn setHidden:YES];
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(indexPath.section==2){
        if(_orderInfoModel.ordertype==1){
            //vip专属经理列表
            NSString *CellIdentifier = @"MyChooseZSCell";
            
            MyChooseZSCell *cell = (MyChooseZSCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (MyChooseZSCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                cell.userImageView.layer.masksToBounds =YES;
                cell.userImageView.layer.cornerRadius =cell.userImageView.width/2;
                
            }
            NSString *str=_orderInfoModel.checkUserAvatar_img ;
            [cell.userImageView setImageWithURL:[NSURL URLWithString:str]];
            cell.nameLal.text=_orderInfoModel.checkUserName;
            cell.ageLal.text=[NSString stringWithFormat:@"年龄：%@",_orderInfoModel.checkUserAge];
            if(_orderInfoModel.orderStatus==0 || _orderInfoModel.orderStatus==1 || _orderInfoModel.orderStatus==2){
                [cell.siliaoBtn setHidden:false];
                [cell.phoneBtn setHidden:false];
                [cell.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
                [cell.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
                cell.phoneBtn.tag=indexPath.section;
                cell.siliaoBtn.tag=indexPath.section;
            }else{
                [cell.siliaoBtn setHidden:YES];
                [cell.phoneBtn setHidden:YES];
            }
            
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
            UITableViewCell *cell = nil;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor whiteColor];
                UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-20, 25)];
                [lal1 setTag:1];
                lal1.textAlignment=NSTextAlignmentLeft;
                lal1.font=[UIFont boldSystemFontOfSize:12];
                lal1.backgroundColor=[UIColor clearColor];
                lal1.textColor= RGB(128, 128, 128);
                lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
                lal1.lineBreakMode=UILineBreakModeWordWrap;
                [cell.contentView addSubview:lal1];
                
            }
            
            
            UILabel *lal = (UILabel*)[cell viewWithTag:1];
            NSString *title=aboutContent;
            
            //高度固定不折行，根据字的多少计算label的宽度
            
            CGSize size = [title sizeWithFont:lal.font
                             constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping];
            //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
            //根据计算结果重新设置UILabel的尺寸
            lal.height=size.height;
            lal.text=title;
            CGRect cellFrame = [cell frame];
            cellFrame.origin=CGPointMake(0, 0);
            cellFrame.size.width=SCREEN_WIDTH;
            cellFrame.size.height=lal.size.height+20;
            
            [cell setFrame:cellFrame];
            
            
            
            
            return cell;
        }

    }else{
        NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
        UITableViewCell *cell = nil;
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-20, 25)];
            [lal1 setTag:1];
            lal1.textAlignment=NSTextAlignmentLeft;
            lal1.font=[UIFont boldSystemFontOfSize:12];
            lal1.backgroundColor=[UIColor clearColor];
            lal1.textColor= RGB(128, 128, 128);
            lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
            lal1.lineBreakMode=UILineBreakModeWordWrap;
            [cell.contentView addSubview:lal1];
            
        }
        
        
        UILabel *lal = (UILabel*)[cell viewWithTag:1];
        NSString *title=aboutContent;
        
        //高度固定不折行，根据字的多少计算label的宽度
        
        CGSize size = [title sizeWithFont:lal.font
                        constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
        //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        lal.height=size.height;
        lal.text=title;
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lal.size.height+20;
        
        [cell setFrame:cellFrame];
        
        
        
        
        return cell;

    }
    return  nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderInfoModel *orderInfoModel= dataList[indexPath.section];
//    LYOrderDetailViewController *orderDetailViewController=[[LYOrderDetailViewController alloc]init];
//    orderDetailViewController.title=@"订单详情";
//    orderDetailViewController.orderInfoModel=orderInfoModel;
//    [self.navigationController pushViewController:orderDetailViewController animated:YES];
    //    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 76;
    }else if(indexPath.section==1){
        if(_orderInfoModel.ordertype==1){
            return 46;
        }else{
            return 76;
        }
    }else if(indexPath.section==2){
        if(_orderInfoModel.ordertype==1){
            return 76;
        }else{
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;

        }
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;

    }
    return 76;
}
#pragma mark 付款
-(void)payAct:(UIButton *)sender{
    
    OrderInfoModel *orderInfoModel;
    orderInfoModel=_orderInfoModel;
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    detailViewController.orderNo=orderInfoModel.sn;
    detailViewController.payAmount=orderInfoModel.amountPay.doubleValue;
    detailViewController.productName=orderInfoModel.fullname;
    detailViewController.productDescription=@"暂无";
    //如果是拼客 特殊处理
    if(orderInfoModel.ordertype==1){
        if(orderInfoModel.pinkerList.count>0){
            for (NSDictionary *dic in orderInfoModel.pinkerList) {
                PinkInfoModel *pinkInfoModel =[PinkInfoModel objectWithKeyValues:dic];
                if(pinkInfoModel.inmember==userId){
                    detailViewController.orderNo=pinkInfoModel.sn;
                    detailViewController.payAmount=pinkInfoModel.price.doubleValue;
                }
            }
        }
    }
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}
#pragma mark 取消订单
- (void)queXiaoDinDanAct:(UIButton *)sender{
//    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:_orderInfoModel.id]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要取消订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]cancelMyOrder:dic complete:^(BOOL result) {
                if(result){
                    
                    [self.delegate refreshTable];
                    [self.navigationController popViewControllerAnimated:YES];
                    //            [weakSelf refreshData];
                }
            }];
            
        }
    }];
    [alert show];
    
    
}
#pragma mark 一定会去
- (void)yiDinHuiQuAct:(UIButton *)sender{
//    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:_orderInfoModel.id]};
    [[LYUserHttpTool shareInstance]sureMyOrder:dic complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"设置成功"];
//            [weakSelf refreshData];
        }
    }];
}
#pragma mark 电话咨询
- (void)dhzxAct:(UIButton *)sender{
    if( [MyUtil isPureInt:_orderInfoModel.checkUserMobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_orderInfoModel.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }

}
#pragma mark 删除订单
-(void)shanChuDinDanAct:(UIButton *)sender{
    
//    __weak __typeof(self)weakSelf = self;
    
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:_orderInfoModel.id]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"您确认要删除订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]delMyOrder:dic complete:^(BOOL result) {
                if(result){
                    [self.delegate refreshTable];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    [alert show];
    
    
}

#pragma mark 参与人删除订单
-(void)shanChuDinDanByCanYuAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=_orderInfoModel;
//    __weak __typeof(self)weakSelf = self;
    NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:orderInfoModel.pinkerList];
    int orderid=0;
    if(pinkerList.count>0){
        for (PinkInfoModel *pinkInfoModel in pinkerList) {
            if(pinkInfoModel.inmember==userId){
                
                orderid=pinkInfoModel.id;
            }
        }
    }
    
    NSDictionary *dic=@{@"id":[NSNumber numberWithInt:orderid]};
    AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
        //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            [[LYUserHttpTool shareInstance]delMyOrderByCanYu:dic complete:^(BOOL result) {
                if(result){
                    [self.delegate refreshTable];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    [alert show];
    
    
}
#pragma mark 邀请拼客
-(void)yaoQinAct:(UIButton *)sender{
    OrderInfoModel *orderInfoModel;
    
    orderInfoModel=_orderInfoModel;
    //http://121.40.229.133:8001/lieyu/inPinkerWebAction.do?id=77
    NSString *ss=[NSString stringWithFormat:@"你的好友%@邀请你一起来%@玩:\n %@inPinkerWebAction.do?id=%d",self.userModel.usernick,orderInfoModel.barinfo.barname,LY_SERVER,orderInfoModel.id];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:ss
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil]
                                       delegate:nil];
}
#pragma mark 私聊
-(void)siliaoAct:(UIButton *)sender{
    
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = _orderInfoModel.imuserid; // 接收者的 targetId，这里为举例。
    conversationVC.userName =_orderInfoModel.username; // 接受者的 username，这里为举例。
    conversationVC.title =_orderInfoModel.checkUserName; // 会话的 title。
    
    // 把单聊视图控制器添加到导航栈。
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark 电话
-(void)dianhuaAct:(UIButton *)sender{
    
    
    
    
    if( [MyUtil isPureInt:_orderInfoModel.checkUserMobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_orderInfoModel.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}
#pragma mark 私聊
-(void)siliaoActForPK:(UIButton *)sender{
    
    NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
    PinkInfoModel *pinkInfoModel=pinkerList[sender.tag];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = pinkInfoModel.inmenberImUserid; // 接收者的 targetId，这里为举例。
    conversationVC.userName =pinkInfoModel.inmemberName; // 接受者的 username，这里为举例。
    conversationVC.title =pinkInfoModel.inmemberName; // 会话的 title。
    
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark 电话
-(void)dianhuaActForPK:(UIButton *)sender{
    
    
    NSArray *pinkerList=[PinkInfoModel objectArrayWithKeyValuesArray:_orderInfoModel.pinkerList];
    PinkInfoModel *pinkInfoModel=pinkerList[sender.tag];
    
    if( [MyUtil isPureInt:pinkInfoModel.inmenbermobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",pinkInfoModel.inmenbermobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
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

@end
