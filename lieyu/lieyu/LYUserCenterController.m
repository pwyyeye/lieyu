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
#import "LYUserCenterFooter.h"

#import "TuiJianShangJiaViewController.h"//推荐商家
#import "MyCollectionViewController.h"//我的收藏
#import "LYMyOrderManageViewController.h"//我的订单
#import "Setting.h"//设置
#import "MyZSManageViewController.h"//我的专属经理
#import "LYCarListViewController.h"//购物车
#import "MyMessageListViewController.h"//我的消息列表
#import "LYUserHttpTool.h"


@interface LYUserCenterController ()

@end

@implementation LYUserCenterController

static NSString * const reuseIdentifier = @"userCenterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate=self;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        self.automaticallyAdjustsScrollViewInsets =YES;
        self.edgesForExtendedLayout=UIRectEdgeTop;
        [self.navigationController setNavigationBarHidden:YES];
    }else{
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.title=@"我的";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[LYUserCenterCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[LYUserCenterHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader"];
    
  
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LYUserCenterFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"userCenterFooter"];
    //

    _data=@[@{@"title":@"购物车",@"icon":@"userShopCart"},@{@"title":@"收藏",@"icon":@"userFav"},@{@"title":@"专属经理",@"icon":@"userManager"},@{@"title":@"推荐猎娱",@"icon":@"userTuijian"},@{@"title":@"帮助与反馈",@"icon":@"userHelp"},@{@"title":@"",@"icon":@""}];
 
    
    self.collectionView.backgroundColor=RGBA(242, 242, 242, 1);
    self.collectionView.bounces=NO;//遇到边框不反弹
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadUserInfo" object:nil];
    
}
-(void)loadData{
    [self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
                self.collectionView.contentInset = UIEdgeInsetsMake(0,  0,  0,  0);
    }
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden==NO) {
       [self.navigationController setNavigationBarHidden:YES];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.navigationController.navigationBarHidden==NO) {
        [self.navigationController setNavigationBarHidden:YES];
    }
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LYUserCenterCell *cell = (LYUserCenterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.icon.image=nil;
    [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//    cell.icon.frame=CGRectMake(0, 15, 80, 30);
//    cell.text.frame=CGRectMake(0, 70, 80, 20);
    
//     NSLog(@"----pass-------%@---", NSStringFromCGRect(cell.icon.frame));
    cell.text.text=@"";
    if (indexPath.row<6) {
        NSDictionary *dic=_data[indexPath.row];
        cell.icon.image=[UIImage imageNamed:[dic objectForKey:@"icon"]];
        cell.text.text=[dic objectForKey:@"title"];
    }
    return cell;
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            
        case 0://购物车
        {
            
            LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
            carListViewController.title=@"购物车";
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app.navigationController pushViewController:carListViewController animated:YES];
            break;

            
        }
            
        case 1:// 收藏
        {
            
            MyCollectionViewController *maintViewController=[[MyCollectionViewController alloc]initWithNibName:@"MyCollectionViewController" bundle:nil];
            maintViewController.title=@"我的收藏";
            [self.navigationController pushViewController:maintViewController animated:YES];
            break;
            
        }
            
        case 2:// 专属经理
        {
            MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
            myZSManageViewController.title=@"我的专属经理";
            myZSManageViewController.isBarVip=false;
            [self.navigationController pushViewController:myZSManageViewController animated:YES];
            
            break;

        }
            
        case 3:
        {
           
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UmengAppkey
                                              shareText:@"猎娱带你玩转酒吧夜店，无需再担心隐形消费，遇到酒托，所有商家均严格筛选认证，明码标价，尊享专属VIP经理一对一服务，喝酒消费更有超额返利等你来拿！https://itunes.apple.com/us/app/lie-yu-ye-sheng-huo-yu-le/id1056569271?l=zh&ls=1&mt=8"
                                             shareImage:[UIImage imageNamed:@"lieyuIcon"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                               delegate:nil];
            break;
        }
        case 4:// 反馈
        {
            RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
            conversationVC.conversationType = ConversationType_APPSERVICE;
            conversationVC.targetId = @"KEFU144946169476221";//KEFU144946169476221 KEFU144946167494566  测试 
            conversationVC.userName = @"猎娱客服";
            conversationVC.title = @"猎娱客服";
            
            [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back2"] style:UIBarButtonItemStylePlain target:nil action:nil]];
            [self.navigationController pushViewController:conversationVC animated:YES];
            break;
        }
        case 5:// 信息中心
        {
            break;
        }
            
        default://推荐商户
        {
            //            TuiJianShangJiaViewController *tuiJianShangJiaViewController=[[TuiJianShangJiaViewController alloc]initWithNibName:@"TuiJianShangJiaViewController" bundle:nil];
            //            tuiJianShangJiaViewController.title=@"推荐商家";
            //            [self.navigationController pushViewController:tuiJianShangJiaViewController animated:YES];
            //
            //            break;
        }
    }
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH)/4, (SCREEN_WIDTH)/4);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(8, 0, 8, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;
    if (kind==UICollectionElementKindSectionHeader) {
        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader" forIndexPath:indexPath];
        headerView.frame=CGRectMake(0, -20, SCREEN_WIDTH, 240);
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (![MyUtil isEmptyString:app.s_app_id]) {
            [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
                _orderTTL=result;
                LYUserCenterHeader *header=(LYUserCenterHeader *)headerView;
                [header loadBadge:_orderTTL];
            }];
        }

    }else if(kind==UICollectionElementKindSectionFooter){
        //判断是否专属经理
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(app.userModel.usertype.intValue==2||YES){
            headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"userCenterFooter" forIndexPath:indexPath];
        }
        
    }
    
    return headerView;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //因为顶到电池栏 所以 height 小20像素
        CGSize size = {SCREEN_WIDTH, 220};
        return size;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    //判断是否专属经理
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.userModel.usertype.intValue==2){
        CGSize size = {SCREEN_WIDTH, 50};
        return size;
    }else{
        CGSize size = {SCREEN_WIDTH, 0};
        return size;
    }
    
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
