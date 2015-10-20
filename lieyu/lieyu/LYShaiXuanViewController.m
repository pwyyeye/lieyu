//
//  LYShaiXuanViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYShaiXuanViewController.h"
#import "ProductCategoryModel.h"
#import "BiaoQianBtn.h"
#import "TypeChooseCell.h"
@interface LYShaiXuanViewController ()
{
    NSMutableArray  *dataList;
}
@end

@implementation LYShaiXuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList=[NSMutableArray new];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 条件数据
-(void)getData{
    //价格
    ProductCategoryModel *model=[[ProductCategoryModel alloc]init];
    model.name=@"1000以内";
    model.maxprice=@"1000";
    model.minprice=@"0";
    model.type=0;
    ProductCategoryModel *model1=[[ProductCategoryModel alloc]init];
    model1.name=@"1k-3k以内";
    model1.maxprice=@"3000";
    model1.minprice=@"1000";
    model1.type=0;
    ProductCategoryModel *model2=[[ProductCategoryModel alloc]init];
    model2.name=@"3k-5k以内";
    model2.maxprice=@"5000";
    model2.minprice=@"3000";
    model2.type=0;
    ProductCategoryModel *model3=[[ProductCategoryModel alloc]init];
    model3.name=@"5k-10k以内";
    model3.maxprice=@"10000";
    model3.minprice=@"5000";
    model3.type=0;
    ProductCategoryModel *model4=[[ProductCategoryModel alloc]init];
    model4.name=@"一万以上";
    model4.maxprice=@"10000000";
    model4.minprice=@"10000";
    model4.type=0;
    NSArray *arr=@[model,model1,model2];
    NSArray *arr1=@[model3,model4];
    NSMutableArray *jiageArr=[[NSMutableArray alloc]init];
    [jiageArr addObject:arr];
    [jiageArr addObject:arr1];
    NSDictionary *dic=@{@"title":@"价格(元)：",@"data":jiageArr};
    [dataList addObject:dic];
    
    //人数
    //价格
    ProductCategoryModel *model20=[[ProductCategoryModel alloc]init];
    model20.name=@"3-5人";
    model20.minnum=@"3";
    model20.maxnum=@"5";
    model20.type=1;
    ProductCategoryModel *model21=[[ProductCategoryModel alloc]init];
    model21.name=@"5-8人";
    model21.minnum=@"5";
    model21.maxnum=@"8";
    model21.type=1;
    ProductCategoryModel *model22=[[ProductCategoryModel alloc]init];
    model22.name=@"8-12人";
    model22.minnum=@"8";
    model22.maxnum=@"12";
    model22.type=1;
    ProductCategoryModel *model23=[[ProductCategoryModel alloc]init];
    model23.name=@"12-15人";
    model23.minnum=@"12";
    model23.maxnum=@"15";
    model23.type=1;
    ProductCategoryModel *model24=[[ProductCategoryModel alloc]init];
    model24.name=@"15人以上";
    model24.minnum=@"15";
    model24.maxnum=@"150000";
    model24.type=1;
    NSArray *arr20=@[model20,model21,model22];
    NSArray *arr21=@[model23,model24];
    NSMutableArray *renArr=[[NSMutableArray alloc]init];
    [renArr addObject:arr20];
    [renArr addObject:arr21];
    NSDictionary *dic1=@{@"title":@"人数：",@"data":renArr};
    [dataList addObject:dic1];
}
#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSDictionary *dic=@{@"title":@"酒水品牌：",@"data":brandList};
    NSDictionary *dic= dataList [section];
    NSArray *arr=[dic objectForKey:@"data"];
    return arr.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    NSDictionary *dic=@{@"title":@"酒水品牌：",@"data":brandList};
    NSDictionary *dic= dataList [section];
    NSString *title=[dic objectForKey:@"title"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
    
    label.text=title;
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=RGB(51, 51, 51);
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TypeChooseCell";
    
    TypeChooseCell*cell = (TypeChooseCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (TypeChooseCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    NSDictionary *dic= dataList [indexPath.section];
    NSArray *arr=[dic objectForKey:@"data"];
    NSArray *arrTemp=arr[indexPath.row];
    if(arrTemp.count==1){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=true;
        cell.threeBtn.hidden=true;
    }
    if(arrTemp.count==2){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=false;
        cell.threeBtn.hidden=true;
    }
    if(arrTemp.count==3){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=false;
        cell.threeBtn.hidden=false;
    }
    for (int i=0; i<arrTemp.count; i++) {
        ProductCategoryModel *productCategoryModel=arrTemp[i];
        if(i==0){
            [cell.oneBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.oneBtn.model=productCategoryModel;
            [cell.oneBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.oneBtn setSelected:productCategoryModel.isSel];
        }
        if(i==1){
            [cell.twoBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.twoBtn.model=productCategoryModel;
            [cell.twoBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.twoBtn setSelected:productCategoryModel.isSel];
        }
        if(i==2){
            [cell.threeBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.threeBtn.model=productCategoryModel;
            [cell.threeBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.threeBtn setSelected:productCategoryModel.isSel];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(void)typeChoose:(BiaoQianBtn *)button event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    button.model.isSel=!button.model.isSel;
    NSDictionary *dic= dataList [indexPath.section];
    NSArray *arr=[dic objectForKey:@"data"];
    for (NSArray *arr1 in arr) {
        for (ProductCategoryModel *model in arr1) {
            if(![button.model isEqual:model] ){
                model.isSel=false;
            }
        }
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)sureAct:(id)sender {
    //获取选中的类型数据
    NSMutableArray *arrNew=[NSMutableArray new];
    for (NSDictionary *dic in dataList) {
        NSArray *arr=[dic objectForKey:@"data"];
        for (NSArray *arr1 in arr) {
            bool isflag=false;
            for (ProductCategoryModel *model in arr1) {
                if(model.isSel){
                    isflag=true;
                    [arrNew addObject:model];
                    break;
                }
            }
            if(isflag){
                break;
            }
        }
    }
    //判断是否符合条件
    
        [self.delegate addCondition:arrNew];
        [self.navigationController popViewControllerAnimated:YES];
    
    
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
