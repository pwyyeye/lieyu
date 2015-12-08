//
//  PlayTogetherViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PlayTogetherViewController.h"
#import "MacroDefinition.h"
#import "LYRestfulBussiness.h"
#import "MJRefresh.h"
#import "LYHomePageHttpTool.h"
#import "LYPlayTogetherCell.h"
#import "LYShaiXuanViewController.h"
#import "PinKeModel.h"
#import "ProductCategoryModel.h"
#import "LYPlayTogetherMainViewController.h"
#import "LYUserLocation.h"
#import "LPSelectButton.h"
#import "LPPlayTogetherViewController.h"

#import "LYHotBarMenuView.h"

#import "MenuButton.h"

@interface PlayTogetherViewController
()<ShaiXuanDelegate,UITableViewDelegate,UITableViewDataSource,LYHotBarMenuViewDelegate>
{
    NSMutableArray *dataList;
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
    
    NSArray *AddressArray;
    NSArray *TypeArray;
    NSArray *sortArray;
}
@property(nonatomic,weak) IBOutlet UIButton * allListButton;
@property(nonatomic,weak) IBOutlet UIButton * nearDistanceButton;
@property(nonatomic,strong) IBOutlet UIButton * fillterButton;
@property(nonatomic,strong) NSArray *oriNavItems;
@property (nonatomic, strong) UIView *sectionView;

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSArray *itemsArray;

//@property (nonatomic, strong) NSMutableArray *areaArray;
//@property (nonatomic, strong) NSMutableArray *typeArray;
//@property (nonatomic, strong) NSMutableArray *distanceArray;

@end

@implementation PlayTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-107);
    }

    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    dataList=[[NSMutableArray alloc]init];
    pageCount=1;
    perCount=20;
    [self setupViewStyles];
    [self getDataForTogether];
    [self getData];
    [self setMenuView];
    // Do any additional setup after loading the view.
}

- (void)getData{
    __weak __typeof(self)weakSelf = self;
    
    
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        pageCount=1;
        
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    // Do any additional setup after loading the view.

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

/**
 *description:
 dict:
 fontName
 fontSize
 textColor
 content
 imageW
 imageH
 imageUnSelectedName
 imageSelectedName
 *author:WTT
 */

- (void)setMenuView{
    LYHotBarMenuView *sectionView = [[LYHotBarMenuView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.delegate = self;
    AddressArray = @[@"所有地区",@"杨浦区",@"虹口区",@"闸北区",@"普陀区",@"黄浦区",@"静安区",@"长宁区",@"卢湾区",@"徐汇区",@"闵行区",@"浦东新区",@"宝山区",@"松江区",@"嘉定区",@"青浦区",@"金山区",@"奉贤区",@"南汇区",@"崇明县"];
    TypeArray = @[@"所有种类",@"激情夜店",@"文艺静吧",@"音乐清吧",@"舞动KTV"];
    sortArray = @[@"离我最近",@"人均最高",@"人均最低",@"返利最高"];
    
    [sectionView deployWithMiddleTitle:@"音乐清吧" ItemArray:@[AddressArray,TypeArray,sortArray]];
    [self.view addSubview:sectionView];
}

- (void)didClickHotBarMenuDropWithButton:(MenuButton *)button dropButton:(MenuButton *)dropButton{
    pageCount = 1;
    NSInteger index = dropButton.tag;
    [dataList removeAllObjects];
    [nowDic removeObjectForKey:@"p"];
    [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
    if(button.section == 1){
        [nowDic setObject:[AddressArray objectAtIndex:index] forKey:@"address"];
    }else if (button.section == 2){
        if(index == 0){
            [nowDic removeObjectForKey:@"subids"];
        }else if(index == 1){
            [nowDic setObject:@"2" forKey:@"subids"];
        }else if(index == 2){
            [nowDic setObject:@"1" forKey:@"subids"];
        }else if(index == 3){
            [nowDic setObject:@"6,7" forKey:@"subids"];
        }else{
            [nowDic setObject:@"4,5" forKey:@"subids"];
        }
    }else{//sort= //pricedesc 人均最高，priceasc人均最低，rebatedesc返利最高
        if(index == 0){
            [nowDic removeObjectForKey:@"sort"];
        }else if(index == 1){
            [nowDic setObject:@"pricedesc" forKey:@"sort"];
        }else if(index == 2){
            [nowDic setObject:@"priceasc" forKey:@"sort"];
        }else{
            [nowDic setObject:@"rebatedesc" forKey:@"sort"];
        }
    }
    [self getData:nowDic];
}


- (void)showSelectView:(NSArray *)array{
    
    int rows = (int)array.count / 3;
    self.selectView.frame = CGRectMake(0, 104, 320, 74 + 50 * (rows - 1 ));
    self.selectView.backgroundColor = [UIColor grayColor];
    
    for (int i = 0 ; i < array.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(7 + 108 * (i % 3), 20 + 50 * (i / 3), 90, 34)];
        [button setTitleColor:RGBA(26, 26, 26, 1) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.borderColor = (__bridge CGColorRef _Nullable)(RGBA(151, 151, 151, 1));
        button.layer.borderWidth = 0.5;
        [button setImage:[self imageWithColor:RGBA(255, 255, 255, 1) andSize:button.frame.size] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor grayColor]];
        [button setImage:[self imageWithColor:RGBA(114, 5, 147, 1) andSize:button.frame.size] forState:UIControlStateHighlighted];
        [button setTitle:array[i] forState:UIControlStateNormal];
//        button.enabled = YES;
        [self.selectView addSubview:button];
    }
    [self.view addSubview:self.selectView];
}

#pragma image
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYPlayTogetherCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"LYPlayTogetherCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor lightGrayColor];
    PinKeModel *pinKeModel =[dataList objectAtIndex:indexPath.row];
    [cell configureCell:pinKeModel];
    cell.pkBtn.tag=indexPath.row;
    [cell.pkBtn addTarget:self action:@selector(woYaoPin:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 148;
}

#pragma mark 获取更多一起玩数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;

    [[LYHomePageHttpTool shareInstance]getTogetherListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView.mj_footer noticeNoMoreData];
        }
    }];
    [weakSelf.tableView.mj_footer endRefreshing];
    
}

#pragma mark 获取数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherListWithParams:dic block:^(NSMutableArray *result) {
        [dataList removeAllObjects];
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        
        NSLog(@"****block%ld******",dataList.count);
        if(dataList.count>0){
            
            pageCount++;
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        [weakSelf.tableView reloadData];
        
        
        
    }];
    [weakSelf.tableView.mj_header endRefreshing];
    
}
-(void)getDataForTogether{
//    min_num=1(最低人数)
//    max_num=2(最高人数)
//    minprice＝100 (价格区间－最低价)
//    maxprice＝1000 (价格区间－最高价)
//    need_page＝1(是否需要分页统计)
//    p=1(页码)
//    per=20(每页多少笔记录 默认20)
//    sort=距离   //-asc(排序), //价格price_cn-asc/desc
//    priceasc
//    pricedesc
//    salesasc
//    salesdesc
//    rebateasc
//    rebatedesc
    pageCount=1;
    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount]};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getData:nowDic];
}

-(void)getDataForDistance{
    //    min_num=1(最低人数)
    //    max_num=2(最高人数)
    //    minprice＝100 (价格区间－最低价)
    //    maxprice＝1000 (价格区间－最高价)
    //    need_page＝1(是否需要分页统计)
    //    p=1(页码)
    //    per=20(每页多少笔记录 默认20)
    //    sort=距离   //-asc(排序), //价格price_cn-asc/desc
    //    priceasc
    //    pricedesc
    //    salesasc
    //    salesdesc
    //    rebateasc
    //    rebatedesc
    pageCount=1;
    [dataList removeAllObjects];
    CLLocation *userLocation=[LYUserLocation instance].currentLocation;
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount]};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    if(userLocation){
        [nowDic setObject:@(userLocation.coordinate.longitude).stringValue forKey:@"longitude"];
        [nowDic setObject:@(userLocation.coordinate.latitude).stringValue forKey:@"latitude"];
    }
    [self getData:nowDic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self performSelector:@selector(setCustomTitle:) withObject:@"一起玩" afterDelay:0.1];
//    self.oriNavItems = [self.navigationController.navigationBar.items copy];
//    [self.navigationController.navigationBar addSubview:_fillterButton];
//    CGRect rc = _fillterButton.frame;
//    rc.origin.x = 10;
//    rc.origin.y = 8;
//    _fillterButton.frame = rc;
    
//    [self setCustomTitle:@"一起玩"];
    _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    
    _myTitle.backgroundColor = [UIColor clearColor];
    _myTitle.textColor=[UIColor whiteColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    [_myTitle setFont:[UIFont systemFontOfSize:16.0]];
    [_myTitle setText:@"热门拼客"];
    //        self.navigationItem.titleView=titleText;
    [self.navigationController.navigationBar addSubview:_myTitle];
//    NSLog(@"----pass-self.tableView.contentInset.top%f---",self.tableView.contentInset.top);
//    //ios 7.0适配
//    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
////        if (self.tableView.contentInset.top==0||self.tableView.contentInset.top==44) {
//            self.tableView.contentInset = UIEdgeInsetsMake(64,  0,  0,  0);
//            self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-47);
////        }
//
//        
//    }
//   NSLog(@"----pass-self.tableView.contentInset.top2%f---",self.tableView.contentInset.top);

}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.navigationController.navigationBarHidden != NO ) {
        [self.navigationController setNavigationBarHidden:NO];

    }
    //ios 7.0适配
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        NSLog(@"----pass-self.tableView.contentInset.top%f---",self.tableView.contentInset.top);
//        if (self.tableView.contentInset.top==0 ||self.tableView.contentInset.top==128) {
            self.tableView.contentInset = UIEdgeInsetsMake(0,  0,  0,  0);
//        }

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    [self setCustomTitle:@""];

    [_fillterButton removeFromSuperview];
    [_myTitle removeFromSuperview];
    _myTitle=nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_fillterButton removeFromSuperview];
    [_myTitle removeFromSuperview];
    _myTitle=nil;
}

- (IBAction)filterClick:(id)sender
{

    
    LYShaiXuanViewController *shaiXuanViewController=[[LYShaiXuanViewController alloc]initWithNibName:@"LYShaiXuanViewController" bundle:nil];
    shaiXuanViewController.title=@"筛选";
    shaiXuanViewController.delegate=self;
    [self.navigationController pushViewController:shaiXuanViewController animated:YES];
}

- (void)setupViewStyles
{
    // 使用颜色创建UIImage//未选中颜色
    CGSize imageSize = CGSizeMake(self.nearDistanceButton.width, self.nearDistanceButton.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(255, 255, 255) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.allListButton setBackgroundImage:normalImg forState:UIControlStateSelected];
    [self.nearDistanceButton setBackgroundImage:normalImg forState:UIControlStateSelected];
    // 使用颜色创建UIImage //选中颜色
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(229, 255, 245) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.allListButton setBackgroundImage:selectedImg forState:UIControlStateNormal];
    [self.nearDistanceButton setBackgroundImage:selectedImg forState:UIControlStateNormal];
    self.allListButton.selected=YES;
    
//    UINib * playTogetherNib = [UINib nibWithNibName:@"LYPlayTogetherCell" bundle:nil];
//    [self.tableView registerNib:playTogetherNib forCellReuseIdentifier:@"LYPlayTogetherCell"];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 所有列表
- (IBAction)allListAct:(UIButton *)sender {
    self.allListButton.selected=YES;
    self.nearDistanceButton.selected=NO;
    [self getDataForTogether];
}
#pragma mark - 最近距离
- (IBAction)nearDistanceAct:(UIButton *)sender {
    self.allListButton.selected=NO;
    self.nearDistanceButton.selected=YES;
    [self getDataForDistance];
}

- (void)addCondition:(NSMutableArray *)arr{
    if(arr.count>0){
        pageCount=1;
        [dataList removeAllObjects];
        [nowDic removeObjectForKey:@"p"];
        [nowDic removeObjectForKey:@"minprice"];
        [nowDic removeObjectForKey:@"maxprice"];
        [nowDic removeObjectForKey:@"minnum"];
        [nowDic removeObjectForKey:@"maxnum"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        for (ProductCategoryModel *mode in arr) {
            if(mode.type==0){
                if([mode.minprice isEqualToString:@"10000"]){
                    [nowDic setObject:mode.minprice forKey:@"minprice"];
                }else{
                    [nowDic setObject:mode.maxprice forKey:@"maxprice"];
                    [nowDic setObject:mode.minprice forKey:@"minprice"];
                }
  
            }else if(mode.type==1){
                if([mode.minnum isEqualToString:@"15"]){
                    [nowDic setObject:mode.minnum forKey:@"minnum"];
                }else{
                    [nowDic setObject:mode.maxnum forKey:@"maxnum"];
                    [nowDic setObject:mode.minnum forKey:@"minnum"];
                }
            }
        }
        
        
        [self getData:nowDic];
    }
    
}

-(void)woYaoPin:(UIButton *)sender{
    PinKeModel *pinKeModel =[dataList objectAtIndex:sender.tag];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
//    LYPlayTogetherMainViewController *playTogetherMainViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
//    playTogetherMainViewController.title=@"我要拼客";
//    playTogetherMainViewController.smid=pinKeModel.smid;
//    [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
    
    LPPlayTogetherViewController *LPPlayVC = [stroyBoard instantiateViewControllerWithIdentifier:@"LPPlayVC"];
    LPPlayVC.title = @"我要拼客";
    LPPlayVC.smid = pinKeModel.smid;
    [self.navigationController pushViewController:LPPlayVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PinKeModel *pinKeModel = [dataList objectAtIndex:indexPath.row];
//    LYPlayTogetherMainViewController *playTogetherMainViewController = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LYPlayTogetherMainViewController"];
//    playTogetherMainViewController.title = @"我要拼客";
//    playTogetherMainViewController.smid = pinKeModel.smid;
//    [self.navigationController pushViewController:playTogetherMainViewController animated:YES];
    LPPlayTogetherViewController *LPPlayVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPPlayVC"];
    LPPlayVC.title = @"我要拼客";
    LPPlayVC.smid = pinKeModel.smid;
    [self.navigationController pushViewController:LPPlayVC animated:YES];
}

@end
