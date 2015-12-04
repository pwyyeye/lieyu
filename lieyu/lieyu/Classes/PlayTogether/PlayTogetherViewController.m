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

@interface PlayTogetherViewController
()<ShaiXuanDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
}
@property(nonatomic,weak) IBOutlet UIButton * allListButton;
@property(nonatomic,weak) IBOutlet UIButton * nearDistanceButton;
@property(nonatomic,strong) IBOutlet UIButton * fillterButton;
@property(nonatomic,strong) NSArray *oriNavItems;
@property (nonatomic, strong) UIView *sectionView;

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation PlayTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.frame = CGRectMake(0, 68, SCREEN_WIDTH, 370);
    }
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    dataList=[[NSMutableArray alloc]init];
    pageCount=1;
    perCount=20;
    [self setupViewStyles];
    [self getDataForTogether];
    __weak __typeof(self)weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _sectionView.backgroundColor = [UIColor whiteColor];
    NSArray *arrayKeys = @[@"fontName",@"fontSize",@"textColor",@"content",@"imageW",@"imageH",@"imageUnSelectedName",@"imageSelectedName"];
    NSArray *array1 = @[@"FZLTXHK",@"14",RGBA(30, 30, 30, 1),@"所有地区",@"24",@"24",@"triangle_down",@"triangle_up"];
    NSArray *array2 = @[@"FZLTXHK",@"14",[UIColor colorWithRed:30 green:30 blue:30 alpha:1],@"音乐清吧",@"24",@"24",@"triangle_down",@"triangle_up"];
    NSArray *array3 = @[@"FZLTXHK",@"14",[UIColor colorWithRed:30 green:30 blue:30 alpha:1],@"离我最近",@"24",@"24",@"triangle_down",@"triangle_up"];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:array1 forKeys:arrayKeys];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:array2 forKeys:arrayKeys];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:array3 forKeys:arrayKeys];
    
    UIView *partView1 = [[UIView alloc]initWithFrame:CGRectMake(319 / 3, 13, 0.5, 14)];
    partView1.backgroundColor = RGBA(204, 204, 204, 1);
    [_sectionView addSubview:partView1];
    
    UIView *partView2 = [[UIView alloc]initWithFrame:CGRectMake(319 / 3 * 2, 13, 0.5, 14)];
    partView2.backgroundColor = RGBA(204, 204, 204, 1);
    [_sectionView addSubview:partView2];

    LPSelectButton *button1 = [[LPSelectButton alloc]initWithFrame:CGRectMake(0, 0, 319/3, 40) AndDictionary:dict1];
    button1.tag = 1;
    LPSelectButton *button2 = [[LPSelectButton alloc]initWithFrame:CGRectMake(319/3, 0, 319/3, 40) AndDictionary:dict2];
    button2.tag = 2;
    LPSelectButton *button3 = [[LPSelectButton alloc]initWithFrame:CGRectMake(319/3 * 2, 0, 319/3, 40) AndDictionary:dict3];
    button3.tag = 3;
    
    [button1 addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonsArray = [[NSArray alloc]initWithObjects:button1, button2, button3, nil];
    
    [self.sectionView addSubview:button1];
    [self.sectionView addSubview:button2];
    [self.sectionView addSubview:button3];
    
    return _sectionView;
}
//,@[@"宝山区",@"嘉定区",@"黄浦区",@"青浦区",@"闵行区",@"奉贤区",@"金山区",@"松江区",@"南汇区"]
//,@[@"音乐清吧",@"激情夜店",@"文艺静吧",@"舞动KTV"]
//,@[@"1公里以内",@"5公里以内",@"10公里以内",@"20公里以内"]
- (void)changeSelection:(LPSelectButton *)button{
    for (LPSelectButton *btn in _buttonsArray) {
        if(btn.tag == button.tag){
            if(btn.selected == YES){
                btn.selected = NO;
                btn.imageIcon.image = [UIImage imageNamed:@"triangle_down"];
            }else{
                btn.selected = YES;
                btn.imageIcon.image = [UIImage imageNamed:@"triangle_up"];
            }
        }else{
            btn.imageIcon.image = [UIImage imageNamed:@"triangle_down"];
            btn.selected = NO;
        }
    }
    if(self.selectView == nil){
        self.selectView = [[UIView alloc]init];
        self.itemsArray =
  @[
    @[@"宝山区",@"嘉定区",@"黄浦区",@"青浦区",@"闵行区",@"奉贤区",@"金山区",@"松江区",@"南汇区"],
    @[@"音乐清吧",@"激情夜店",@"文艺静吧",@"舞动KTV"],
    @[@"离我最近",@"1公里以内",@"5公里以内",@"10公里以内",@"20公里以内"]
  ];
        
    }
//    [self.selectView removeFromSuperview];
    NSArray *array = self.itemsArray[button.tag - 1];
    [self showSelectView:array];
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
    return 40;
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
            [weakSelf.tableView.footer noticeNoMoreData];
        }
        
        
        
    }];
    [weakSelf.tableView.footer endRefreshing];
    
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
            [weakSelf.tableView.footer resetNoMoreData];
        }
        [weakSelf.tableView reloadData];
        
        
        
    }];
    [weakSelf.tableView.header endRefreshing];
    
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
    [super viewWillDisappear:animated];
//    [self performSelector:@selector(setCustomTitle:) withObject:@"一起玩" afterDelay:0.1];
    self.oriNavItems = [self.navigationController.navigationBar.items copy];
    [self.navigationController.navigationBar addSubview:_fillterButton];
    CGRect rc = _fillterButton.frame;
    rc.origin.x = 10;
    rc.origin.y = 8;
    _fillterButton.frame = rc;
    
//    [self setCustomTitle:@"一起玩"];
    _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    
    _myTitle.backgroundColor = [UIColor clearColor];
    _myTitle.textColor=[UIColor whiteColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    [_myTitle setFont:[UIFont systemFontOfSize:16.0]];
    [_myTitle setText:@"热门拼客"];
    //        self.navigationItem.titleView=titleText;
    [self.navigationController.navigationBar addSubview:_myTitle];
   

}
- (void)viewWillLayoutSubviews
{

    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];

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
