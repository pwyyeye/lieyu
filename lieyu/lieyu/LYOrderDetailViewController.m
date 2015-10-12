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
#import "GoodsModel.h"
#import "MyChooseZSCell.h"
#import "MyPKfriendCell.h"
@interface LYOrderDetailViewController ()

@end

@implementation LYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userId=app.userModel.userid;
    sectionNum=0;
    CGRect rect;
    
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    isFaqi=false;
    if(_orderInfoModel.ordertype==1){
        //拼客
        //判断是否发起人
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        int userId=app.userModel.userid;
        
        if(_orderInfoModel.userid==userId){
            isFaqi=true;
        }
    }
    bool isShow=true;
    if(_orderInfoModel.ordertype==0){
        if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4  || _orderInfoModel.orderStatus==5){
            isShow=false;
        }
    }else if(_orderInfoModel.ordertype==1){
        
    }else{
        
    }
    
    if(isShow){
        tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-rect.size.height-rectNav.size.height-43} style:UITableViewStyleGrouped];
        dibuView =[[UIView alloc]initWithFrame:(CGRect){0,tableView.height+tableView.top,SCREEN_WIDTH,43}];
        dibuView.backgroundColor=[UIColor redColor];
        [self.view addSubview:tableView];
        [self.view addSubview:dibuView];
    }else{
        tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT} style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
    }
    
    
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorColor=[UIColor clearColor];
    [self getDataList];
    // Do any additional setup after loading the view from its nib.
}

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
    if(_orderInfoModel.ordertype==0){
        sectionNum=3;
        if(_orderInfoModel.orderStatus==0){
            nowB=@"还未付款";
            nextB=@"支付消费";
            
        }else if(_orderInfoModel.orderStatus==1){
            if(_orderInfoModel.consumptionStatus==0){
                nowB=@"还没想去";
                nextB=@"一定会去";
            }else{
                nowB=@"一定会去";
                nextB=@"等待留位";
            }
            
        }else if(_orderInfoModel.orderStatus==2){
            nowB=@"已经留位";
            nextB=@"到店消费";
            
        }else if(_orderInfoModel.orderStatus==3 || _orderInfoModel.orderStatus==4 || _orderInfoModel.orderStatus==5){
            sectionNum=1;
            nowB=@"取消订单";
            nextB=@"等待退款";
        }else if(_orderInfoModel.orderStatus==7){
            nowB=@"已经消费";
            nextB=@"等待返利";
        }else if(_orderInfoModel.orderStatus==8 || _orderInfoModel.orderStatus==9){
            sectionNum=2;
            nowB=@"已经返利";
            nextB=@"删除订单";
        }else{
            nowB=@"已经退款";
            nextB=@"删除订单";
        }
    }else if(_orderInfoModel.ordertype==1){
        
    }else{
        
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
                   tuiKuanStr=[NSString stringWithFormat:@"￥%.f",payVule - _orderInfoModel.penalty.doubleValue];
                    weiYueStr=[NSString stringWithFormat:@"￥%@",_orderInfoModel.penalty];
                }else{
                    tuiKuanStr=fukuanStr;
                    weiYueStr=@"￥0";
                }
            }else{
                fukuanStr= [NSString stringWithFormat:@"￥%@",_orderInfoModel.amountPay];
                tuiKuanStr=[NSString stringWithFormat:@"￥%.f",_orderInfoModel.amountPay.doubleValue- _orderInfoModel.penalty.doubleValue];
                weiYueStr=[NSString stringWithFormat:@"￥%@",_orderInfoModel.penalty];
            }
            orderDetailSectionBottomForTuiKuanView.payLal.text=fukuanStr;
            orderDetailSectionBottomForTuiKuanView.flLal.text=tuiKuanStr;
            orderDetailSectionBottomForTuiKuanView.wyjLal.text=weiYueStr;
            orderDetailSectionBottomForTuiKuanView.dizhiLal.text=_orderInfoModel.barinfo.address;
            
            return orderDetailSectionBottomForTuiKuanView;
        }
        if(_orderInfoModel.ordertype==2){
            return nil;
        }else if(_orderInfoModel.ordertype==0){
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
        [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:_orderInfoModel.barinfo.baricon]];
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
            label.text=@"我的拼客好友";
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
            label.text=@"我选择的VIP专属经理";
        }else{
            label.text=@"关于待";
        }
        return view;
        
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];

        label.text=@"关于待";
        
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
        [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:shopDetailmodel.img]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section==1){
        if(_orderInfoModel.ordertype==1){
            
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
            
            [cell.userImageView setImageWithURL:[NSURL URLWithString:_orderInfoModel.checkUserAvatar_img]];
            cell.nameLal.text=_orderInfoModel.checkUserName;
            cell.ageLal.text=@"年龄：秘密";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(indexPath.section==2){
        if(_orderInfoModel.ordertype==1){
            
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
            NSString *title=@"请您在规定的预约时间内到您所选购的商品地点消费，如果您已超过预约时间，无法消费，需取消订单，我们将会收取您的20%卡座预订费（100元封顶），如有多有不便，敬请谅解！";
            
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
            
        }else{
            return 76;
        }
    }else if(indexPath.section==2){
        if(_orderInfoModel.ordertype==1){
            
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
