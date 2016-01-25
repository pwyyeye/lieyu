//
//  ChiHeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/7.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChiHeViewController.h"
#import "LYHomePageHttpTool.h"
#import "MJRefresh.h"
#import "CHShaiXuanViewController.h"
#import "ProductCategoryModel.h"
#import "CHJiuPinDetailViewController.h"
#import "LYCarListViewController.h"

#import "UserModel.h"
#import "UIImage+GIF.h"

#import "ZSManageHttpTool.h"
//#import "LYBaseViewController.h"

@interface ChiHeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *dataList;
    NSMutableArray *goodsList;
    
    NSMutableDictionary *nowDic;
    int pageCount;
    int perCount;
    UIBarButtonItem *rightBtn;
    int goodsNumber;
    int chooseKey;
    NSMutableArray *biaoqianList;
    
    UILabel *_badge;
    
    UIImageView *kongImageView;
    UILabel *kongLabel;
    
    int num;
    
    NSString *buttonTitle;//筛选按钮的名称，即筛选的种类
}

//@property (nonatomic, strong) UILabel *badge;
@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIView *MoreView;
@property (nonatomic, assign) BOOL moreShow;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation ChiHeViewController

#pragma mark viewdidload
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.sxBtn1 setBackgroundColor:RGBA(114, 5, 147, 1)];
//    [self.sxBtn2 setBackgroundColor:RGBA(114, 5, 147, 1)];
//    [self.sxBtn3 setBackgroundColor:RGBA(114, 5, 147, 1)];
//    [self.sxBtn4 setBackgroundColor:RGBA(114, 5, 147, 1)];
//    [self.sxBtn5 setBackgroundColor:RGBA(114, 5, 147, 1)];
    
    _moreShow = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNumLess) name:@"lessGood" object:nil];
    
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 120);
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shoppingCar"] style:UIBarButtonItemStylePlain target:self action:@selector(showcarAct)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 18) / 2, 127 + SCREEN_WIDTH / 2);
    [self.collectionView setCollectionViewLayout:layout];
    
    dataList = [[NSMutableArray alloc]init];
    goodsList = [[NSMutableArray alloc]init];
    
    pageCount = 1;
    goodsNumber = 1;
    self.buttonsArray = @[_sxBtn1,_sxBtn2,_sxBtn3,_sxBtn4];
    
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:@{@"barid":[NSString stringWithFormat:@"%d",self.barid]}];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic setObject:@"20" forKey:@"per"];
    [self getData:nowDic];
//    [self geBiaoQianData];
    
    __weak __typeof(self)weakSelf = self;
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        pageCount=1;
        
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)self.collectionView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.collectionView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

#pragma mark viewwillDisappear
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    _badge.hidden = YES;
    [_badge setHidden:YES];
}

#pragma mark viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(((AppDelegate*)[[UIApplication sharedApplication] delegate]).userModel){
        [self getGoodsNum];
    }
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark viewDidAppear
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(num > 0){
        [_badge setHidden:NO];
    }
}



#pragma mark 获取酒品种类信息
-(void)geBiaoQianData{
    //获取酒水类型
    [biaoqianList removeAllObjects];
//    __weak __typeof(self)weakSelf = self;
    [[ZSManageHttpTool shareInstance] getProductCategoryListWithParams:nil block:^(NSMutableArray *result) {
//        biaoqianList = [weakSelf setRow:result];
        biaoqianList = [result mutableCopy];
        [self setItemsData];
    }];
}

#pragma mark 设置标签栏数据
- (void)setItemsData{
    for (int i = 0 ; i < _buttonsArray.count; i ++) {
        [((ShaiXuanBtn *)_buttonsArray[i]) setBackgroundColor:RGBA(114, 5, 147, 1)];
        [((ShaiXuanBtn *)_buttonsArray[i]) setTitle:((ProductCategoryModel *)biaoqianList[i]).name forState:UIControlStateNormal];
        [((ShaiXuanBtn *)_buttonsArray[i]) setTag:((ProductCategoryModel *)biaoqianList[i]).id];
    }
    [_sxBtn5 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [_sxBtn5 setTag:105];
}

#pragma mark 获取购物车数据
-(void)getGoodsNum{
    [[LYHomePageHttpTool shareInstance]getCarListWithParams:nil block:^(NSMutableArray *result) {
        goodsList=[result mutableCopy];
//        for (CarInfoModel *carInfoModel in goodsList) {
//            carInfoModel.isSel=true;
//            for (CarModel *carModel in carInfoModel.cartlist) {
//                carModel.isSel=true;
//            }
//        }
//        [self setSuperScript:goodsList.count];
        num = 0 ;
        for(int i = 0 ; i < goodsList.count ; i ++){
            num = num + ((CarInfoModel *)goodsList[i]).cartlist.count;
        }
        [self setSuperScript:num];
    }];
}

#pragma mark 设置角标
- (void)setSuperScript:(int)number{
    NSLog(@"%@",self.navigationController.childViewControllers);
    NSUInteger count = self.navigationController.childViewControllers.count;
    if(![[self.navigationController.childViewControllers objectAtIndex:count-1] isKindOfClass:[ChiHeViewController class]]){
        [_badge setHidden:YES];
    }else{
        if(number > 0){
            if(!_badge){
                [_badge setHidden:NO];
                _badge=[[UILabel alloc] init];
                _badge.backgroundColor=[UIColor redColor];
                _badge.font=[UIFont systemFontOfSize:8];
                _badge.layer.masksToBounds=YES;
                _badge.layer.cornerRadius=6;
                _badge.textColor=[UIColor whiteColor];
                _badge.textAlignment=NSTextAlignmentCenter;
                _badge.frame=CGRectMake(SCREEN_WIDTH - 17, 5, 12, 12);
            }
            if(number < 99){
                _badge.text=[NSString stringWithFormat:@"%d",number];
            }else{
                _badge.text = @"99+";
            }
            [self.navigationController.navigationBar addSubview:_badge];
        }else{
            [_badge setHidden:YES];
        }
    }
}

#pragma mark 将信息转为三列
-(NSMutableArray *)setRow:(NSMutableArray *)arr{
    int nowCount=1;
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
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

#pragma mark  back按钮点击事件
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 展示购物车
- (void)showcarAct{
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"吃喝专场",@"titleName":@"进入购物车",@"value":self.barName};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
    carListViewController.title=@"购物车";
    carListViewController.numrefreshdelegate = self;
    [self.navigationController pushViewController:carListViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获得数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        if(((AppDelegate*)[[UIApplication sharedApplication] delegate]).userModel){
            [self getGoodsNum];
        }
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        self.collectionView.contentOffset = CGPointMake(0, 0);
        if(dataList.count>0){
            [kongImageView removeFromSuperview];
            [kongLabel removeFromSuperview];
            pageCount++;
            [weakSelf.collectionView.mj_footer resetNoMoreData];
        }else{//改种酒类为空
            if(!kongImageView){
                kongImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 120, 100, 120)];
                [kongImageView setImage:[UIImage sd_animatedGIFNamed:@"gouGif"]];
                kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(kongImageView.frame.origin.x - 20, 260, 170, 20)];
                kongLabel.font = [UIFont systemFontOfSize:14];
                kongLabel.textColor = RGBA(215, 215, 215, 1);
                kongLabel.text = @"伦家还没有这个啦～";
//                [kongImageView addSubview:kongLabel];
            }
            [self.view addSubview:kongLabel];
            [self.view addSubview:kongImageView];
        }
        [weakSelf.collectionView reloadData];
        
        if(!biaoqianList){
            [self geBiaoQianData];
        }
    }];
    [weakSelf.collectionView.mj_header endRefreshing];
}

#pragma mark 获得更多数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}

#pragma mark collectionView的各个代理方法实现
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
    cell.layer.borderColor = [RGBA(237, 237, 237, 1)CGColor];
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = 2.f;
    cell.layer.masksToBounds = YES;
    cell.userInteractionEnabled = YES;
    
    
    cell.delegate = self;
    
    CheHeModel *chiHeModel=dataList[indexPath.row];
    chiHeModel.barname=self.barName;
    [cell configureCell:chiHeModel];
    return cell;
}

#pragma mark 实现RefreshGoodsNum的代理方法
- (void)refreshGoodsNum{
    [self getGoodsNum];
}

- (void)getNumLess{
    num--;
    [self setSuperScript:[_badge.text intValue] - 1];
}

- (void)getNumAdd{
    num++;
    [self setSuperScript:[_badge.text intValue] + 1];
}

#pragma mark --UIcollectionviewDelegateFlowLayout
//定义每个UIcollectionview 的大小
- (CGSize)collectionview:(UICollectionView *)collectionview layout:(UICollectionViewLayout*)collectionviewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 16) / 2, 127 + SCREEN_WIDTH / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma mark collectionview相应点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CheHeModel *chiHeModel=dataList[indexPath.row];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    CHJiuPinDetailViewController *jiuPinDetailViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHJiuPinDetailViewController"];
    
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"吃喝专场",@"titleName":@"进入单品详情",@"value":chiHeModel.name};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    jiuPinDetailViewController.title=@"单品详情";
    jiuPinDetailViewController.refreshNumDelegate = self;
    jiuPinDetailViewController.shopid=chiHeModel.id;
    [self.navigationController pushViewController:jiuPinDetailViewController animated:YES];

}

#pragma mark  返回这个UIcollectionview是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionview shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark sxBtnClick
- (IBAction)sxBtnClick:(ShaiXuanBtn *)sender {
    ShaiXuanBtn *btn=(ShaiXuanBtn*)sender;
    for (UIButton *button in _buttonsArray) {
        if(button.tag == btn.tag){
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:RGBA(114, 5, 147, 1)];
        }
    }
    [_sxBtn5 setBackgroundColor:RGBA(114, 5, 147, 1)];
    [_sxBtn5 setTitle:@"" forState:UIControlStateNormal];
    [_sxBtn5 setImage:[UIImage imageNamed:@"more_white"] forState:UIControlStateNormal];
    if(btn.tag == 105){
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setImage:[UIImage imageNamed:@"more_purper"] forState:UIControlStateNormal];
        [self showMoreButtons];
        return;
    }else{
        _moreShow = NO;
        [_MoreView removeFromSuperview];
        chooseKey = btn.tag;
    }
    buttonTitle = btn.titleLabel.text;
    [self chooseWineBy:chooseKey];
}

#pragma mark 选取好条件后进行筛选
- (void)chooseWineBy:(int)sortkey{
    pageCount=1;
    
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    [nowDic removeObjectForKey:@"categoryid"];
    [nowDic setObject:[NSString stringWithFormat:@"%d",sortkey] forKey:@"categoryid"];

    NSDictionary *dict = @{@"actionName":@"筛选",@"pageName":@"吃喝专场",@"titleName":buttonTitle};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self getData:nowDic];
}

#pragma mark 点击更多按钮弹出界面
- (void)showMoreButtons{
    if(_moreShow == NO){
        _moreShow = YES;
        
    self.collectionView.userInteractionEnabled = NO;
        int number;
        if(biaoqianList.count == 4){
            
        }else{
            if((int)(biaoqianList.count - 4) % 3){
                number = (int)(biaoqianList.count - 4) / 3 + 1;
            }
            else{
                number = (int)(biaoqianList.count - 4) / 3;
            }
        }
    _MoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, number * 32 + (number + 1) * 16)];
    [_MoreView setBackgroundColor:[UIColor whiteColor]];
    
    for(int i = 4 ; i < biaoqianList.count ; i ++){
        int row = (i - 4) / 3;
        int lie = (i - 4) % 3;
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake( 8 * (lie + 1) + (SCREEN_WIDTH - 32) / 3 * lie, 16 * (row + 1) + 32 * row, (SCREEN_WIDTH - 32) / 3, 32)];
            [button setBackgroundColor:RGBA(217, 217, 217, 1)];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.borderColor = (__bridge CGColorRef _Nullable)(RGBA(151, 151, 151, 1));
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:((ProductCategoryModel *)biaoqianList[i]).name forState:UIControlStateNormal];
            [button setTag:((ProductCategoryModel *)biaoqianList[i]).id];
            [button addTarget:self action:@selector(chooseTypes:) forControlEvents:UIControlEventTouchUpInside];
            [_MoreView addSubview:button];
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

#pragma mark 点击更多界面中按钮后发生的事情
- (void)chooseTypes:(UIButton *)sender{
    [self.MoreView removeFromSuperview];
    
    [sender setBackgroundColor:RGBA(114, 5, 147, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_sxBtn5 setBackgroundColor:[UIColor whiteColor]];
    [_sxBtn5 setTitleColor:RGBA(114, 5, 147, 1) forState:UIControlStateNormal];
    [_sxBtn5 setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    _moreShow = NO;
    _collectionView.userInteractionEnabled = YES;
    
    chooseKey = (int)sender.tag;
    buttonTitle = sender.titleLabel.text;
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
