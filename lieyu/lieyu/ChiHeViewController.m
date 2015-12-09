//
//  ChiHeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChiHeViewController.h"
#import "LYHomePageHttpTool.h"
#import "chiheDetailCollectionCell.h"
#import "MJRefresh.h"
#import "CHShaiXuanViewController.h"
#import "ProductCategoryModel.h"
#import "CHJiuPinDetailViewController.h"
#import "LYCarListViewController.h"

#import "ZSManageHttpTool.h"

@interface ChiHeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *dataList;
    NSMutableDictionary *nowDic;
    int pageCount;
    int perCount;
    UIBarButtonItem *rightBtn;
    int goodsNumber;
    int chooseKey;
    NSMutableArray *biaoqianList;
}

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIView *MoreView;
@property (nonatomic, assign) BOOL moreShow;

@end

@implementation ChiHeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.sxBtn1 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [self.sxBtn2 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [self.sxBtn3 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [self.sxBtn4 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [self.sxBtn5 setBackgroundColor:RGBA(114, 5, 147, 1)];
    
    _moreShow = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shoppingCar"] style:UIBarButtonItemStylePlain target:self action:@selector(showcarAct)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    dataList = [[NSMutableArray alloc]init];
    pageCount = 1;
    goodsNumber = 1;
    self.buttonsArray = @[_sxBtn1,_sxBtn2,_sxBtn3,_sxBtn4];
    
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:@{@"barid":[NSString stringWithFormat:@"%d",self.barid]}];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic setObject:@"20" forKey:@"per"];
    [self getData:nowDic];
    [self geBiaoQianData];
    
//    __weak __typeof(self)weakSelf = self;
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        pageCount=1;
//        
//        [nowDic removeObjectForKey:@"p"];
//        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
//        [weakSelf getData:nowDic];
//    }];
//    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [nowDic removeObjectForKey:@"p"];
//        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
//        [self getDataWithDicMore:nowDic];
//    }];
}

#pragma 获取酒品种类信息
-(void)geBiaoQianData{
    //获取酒水类型
    [biaoqianList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] getProductCategoryListWithParams:nil block:^(NSMutableArray *result) {
        biaoqianList = [weakSelf setRow:result];
    }];
}

#pragma 将信息转为三列
-(NSMutableArray *)setRow:(NSMutableArray *)arr{
    int nowCount=1;
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    for (int i = 4; i<arr.count; i++) {
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

#pragma  back按钮点击事件
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 展示购物车
- (void)showcarAct{
    LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
    carListViewController.title=@"购物车";
    [self.navigationController pushViewController:carListViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 获得数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        
        NSLog(@"****block%ld******",dataList.count);
        if(dataList.count>0){
            
            pageCount++;
            [weakSelf.collectionView.mj_footer resetNoMoreData];
        }
        [weakSelf.collectionView reloadData];
    }];
    [weakSelf.collectionView.mj_header endRefreshing];
}

#pragma 获得更多数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.collectionView reloadData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [weakSelf.collectionView.mj_footer endRefreshing];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(!dataList.count){
        return 0;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(dataList.count){
        return dataList.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index");
    static NSString * CellIdentifier = @"chiheCell";
    chiheDetailCollectionCell * cell;
    [collectionView registerNib:[UINib nibWithNibName:@"chiheDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath ];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"chiheDetailCollectionCell" owner:nil options:nil]firstObject];
    }
    cell.goodImage.image=nil;
    //    cell.layer.borderColor = (__bridge CGColorRef _Nullable)(RGBA(217, 217, 217, 217));
    cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = 5.f;
    cell.layer.masksToBounds = YES;
    cell.userInteractionEnabled = YES;
    
    CheHeModel *chiHeModel=dataList[indexPath.row];
    chiHeModel.barname=self.barName;
    [cell configureCell:chiHeModel];
    return cell;
}

#pragma mark --UIcollectionviewDelegateFlowLayout
//定义每个UIcollectionview 的大小
- (CGSize)collectionview:(UICollectionView *)collectionview layout:(UICollectionViewLayout*)collectionviewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(151, 288);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma collectionview相应点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CheHeModel *chiHeModel=dataList[indexPath.row];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    CHJiuPinDetailViewController *jiuPinDetailViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHJiuPinDetailViewController"];
//    CHJiuPinDetailViewController *jiuPinDetailViewController = [[CHJiuPinDetailViewController alloc]init];
    jiuPinDetailViewController.title=@"套餐详情";
    jiuPinDetailViewController.shopid=chiHeModel.id;
    [self.navigationController pushViewController:jiuPinDetailViewController animated:YES];

}

//返回这个UIcollectionview是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionview shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)sxBtnClick:(ShaiXuanBtn *)sender {
    ShaiXuanBtn *btn=(ShaiXuanBtn*)sender;
    //    NSString *sortkey=@"";
    //    NSString *choosekey = @"";
    for (UIButton *button in _buttonsArray) {
        if(button.tag == btn.tag){
//            button.selected = YES;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
        }else{
//            button.selected = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:RGBA(114, 5, 147, 1)];
        }
    }
    if(btn.tag == 100){
        chooseKey = 1;
    }else if(btn.tag == 101){
        chooseKey = 2;
    }else if (btn.tag == 102){
        chooseKey = 3;
    }else if(btn.tag == 103){
        chooseKey = 4;
    }else{
        
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setImage:[UIImage imageNamed:@"more_purper"] forState:UIControlStateNormal];
        [self showMoreButtons];
        return;
    }
    [self chooseWineBy:chooseKey];
}

#pragma 选取好条件后进行筛选
- (void)chooseWineBy:(int)sortkey{
    pageCount=1;
    
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic removeObjectForKey:@"categoryid"];
    [nowDic setObject:[NSString stringWithFormat:@"%d",sortkey] forKey:@"categoryid"];
    [self getData:nowDic];
    NSLog(@"筛选出所有：%d",sortkey);
}

#pragma 点击更多按钮弹出界面
- (void)showMoreButtons{
    if(_moreShow == NO){
        _moreShow = YES;
        
    self.collectionView.userInteractionEnabled = NO;
    
    _MoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, biaoqianList.count * 32 + (biaoqianList.count + 1) * 16)];
    [_MoreView setBackgroundColor:[UIColor whiteColor]];
    
    for(int i = 0 ; i < biaoqianList.count ; i ++){
        for(int j = 0 ; j < 3 ; j ++){
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake( 8 * (j + 1) + 96 * j, 16 * (i + 1) + 32 * i, 96, 32)];
            [button setBackgroundColor:RGBA(217, 217, 217, 1)];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.borderColor = (__bridge CGColorRef _Nullable)(RGBA(151, 151, 151, 1));
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:((ProductCategoryModel *)biaoqianList[i][j]).name forState:UIControlStateNormal];
            [button setTag:((ProductCategoryModel *)biaoqianList[i][j]).id];
            [button addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
            [_MoreView addSubview:button];
        }
    }
        [self.view addSubview:_MoreView];
    }else{
        _moreShow = NO;
        [_sxBtn5 setTitle:@"" forState:UIControlStateNormal];
        [_sxBtn5 setBackgroundColor:RGBA(114, 5, 147, 1)];
        [_sxBtn5 setImage:[UIImage imageNamed:@"more_white"] forState:UIControlStateNormal];
        [_MoreView removeFromSuperview];
        _collectionView.userInteractionEnabled = YES;
    }
}

#pragma 点击更多界面中按钮后发生的事情
- (void)chooseType:(UIButton *)sender{
    [self.MoreView removeFromSuperview];
    
    [sender setBackgroundColor:RGBA(114, 5, 147, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [_sxBtn5 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_sxBtn5 setBackgroundColor:[UIColor whiteColor]];
    [_sxBtn5 setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
    [_sxBtn5 setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    _moreShow = NO;
    _collectionView.userInteractionEnabled = YES;
    
    chooseKey = (int)sender.tag;
    
    [self chooseWineBy:chooseKey];
}

- (void)addShaiXuan:(NSMutableArray *)arr{
    pageCount=1;
    
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
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
