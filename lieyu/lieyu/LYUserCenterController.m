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

@interface LYUserCenterController ()<TencentSessionDelegate>{
    NSInteger num,orderNum;
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

    _data=@[
      @{@"title":@"订单",@"icon":@"userShopOrder"},
  @{@"title":@"购物车",@"icon":@"userShopCart"},
  @{@"title":@"收藏",@"icon":@"userFav"},
//  @{@"title":@"专属经理",@"icon":@"userManager"},
      @{@"title":@"帮助与反馈",@"icon":@"userHelp"},
      @{@"title":@"速核码",@"icon":@"userSuHeMa"},
    @{@"title":@"扫一扫",@"icon":@"userSaoYiSao"},
      @{@"title":@"设置",@"icon":@"userSetting"},
  @{@"title":@"推荐猎娱",@"icon":@"userTuijian"},
      ];
 
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
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
                    NSIndexPath *indexP = [NSIndexPath indexPathForItem:0 inSection:0];
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
    [self loadHeaderViewBadge];
    [self getGoodsNum];
    
//    [self loadHeaderView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.collectionView reloadData];
    
}

- (void)loadHeaderView{
    [_headerView removeFromSuperview];
    CGFloat height = 0.f;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.userModel.usertype.intValue==2){
        height = 239;
    }else{
        height = 179;
    }
    
    
    self.collectionView.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height - 49);
    _headerView = [[LYUserCenterHeader alloc]init];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    if(app.userModel.usertype.intValue==2){
//        _headerView.btnChange_cons_width.constant = 60;
        _headerView.btnChange.hidden = NO;
    }else{
//        _headerView.btnChange_cons_width.constant = 0;
        _headerView.btnChange.hidden = YES;
    }
    [self.view addSubview:_headerView];
//    [self loadHeaderViewBadge];
    [self getGoodsNum];
}
-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (![MyUtil isEmptyString:self.title]) {
        [MTA trackPageViewBegin:self.title];
    }
    [super viewWillAppear:animated];

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
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LYUserCenterCell *cell = (LYUserCenterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.icon.image=nil;
    [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
    
    cell.text.text=@"";
//    if (indexPath.row<6) {
        NSDictionary *dic=_data[indexPath.row];
        cell.icon.image=[UIImage imageNamed:[dic objectForKey:@"icon"]];
        cell.text.text=[dic objectForKey:@"title"];
    if (indexPath.row == 4) {
        cell.labeltext_cons_center.constant = 20;
    }
    if(indexPath.row == 1){
        if(num){
            cell.btn_count.hidden = NO;
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
        }else{
                cell.btn_count.hidden = YES;
        }
        
    }else if (indexPath.row == 0){
        if (_headerView.badgeNum > 0) {
            cell.btn_count.hidden = NO;
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%d",_headerView.badgeNum] forState:UIControlStateNormal];
        }
    }else{
        cell.btn_count.hidden = YES;
    }
    
    if(indexPath.row == 0){
        if(orderNum){
            cell.btn_count.hidden = NO;
            [cell.btn_count setTitle:[NSString stringWithFormat:@"%ld",orderNum] forState:UIControlStateNormal];
        }else{
            cell.btn_count.hidden = YES;
        }
        
    }else{
        cell.btn_count.hidden = YES;
    }
    
    if (indexPath.row % 3 == 2) {
        cell.layerShadowRight.hidden = YES;
    }else{
        cell.layerShadowRight.hidden = NO;
    }
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
             NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"订单"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            LPMyOrdersViewController *myOrderVC = [[LPMyOrdersViewController alloc]init];
            myOrderVC.bagesArr = _headerView.badgesArray;
            myOrderVC.orderIndex = 0;
            //    LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
            //    myOrderManageViewController.title=@"我的订单";
            //    myOrderManageViewController.orderType=orderType;
            //    [app.navigationController pushViewController:myOrderManageViewController animated:YES];
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }
            break;
            
        case 1://购物车
        {
            //统计我的页面的选择
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"购物车"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
            carListViewController.title=@"购物车";
            [self.navigationController pushViewController:carListViewController animated:YES];
            break;

            
        }
            
        case 2:// 收藏
        {
            //统计我的页面的选择
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"收藏"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
            maintViewController.title=@"我的收藏";
            [self.navigationController pushViewController:maintViewController animated:YES];
            break;
            
        }
            
//        case 2:// 专属经理
//        {
//            //统计我的页面的选择
//            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"专属经理"};
//            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
//            
//            MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
//            myZSManageViewController.title=@"我的专属经理";
//            myZSManageViewController.isBarVip=false;
//            [self.navigationController pushViewController:myZSManageViewController animated:YES];
//            
//            break;
//
//        }
            
        case 7:
        {
            //统计我的页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"我的主页面",@"titleName":@"分享"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            NSString *string= [NSString stringWithFormat:@"猎娱 | 中高端玩咖美女帅哥社交圈，轻奢夜生活娱乐！"];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
            [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:[UIImage imageNamed:@"CommonIcon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
            break;
        }
        case 3:// 反馈
        {
            //统计我的页面的选择
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"客服"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
            conversationVC.conversationType = ConversationType_APPSERVICE;
            conversationVC.targetId = @"KEFU144946169476221";//KEFU144946169476221 KEFU144946167494566  测试 
//            conversationVC.userName = @"猎娱客服";
            conversationVC.title = @"猎娱客服";
            [IQKeyboardManager sharedManager].enable = NO; 
            [IQKeyboardManager sharedManager].isAdd = YES;
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
            [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
            [view addSubview:button];
            [button addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
            conversationVC.navigationItem.leftBarButtonItem = item;
            [self.navigationController pushViewController:conversationVC animated:YES];
            [conversationVC.navigationController setNavigationBarHidden:NO animated:YES];
            break;
        }
        case 5:// 扫一扫
        {
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择扫一扫"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            SaoYiSaoViewController *saoYiSaoViewController=[[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
            saoYiSaoViewController.title=@"扫一扫";
            [self.navigationController pushViewController:saoYiSaoViewController  animated:YES];
            
        }
            break;
        case 4:{//二维码
            MyCodeViewController *codeViewController = [[MyCodeViewController alloc]initWithNibName:@"MyCodeViewController" bundle:nil];
            [self.navigationController pushViewController:codeViewController animated:YES];
        }
            break;
        case 6:{
            NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"设置"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            Setting *setting =[[Setting alloc] init];
            [app.navigationController pushViewController:setting animated:YES];
        }
            break;
        case 8:{
                   }
            break;
            
        default://推荐商户
        {
            //            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
            //            tuiJianShangJiaViewController.title=@"推荐商家";
            //            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
            //
            //            break;
//            MyCodeViewController *codeViewController = [[MyCodeViewController alloc]initWithNibName:@"MyCodeViewController" bundle:nil];
//            [self.navigationController pushViewController:codeViewController animated:YES];
        }
    }
}


- (void)backForword{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH)/3, (SCREEN_WIDTH)/3);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *headerView;
//    if (kind==UICollectionElementKindSectionHeader) {
//        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader" forIndexPath:indexPath];
//        headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 240);
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        if (![MyUtil isEmptyString:app.s_app_id]) {
//            [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
//                _orderTTL=result;
//                LYUserCenterHeader *header=(LYUserCenterHeader *)headerView;
//                [header loadBadge:_orderTTL];
//            }];
//        }
//
//    }else if(kind==UICollectionElementKindSectionFooter){
//        //判断是否专属经理
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        if(app.userModel.usertype.intValue==2||YES){
////            headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"userCenterFooter" forIndexPath:indexPath];
//            return nil;
//        }
//        
//    }
//    
//    return headerView;
//}

/*
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //因为顶到电池栏 所以 height 小20像素
    CGFloat height = 0.f;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.userModel.usertype.intValue==2){
        height = 299;
    }else{
        height = 239;
    }
    CGSize size = {SCREEN_WIDTH, height};
        return size;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.f;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.userModel.usertype.intValue==2){
        height = 299;
    }else{
        height = 239;
    }
//    if (kind==UICollectionElementKindSectionHeader) {
    _headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader" forIndexPath:indexPath];
//        _headerView = [[LYUserCenterHeader alloc]init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        return _headerView;
//    }else{
//            return ;
//        }
} */

//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    
//    //判断是否专属经理
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(app.userModel.usertype.intValue==2){
//        CGSize size = {SCREEN_WIDTH, 50};
//        return size;
//    }else{
//        CGSize size = {SCREEN_WIDTH, 0};
//        return size;
//    }
//    
//}

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
