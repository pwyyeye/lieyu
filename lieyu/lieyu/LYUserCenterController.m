//
//  LYUserCenterController.m
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserCenterController.h"
#import "LYUserCenterHeader.h"
#import "LYUserLoginViewController.h"
#import "LYUserCenterCell.h"

#import "TuiJianShangJiaViewController.h"//推荐商家
#import "MyCollectionViewController.h"//我的收藏
#import "LYMyOrderManageViewController.h"//我的订单
#import "LPMyOrdersViewController.h"
#import "Setting.h"//设置
#import "MyZSManageViewController.h"//我的专属经理
#import "LYCarListViewController.h"//购物车
#import "MyMessageListViewController.h"//我的消息列表
#import "LYUserHttpTool.h"
#import "UserModel.h"
#import "IQKeyboardManager.h"
#import "UMSocial.h"
#import "UMSocialSnsPlatformManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "LYHomePageHttpTool.h"
#import "SaoYiSaoViewController.h"
#import "MyCodeViewController.h"
#import "ZSMaintViewController.h"
#import "LYMyOrderManageViewController.h"
#import "CarInfoModel.h"
#import "LPMyOrdersViewController.h"
#import "LYMyFreeOrdersViewController.h"
#import "ZSManageHttpTool.h"
#import "AddressBookModel.h"

@interface LYUserCenterController ()<TencentSessionDelegate>{
    NSInteger num,orderNum,freeOrderNum;
    LYUserCenterHeader *_headerView;
}

@end

@implementation LYUserCenterController

static NSString * const reuseIdentifier = @"userCenterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationController.delegate=self;

    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=@"我";
    
       // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[LYUserCenterCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[LYUserCenterHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LYUserCenterFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"userCenterFooter"];
    //

//    _data=@[
//      @{@"title":@"订单",@"icon":@"userShopOrder"},
//      @{@"title":@"免费订台",@"icon":@"free_order_icon"},
//      @{@"title":@"购物车",@"icon":@"userShopCart"},
//      @{@"title":@"收藏",@"icon":@"userFav"},
////  @{@"title":@"专属经理",@"icon":@"userManager"},
//      @{@"title":@"速核码",@"icon":@"userSuHeMa"},
//      @{@"title":@"扫一扫",@"icon":@"userSaoYiSao"},
//      @{@"title":@"设置",@"icon":@"userSetting"},
//      @{@"title":@"推荐猎娱",@"icon":@"userTuijian"},
//      @{@"title":@"帮助与反馈",@"icon":@"userHelp"},
//    ];
    
    _data=@[@[@{@"title":@"扫一扫",@"icon":@"userSaoYiSao"},],
            @[@{@"title":@"订单",@"icon":@"userShopOrder"},
              @{@"title":@"免费订台",@"icon":@"free_order_icon"},
              @{@"title":@"购物车",@"icon":@"userShopCart"},
              @{@"title":@"收藏",@"icon":@"userFav"},],
            @[@{@"title":@"设置",@"icon":@"userSetting"},
              @{@"title":@"推荐猎娱",@"icon":@"userTuijian"}],];
    
    self.collectionView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.collectionView.scrollEnabled = YES;
    self.collectionView.bounces = YES;//遇到边框不反弹
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadUserInfo" object:nil];
}

- (void)loadHeaderViewBadge{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    __weak __typeof(self) weakSelf = self;
    if (![MyUtil isEmptyString:app.s_app_id]) {
        [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
            _orderTTL=result;
            orderNum = result.waitPay + result.waitRebate + result.waitPayBack + result.waitEvaluation + result.waitConsumption;
            freeOrderNum=result.freeOrderNum;
            NSLog(@"-->%d----%d---%d---%d----%d",result.waitPay,result.waitConsumption,result.waitEvaluation,result.waitRebate,result.waitPayBack);
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:0 inSection:1];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexP]];
            indexP = [NSIndexPath indexPathForItem:1 inSection:1];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexP]];
//                    [weakSelf.collectionView reloadData];
            [_headerView loadBadge:_orderTTL];
        }];
    }
}

-(void)loadData{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [weakSelf.collectionView reloadData];
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadHeaderView];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self loadHeaderViewBadge];
    [self getGoodsNum];
}

- (void)loadHeaderView{
    [_headerView removeFromSuperview];
    CGFloat height = 0.f;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(app.userModel.usertype.intValue==2||app.userModel.usertype.intValue==3){
//        if (SCREEN_WIDTH==320) {
//            height=260;
//        }else{
//            height = 299;
//        }
//        
//    }else{
//        if (SCREEN_WIDTH==320) {
//            height = 209;
//        }else{
//            height = 239;
//        }
//        
//    }
    height = 312;
    
    
    self.collectionView.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height - 49);
    _headerView = [[LYUserCenterHeader alloc]init];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _headerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _headerView.layer.shadowOffset = CGSizeMake(0, 2);
    _headerView.layer.shadowRadius = 4;
    if(app.userModel.usertype.intValue==2||app.userModel.usertype.intValue==3){
//        _headerView.btnChange_cons_width.constant = 60;
        _headerView.btnChange.hidden = NO;
    }else{
//        _headerView.btnChange_cons_width.constant = 0;
        _headerView.btnChange.hidden = YES;
    }
    [self.view addSubview:_headerView];
}
-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (![MyUtil isEmptyString:self.title]) {
        [MTA trackPageViewBegin:self.title];
    }
    [super viewWillAppear:animated];
    UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (![MyUtil isEmptyString:self.title]) {
        [MTA trackPageViewEnd:self.title];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取购物车数据
-(void)getGoodsNum{
    __weak __typeof(self) weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCarListWithParams:nil block:^(NSMutableArray *result) {
        //        for (CarInfoModel *carInfoModel in goodsList) {
        //            carInfoModel.isSel=true;
        //            for (CarModel *carModel in carInfoModel.cartlist) {
        //                carModel.isSel=true;
        //            }
        //        }
        //        [self setSuperScript:goodsList.count];
        num = 0 ;
        for(int i = 0 ; i < result.count ; i ++){
            //            num = num + ((CarInfoModel *)goodsList[i]).cartlist.count;
            for (int j = 0 ; j < ((CarInfoModel *)result[i]).cartlist.count; j ++) {
                CarModel *shoppingCar = ((CarModel *)((CarInfoModel *)result[i]).cartlist[j]);
                num = num + [shoppingCar.quantity intValue];
            }
        }
        NSLog(@"---->%ld",num);
//        [weakSelf.collectionView reloadData];
//        [weakSelf loadData];
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:2 inSection:1];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexP]];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)[_data objectAtIndex:section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LYUserCenterCell *cell = (LYUserCenterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.btn_count.hidden = YES;
    [cell.btn_count setTitle:@"" forState:UIControlStateNormal];
        
    // Configure the cell
    cell.icon.image=nil;
    cell.text.text=@"";
        
    NSDictionary *dic=_data[indexPath.section][indexPath.row];
    cell.icon.image=[UIImage imageNamed:[dic objectForKey:@"icon"]];
    cell.text.text=[dic objectForKey:@"title"];
    if(indexPath.row == 2 && indexPath.section == 1){
        if(num > 0){
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
            cell.btn_count.hidden = NO;
        }
    }
    if(indexPath.row == 1 && indexPath.section == 1){
        if(freeOrderNum){
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%ld",freeOrderNum] forState:UIControlStateNormal];
            cell.btn_count.hidden = NO;
        }
    }
    if(indexPath.row == 0 && indexPath.section == 1){
        if(orderNum){
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%ld",orderNum] forState:UIControlStateNormal];
            cell.btn_count.hidden = NO;
        }
    }
        
    if (((NSArray *)_data[indexPath.section]).count == indexPath.row + 1) {
        cell.layerShadowBottom.hidden = YES;
    }else{
        cell.layerShadowBottom.hidden = NO;
    }
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //扫一扫
        NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择扫一扫"};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
        
        SaoYiSaoViewController *saoYiSaoViewController=[[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
        saoYiSaoViewController.title=@"扫一扫";
        [self.navigationController pushViewController:saoYiSaoViewController  animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //订单
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"订单"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            LPMyOrdersViewController *myOrderVC = [[LPMyOrdersViewController alloc]init];
            myOrderVC.bagesArr = _headerView.badgesArray;
            myOrderVC.orderIndex = 0;
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }else if (indexPath.row == 1){
            //免费订台
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"免费订台"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            LYMyFreeOrdersViewController *freeOrderVC = [[LYMyFreeOrdersViewController alloc]init];
            freeOrderVC.isFreeOrdersList = YES;
            [app.navigationController pushViewController:freeOrderVC animated:YES];
        }else if (indexPath.row == 2){
            //购物车
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"购物车"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
            carListViewController.title=@"购物车";
            [self.navigationController pushViewController:carListViewController animated:YES];
        }else if (indexPath.row == 3){
            //收藏
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"收藏"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
            maintViewController.title=@"我的收藏";
            [self.navigationController pushViewController:maintViewController animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //设置
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"设置"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            Setting *setting =[[Setting alloc] init];
            [app.navigationController pushViewController:setting animated:YES];
        }else if (indexPath.row == 1){
            //推荐猎娱
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"我的主页面",@"titleName":@"分享"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            NSString *string= [NSString stringWithFormat:@"猎娱 | 中高端玩咖美女帅哥社交圈，轻奢夜生活娱乐！"];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageNamed:@"CommonIcon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
        }
    }
}

- (void)backForword{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}



//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 40);
}

//定义每个UICollectionView 的 margin  section
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO];
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
//            [lastController viewWillDisappear:animated];
        }
        
        
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
//    [viewController viewWillAppear:animated];
    
 
}




@end
