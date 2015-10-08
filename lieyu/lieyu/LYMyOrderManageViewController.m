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
#import "DetailCell.h"
#import "ShopDetailmodel.h"
#import "GoodsModel.h"
@interface LYMyOrderManageViewController ()

@end

@implementation LYMyOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSArray *menuArrNew=@[@"订单",@"待付款",@"待消费",@"已返利",@"待返利"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5), 44);
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
    if(mMenuHriZontal.selectIndex==3){
        return 76;
    }
    if(mMenuHriZontal.selectIndex==4){
        return 76;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    OrderInfoModel *orderInfoModel=dataList[section];
    /*
    if( orderInfoModel.orderStatus == 7){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYOrderBottomForFinishView" owner:nil options:nil];
        LYOrderBottomForFinishView *orderBottomView= (LYOrderBottomForFinishView *)[nibView objectAtIndex:0];
        orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
        [orderBottomView.duimaBtn addTarget:self action:@selector(duimaAct:) forControlEvents:UIControlEventTouchUpInside];
        [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
        
        [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
        orderBottomView.duimaBtn.tag=section;
        orderBottomView.siliaoBtn.tag=section;
        orderBottomView.dianhuaBtn.tag=section;
        //    view.backgroundColor=[UIColor yellowColor];
        return orderBottomView;
    }else{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYOrderBottomView" owner:nil options:nil];
        LYOrderBottomView *orderBottomView= (LYOrderBottomView *)[nibView objectAtIndex:0];
        orderBottomView.moneyLal.text=[NSString stringWithFormat:@"￥%@",orderInfoModel.amountPay];
        [orderBottomView.duimaBtn addTarget:self action:@selector(duimaAct:) forControlEvents:UIControlEventTouchUpInside];
        [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
        
        [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
        orderBottomView.duimaBtn.tag=section;
        orderBottomView.siliaoBtn.tag=section;
        orderBottomView.dianhuaBtn.tag=section;
        //    view.backgroundColor=[UIColor yellowColor];
        return orderBottomView;
    }
    */
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
    orderHeadView.nameLal.text=orderInfoModel.username;
    orderHeadView.userImgeView.layer.masksToBounds =YES;
    orderHeadView.userImgeView.layer.cornerRadius =orderHeadView.userImgeView.width/2;
    [orderHeadView.userImgeView setImageWithURL:[NSURL URLWithString:orderInfoModel.avatar_img]];
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
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return orderHeadView;
    
    
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
    }else if(orderInfoModel.ordertype==1){
        //拼客订单
        
        SetMealVOModel *setMealVOModel=orderInfoModel.pinkerinfo;
        shopDetailmodel.name=setMealVOModel.smname;
        shopDetailmodel.img=setMealVOModel.linkUrl;
        shopDetailmodel.youfeiPrice=setMealVOModel.price;
        shopDetailmodel.money=setMealVOModel.marketprice;
        if(mMenuHriZontal.selectIndex==1||mMenuHriZontal.selectIndex==2){
            shopDetailmodel.count=[NSString stringWithFormat:@"拼客人数%@（%d人参与）",orderInfoModel.allnum,(int)orderInfoModel.pinkerList.count];
        }else{
            shopDetailmodel.count=[NSString stringWithFormat:@"%@人拼客",orderInfoModel.allnum];
        }
        
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
    }
    
    cell.nameLal.text=shopDetailmodel.name;
    cell.countLal.text=shopDetailmodel.count;
    if(mMenuHriZontal.selectIndex==0){
        cell.countLal.text=shopDetailmodel.count;
    }else if(mMenuHriZontal.selectIndex==1){
        cell.countLal.text=shopDetailmodel.count;
    }
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",shopDetailmodel.youfeiPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",shopDetailmodel.money] attributes:attribtDic];
    cell.moneylal.attributedText=attribtStr;
    [cell.detImageView setImageWithURL:[NSURL URLWithString:shopDetailmodel.img]];
    
    
    
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
