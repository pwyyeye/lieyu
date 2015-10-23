//
//  CHshowDetailListViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHshowDetailListViewController.h"
#import "LYHomePageHttpTool.h"
#import "CHDetailCollectionCell.h"
#import "MJRefresh.h"
#import "CHShaiXuanViewController.h"
#import "ProductCategoryModel.h"
#import "CHJiuPinDetailViewController.h"
@interface CHshowDetailListViewController ()<CHShaiXuanDelegate>
{
    NSMutableArray *dataList;
    NSMutableDictionary *nowDic;
    int pageCount;
    int perCount;
}
@end

@implementation CHshowDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList = [[NSMutableArray alloc]init];
    pageCount=1;
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:@{@"barid":[NSString stringWithFormat:@"%d",self.barid]}];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic setObject:@"20" forKey:@"per"];
    [self getData:nowDic];
    __weak __typeof(self)weakSelf = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
    _btnItem1.selected=true;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        
        NSLog(@"****block%ld******",dataList.count);
        if(dataList.count>0){
            
            pageCount++;
            [weakSelf.collectionView.footer resetNoMoreData];
        }
        [weakSelf.collectionView reloadData];
    }];
    [weakSelf.collectionView.header endRefreshing];
}
#pragma mark 获取更多数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.collectionView reloadData];
        }else{
            [weakSelf.collectionView.footer noticeNoMoreData];
        }
    }];
    
    [weakSelf.collectionView.footer endRefreshing];
    
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(dataList){
        return dataList.count;
    }
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CHDetailCollectionCell";
    CHDetailCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.goodsImageView.image=nil;
    CheHeModel *chiHeModel=dataList[indexPath.row];
    chiHeModel.barname=self.barName;
    [cell configureCell:chiHeModel];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(145, 226);
}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 7, 0, 7);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CheHeModel *chiHeModel=dataList[indexPath.row];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJiuPinDetailViewController *jiuPinDetailViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHJiuPinDetailViewController"];
    jiuPinDetailViewController.title=@"套餐详情";
    jiuPinDetailViewController.shopid=chiHeModel.id;
    [self.navigationController pushViewController:jiuPinDetailViewController animated:YES];

    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

- (IBAction)change:(ShaiXuanBtn *)sender {
    ShaiXuanBtn *btn=(ShaiXuanBtn*)sender;
    NSString *sortkey=@"";
//    priceasc
//    pricedesc
//    salesasc
//    salesdesc
//    rebateasc
//    rebatedesc
    if (btn.tag==100)
    {
        _btnItem1.selected=true;
        _btnItem2.selected=false;
        _btnItem3.selected=false;
        _btnItem4.selected=false;
        _btnItem5.selected=false;
        _btnItem2.isup=false;
        _btnItem3.isup=false;
        _btnItem4.isup=false;
        sortkey=@"priceasc";
    }else if(btn.tag==101)
    {
        _btnItem1.selected=false;
        _btnItem5.selected=false;
        if(_btnItem2.selected){
            _btnItem2.isup=!_btnItem2.isup;
            
        }
        if(_btnItem2.isup){
            [_btnItem2 setImage:[UIImage imageNamed:@"jiageDown"] forState:UIControlStateSelected];
            sortkey=@"pricedesc";
        }else{
            [_btnItem2 setImage:[UIImage imageNamed:@"jiageUp"] forState:UIControlStateSelected];
            sortkey=@"priceasc";
        }
        _btnItem2.selected=true;
        _btnItem3.selected=false;
        _btnItem4.selected=false;
        _btnItem5.selected=false;
        _btnItem3.isup=false;
        _btnItem4.isup=false;
        
        
    }
    else if(btn.tag==102)
    {
        _btnItem1.selected=false;
        if(_btnItem3.selected){
            _btnItem3.isup=!_btnItem3.isup;
            
        }
        
        if(_btnItem3.isup){
            [_btnItem3 setImage:[UIImage imageNamed:@"xiaoliangUp"] forState:UIControlStateSelected];
            sortkey=@"salesasc";
        }else{
            [_btnItem3 setImage:[UIImage imageNamed:@"xiaoliangDown"] forState:UIControlStateSelected];
            sortkey=@"salesdesc";
        }
        
        _btnItem3.selected=true;
        _btnItem2.selected=false;
        _btnItem4.selected=false;
        _btnItem5.selected=false;
        _btnItem2.isup=false;
        
        _btnItem4.isup=false;
        
        
    }
    else if(btn.tag==103)
    {
        _btnItem1.selected=false;
        if(_btnItem4.selected){
            _btnItem4.isup=!_btnItem4.isup;
            
        }
        if(_btnItem4.isup){
            [_btnItem4 setImage:[UIImage imageNamed:@"flUp"] forState:UIControlStateSelected];
            sortkey=@"rebateasc";
        }else{
            [_btnItem4 setImage:[UIImage imageNamed:@"flDown"] forState:UIControlStateSelected];
            sortkey=@"rebatedesc";
        }
        _btnItem4.selected=true;
        _btnItem2.selected=false;
        _btnItem5.selected=false;
        _btnItem2.isup=false;
        _btnItem3.selected=false;
        _btnItem3.isup=false;
        
    }
    else if(btn.tag==104)
    {
        _btnItem1.selected=false;
        _btnItem4.selected=false;
        _btnItem2.selected=false;
        _btnItem5.selected=true;
        
        _btnItem3.selected=false;
        _btnItem2.isup=false;
        _btnItem3.isup=false;
        _btnItem4.isup=false;
        CHShaiXuanViewController *shaiXuanViewController=[[CHShaiXuanViewController alloc]initWithNibName:@"CHShaiXuanViewController" bundle:nil];
        shaiXuanViewController.delegate=self;
        [self.navigationController pushViewController:shaiXuanViewController animated:YES];
        return;
    }
    [nowDic removeObjectForKey:@"sort"];
    [nowDic setObject:sortkey forKey:@"sort"];
    [self getData:nowDic];
}
- (void)addShaiXuan:(NSMutableArray *)arr{
    [nowDic removeObjectForKey:@"minprice"];
    [nowDic removeObjectForKey:@"sort"];
    [nowDic removeObjectForKey:@"maxprice"];
    [nowDic removeObjectForKey:@"categoryid"];
    [nowDic removeObjectForKey:@"brandid"];
    for (ProductCategoryModel *mode in arr) {
        if(mode.type==0){
            if([mode.minprice isEqualToString:@"10000"]){
                [nowDic setObject:mode.minprice forKey:@"minprice"];
            }else{
                [nowDic setObject:mode.maxprice forKey:@"maxprice"];
                [nowDic setObject:mode.minprice forKey:@"minprice"];
            }
            
        }else if(mode.type==1){
            [nowDic setObject:[NSString stringWithFormat:@"%d",mode.id] forKey:@"categoryid"];
        }else{
            [nowDic setObject:[NSString stringWithFormat:@"%d",mode.id] forKey:@"brandid"];
        }
    }
    [self getData:nowDic];
}
@end
