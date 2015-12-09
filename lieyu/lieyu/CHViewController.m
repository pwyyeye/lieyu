//
//  CHViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHViewController.h"

#import "LYHomePageHttpTool.h"
#import "chiheDetailCollectionCell.h"
#import "MJRefresh.h"
#import "CHShaiXuanViewController.h"
#import "ProductCategoryModel.h"
#import "CHJiuPinDetailViewController.h"
#import "LYCarListViewController.h"

@interface CHViewController ()<CHShaiXuanDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *dataList;
    NSMutableDictionary *nowDic;
    int pageCount;
    int perCount;
    UIBarButtonItem *rightBtn;
    int goodsNumber;
    NSString *chooseKey;
}

@property (nonatomic, strong) NSArray *buttonsArray;

@end

@implementation CHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.itemButton1.frame = CGRectMake(0, 64, 64, 36);
//    
//    self.collectionview.dataSource = self;
//    self.collectionview.delegate = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"chiheDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"chiheCell"];
    
    [self.itemButton1 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [self.itemButton2 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [self.itemButton3 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [self.itemButton4 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [self.itemButton5 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shoppingCar"] style:UIBarButtonItemStylePlain target:self action:@selector(showcarAct)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    dataList = [[NSMutableArray alloc]init];
    pageCount = 1;
    goodsNumber = 1;
    chooseKey = @"";
    self.buttonsArray = @[_itemButton1,_itemButton2,_itemButton3,_itemButton4];
    
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:@{@"barid":[NSString stringWithFormat:@"%d",self.barid]}];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic setObject:@"20" forKey:@"per"];
    [self getData:nowDic];
    __weak __typeof(self)weakSelf = self;
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    self.collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
    _itemButton1.selected=true;

}
#pragma 返回按键点击事件
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        
        if(dataList.count>0){
            
            pageCount++;
            [weakSelf.collectionview.mj_footer resetNoMoreData];
        }

            [weakSelf.collectionview reloadData];
        
    }];
    [weakSelf.collectionview.mj_header endRefreshing];
}
#pragma mark 获取更多数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.collectionview reloadData];
        }else{
            [weakSelf.collectionview.mj_footer noticeNoMoreData];
        }
    }];
    
    [weakSelf.collectionview.mj_footer endRefreshing];
    
}

//定义展示的UIcollectionviewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"--------------section:%d",dataList.count);
    if(dataList.count > 0){
        return dataList.count;
    }else{
        return 0;
    }
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"--------------row:%d",dataList.count);
    return 1;
}





//每个UIcollectionview展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"--------------indexPath:%@",indexPath);
    if(dataList.count > 0){
        static NSString * CellIdentifier = @"chiheCell";
        chiheDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if(!cell){
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"chiheDetailCollectionCell" owner:nil options:nil]firstObject];
        }
        cell.goodImage.image=nil;
        //    cell.layer.borderColor = (__bridge CGColorRef _Nullable)(RGBA(217, 217, 217, 217));
        cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        cell.layer.borderWidth = 0.5;
        cell.layer.cornerRadius = 5.f;
        cell.layer.masksToBounds = YES;
        
        CheHeModel *chiHeModel=dataList[indexPath.row];
        chiHeModel.barname=self.barName;
        [cell configureCell:chiHeModel];
        return cell;
    }else{
        return nil;
    }
}

#pragma mark --UIcollectionviewDelegateFlowLayout
//定义每个UIcollectionview 的大小
- (CGSize)collectionview:(UICollectionView *)collectionview layout:(UICollectionViewLayout*)collectionviewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(152, 288);
}

#pragma mark --UIcollectionviewDelegate
//UIcollectionview被选中时调用的方法
-(void)collectionview:(UICollectionView *)collectionview didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CheHeModel *chiHeModel=dataList[indexPath.row];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    CHJiuPinDetailViewController *jiuPinDetailViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHJiuPinDetailViewController"];
    jiuPinDetailViewController.title=@"套餐详情";
    jiuPinDetailViewController.shopid=chiHeModel.id;
    [self.navigationController pushViewController:jiuPinDetailViewController animated:YES];
    
    
}
//返回这个UIcollectionview是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionview shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 通过加号减号修改数量
- (IBAction)changeType:(UIButton *)sender {
    ShaiXuanBtn *btn=(ShaiXuanBtn*)sender;
    //    NSString *sortkey=@"";
    //    NSString *choosekey = @"";
    for (UIButton *button in _buttonsArray) {
        if(button.tag == btn.tag){
            button.selected = YES;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
        }else{
            button.selected = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:RGBA(114, 5, 147, 0.85)];
        }
    }
    if(btn.tag == 100){
        chooseKey = @"洋酒";
    }else if(btn.tag == 101){
        chooseKey = @"红酒";
    }else if (btn.tag == 102){
        chooseKey = @"啤酒";
    }else if(btn.tag == 103){
        chooseKey = @"鸡尾酒";
    }else{
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setImage:[UIImage imageNamed:@"more_purper"] forState:UIControlStateNormal];
        return;
    }
    [self chooseWineBy:chooseKey];
}

- (IBAction)changeNumber:(UIButton *)sender {
}

- (IBAction)AddToShoppingCar:(UIButton *)sender {
}

#pragma 选取好条件后进行筛选
- (void)chooseWineBy:(NSString *)sortkey{
    pageCount=1;
    
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic removeObjectForKey:@"sort"];
    [nowDic setObject:sortkey forKey:@"sort"];
    [self getData:nowDic];
    NSLog(@"筛选出所有：%@",sortkey);
}

#pragma 点击更多按钮弹出界面
- (void)showMoreButtons{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, 64)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(8, 52, 96, 32)];
    button1.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    button1.layer.borderWidth = 0.5;
    button1.layer.cornerRadius = 3;
    button1.layer.masksToBounds = YES;
    [button1 setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button1 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [button1 setTag:81];
    [button1 addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(112, 52, 96, 32)];
    button2.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    button2.layer.borderWidth = 0.5;
    button2.layer.cornerRadius = 3;
    button2.layer.masksToBounds = YES;
    [button2 setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button2 setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [button2 setTag:82];
    [button2 addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma 点击更多界面中按钮后发生的事情
- (void)chooseType:(UIButton *)sender{
    [sender setBackgroundColor:RGBA(114, 5, 147, 0.85)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_itemButton5 setBackgroundColor:[UIColor whiteColor]];
    [_itemButton5 setTitleColor:RGBA(114, 5, 147, 0.85) forState:UIControlStateNormal];
    [_itemButton5 setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if(sender.tag == 81){
        chooseKey = @"香槟";
    }else if(sender.tag == 82){
        chooseKey = @"其他";
    }
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
-(void)showcarAct{
    LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
    carListViewController.title=@"购物车";
    [self.navigationController pushViewController:carListViewController animated:YES];
}


@end