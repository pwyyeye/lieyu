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
#import "GoodsModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderHandleButton.h"
#import <RongIMKit/RongIMKit.h>
@interface LYMyOrderManageViewController ()

@end

@implementation LYMyOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userId=app.userModel.userid;
    [self.tableView setHidden:YES];
    [self.nodataView setHidden:NO];
    [self.kongImageView setImage:[UIImage sd_animatedGIFNamed:@"gouGif"]];
    dataList=[[NSMutableArray alloc]init];
    [self getMenuHrizontal];
    [self getAllOrder];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取所有订单
-(void)getAllOrder{
    [dataList removeAllObjects];
    
    
//    NSDictionary *dic=@{@"orderStatus":@"0",@"createDate":dateStr};
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyOrderListWithParams:nil block:^(NSMutableArray *result) {
        [dataList addObjectsFromArray:result];
        if(dataList.count>0){
            [self.tableView setHidden:NO];
            [self.nodataView setHidden:YES];
        }else{
            [self.tableView setHidden:YES];
            [self.nodataView setHidden:NO];
        }
        [weakSelf.tableView reloadData];
    }];
    

}
#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSArray *menuArrNew=@[@"订单",@"待付款",@"待消费",@"已返利",@"待返利",@"退款"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5.5), 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGB(229, 255, 245) set];
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
        [itemTemp setObject:[NSNumber numberWithFloat:self.view.width/5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@"88"  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:self.menuView.frame ButtonItems:barArr];
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
    if( orderInfoModel.orderStatus == 7 || orderInfoModel.orderStatus == 3 || orderInfoModel.orderStatus == 3
       || orderInfoModel.orderStatus == 5){
         return 76;
    }
    
    return 120;
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
        if(orderInfoModel.orderStatus==7 ){
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            orderBottomView.miaosuCenterLal.text=@"猎娱承诺返利金额会予以15个工作日发放个人账户中";
        }else{
            orderBottomView.titleLal.text=@"交易金额";
            orderBottomView.titleTwoLal.text=@"退款金额";
            orderBottomView.moneyOnelal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
            orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%.f",orderInfoModel.amountPay.doubleValue- orderInfoModel.penalty.doubleValue];
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
        orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
        [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
        [orderBottomView.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
        orderBottomView.phoneBtn.tag=section;
        orderBottomView.siliaoBtn.tag=section;
        orderBottomView.zsUserImageView.layer.masksToBounds =YES;
        orderBottomView.zsUserImageView.layer.cornerRadius =orderBottomView.zsUserImageView.width/2;
        [orderBottomView.zsUserImageView setImageWithURL:[NSURL URLWithString:orderInfoModel.checkUserAvatar_img]];
        orderBottomView.zsUserNameLal.text=orderInfoModel.checkUserName;
        //根据订单类型 订单状态设置底部按钮
        if(orderInfoModel.ordertype==0){
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
                [orderBottomView.oneBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.oneBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setTitle:@"一定会去" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(yiDinHuiQuAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==2){
                [orderBottomView.miaosuLal setHidden:NO];
                [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==8 || orderInfoModel.orderStatus==9 ){
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }
        }else if(orderInfoModel.ordertype==1){
            //判断是否发起人
            BOOL isFaqi=false;
            
            if(orderInfoModel.userid==userId){
                isFaqi=true;
            }
            if(orderInfoModel.orderStatus==0){
                bool isfu=false;
                
                if(isFaqi){
                    
                }
                [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setTitle:@"立即拼客" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(payPinAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==1){
                [orderBottomView.oneBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.oneBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setTitle:@"一定会去" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(yiDinHuiQuAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==2){
                [orderBottomView.miaosuLal setHidden:NO];
                [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==8 || orderInfoModel.orderStatus==9 ){
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }
        }else{
            if(orderInfoModel.orderStatus==0){
                [orderBottomView.oneBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.oneBtn setHidden:NO];
                [orderBottomView.oneBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                [orderBottomView.secondBtn setTitle:@"立即付款" forState:UIControlStateSelected];
                orderBottomView.secondBtn.selected=YES;
                [orderBottomView.secondBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.oneBtn.tag=section;
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==1){
                [orderBottomView.secondBtn setTitle:@"取消订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(queXiaoDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
            }else if(orderInfoModel.orderStatus==8 || orderInfoModel.orderStatus==9 ){
                
                [orderBottomView.secondBtn setTitle:@"删除订单" forState:0];
                [orderBottomView.secondBtn addTarget:self action:@selector(shanChuDinDanAct:) forControlEvents:UIControlEventTouchUpInside];
                orderBottomView.secondBtn.tag=section;
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
    //获取酒吧信息
    if(orderInfoModel.consumptionCode){
        if(orderInfoModel.consumptionCode.length>0){
            orderHeadView.orderTimeLal.text=[NSString stringWithFormat:@"消费码:%@",orderInfoModel.consumptionCode];
        }
    }
    orderHeadView.nameLal.text=orderInfoModel.barinfo.barname;
    orderHeadView.userImgeView.layer.masksToBounds =YES;
    orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
    [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:orderInfoModel.barinfo.baricon]];
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
        shopDetailmodel.rebate=setMealVOModel.rebate;
    }else if(orderInfoModel.ordertype==1){
        //拼客订单
        
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
    
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",shopDetailmodel.youfeiPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",shopDetailmodel.money] attributes:attribtDic];
    cell.moneyLal.attributedText=attribtStr;
    [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:shopDetailmodel.img]];
    
    
    
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

#pragma mark 私聊
-(void)siliaoAct:(OrderHandleButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = orderInfoModel.imuserid; // 接收者的 targetId，这里为举例。
    conversationVC.userName =orderInfoModel.username; // 接受者的 username，这里为举例。
    conversationVC.title =orderInfoModel.username; // 会话的 title。
    
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark 电话
-(void)dianhuaAct:(OrderHandleButton *)sender{
    OrderInfoModel *orderInfoModel;
    orderInfoModel=dataList[sender.tag];
    
    
    
    if( [MyUtil isPureInt:orderInfoModel.checkUserMobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",orderInfoModel.phone];
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
