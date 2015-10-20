//
//  BiaoQianChooseViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BiaoQianChooseViewController.h"
#import "TypeChooseCell.h"
#import "BiaoQianBtn.h"
#import "ProductCategoryModel.h"
#import "BrandModel.h"
#import "ZSManageHttpTool.h"
#import "BiaoQianBtn.h"
@interface BiaoQianChooseViewController ()
{
  NSMutableArray  *biaoqianList;
    
}
@end

@implementation BiaoQianChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    biaoqianList=[NSMutableArray new];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self geBiaoQianData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 标签
-(void)geBiaoQianData{
    //获取酒水类型
    [biaoqianList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] getProductCategoryListWithParams:nil block:^(NSMutableArray *result) {
//        [weakSelf geBiaoQianForJGData];
        NSMutableArray *jiuShuiLXList=[weakSelf setRow:result];
        NSDictionary *dic=@{@"title":@"酒水类型：",@"data":jiuShuiLXList};
        [biaoqianList addObject:dic];
        [weakSelf geBiaoQianForBrandData];
    }];
    
    
}
#pragma mark 获取价格
-(void)geBiaoQianForJGData{
    ProductCategoryModel *model=[[ProductCategoryModel alloc]init];
    model.name=@"1000以内";
    ProductCategoryModel *model1=[[ProductCategoryModel alloc]init];
    model1.name=@"1k-3k以内";
    ProductCategoryModel *model2=[[ProductCategoryModel alloc]init];
    model2.name=@"3k-5k以内";
    ProductCategoryModel *model3=[[ProductCategoryModel alloc]init];
    model3.name=@"5k-10k以内";
    ProductCategoryModel *model4=[[ProductCategoryModel alloc]init];
    model4.name=@"一万以上";
    NSArray *arr=@[model,model1,model2];
    NSArray *arr1=@[model3,model4];
    NSMutableArray *jiageArr=[[NSMutableArray alloc]init];
    [jiageArr addObject:arr];
    [jiageArr addObject:arr1];
    NSDictionary *dic=@{@"title":@"价格(元)：",@"data":jiageArr};
    [biaoqianList addObject:dic];
}
#pragma mark 获取品牌
-(void)geBiaoQianForBrandData{
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] getBrandListWithParams:nil block:^(NSMutableArray *result) {
        NSMutableArray *brandList=[weakSelf setRow:result];
        NSDictionary *dic=@{@"title":@"酒水品牌：",@"data":brandList};
        [biaoqianList addObject:dic];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark酒水类型数据分成3列
-(NSMutableArray *)setRow:(NSMutableArray *)arr{
    int nowCount=1;
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    for (int i=0; i<arr.count; i++) {
        ProductCategoryModel *productCategoryModel= arr[i];
        
        if(nowCount%3==0){
            [pageArr addObject:productCategoryModel];
            [dataArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:3];
        }else{
            [pageArr addObject:productCategoryModel];
            if(i==arr.count-1){
                [dataArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    return dataArr;
}
//#pragma mark酒水品牌数据分成3列
//-(NSMutableArray *)setJiuShuiBrandRow:(NSMutableArray *)arr{
//    int nowCount=1;
//    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
//    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
//    for (int i=0; i<arr.count; i++) {
//        BrandModel *productCategoryModel= arr[i];
//        
//        if(nowCount%3==0){
//            [pageArr addObject:productCategoryModel];
//            [dataArr addObject:pageArr];
//            pageArr=[[NSMutableArray alloc]initWithCapacity:3];
//        }else{
//            [pageArr addObject:productCategoryModel];
//            if(i==arr.count-1){
//                [pageArr addObject:pageArr];
//            }
//        }
//        nowCount++;
//    }
//    return dataArr;
//}

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dic=@{@"title":@"酒水品牌：",@"data":brandList};
    NSDictionary *dic= biaoqianList [section];
    NSArray *arr=[dic objectForKey:@"data"];
    return arr.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return biaoqianList.count;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    NSDictionary *dic=@{@"title":@"酒水品牌：",@"data":brandList};
    NSDictionary *dic= biaoqianList [section];
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
    NSDictionary *dic= biaoqianList [indexPath.section];
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
    button.model.isSel=true;
    NSDictionary *dic= biaoqianList [indexPath.section];
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

- (IBAction)sureAct:(id)sender {
    //获取选中的类型数据
    NSMutableArray *arrNew=[NSMutableArray new];
    for (NSDictionary *dic in biaoqianList) {
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
    if(arrNew.count==biaoqianList.count){
        [self.delegate addBiaoQian:arrNew];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showMessage:@"请选择类型"];
        return;
    }

}
@end
